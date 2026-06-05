import 'package:repforge/src/features/exercise_catalog/domain/exercise_catalog_domain.dart';
import 'package:repforge/src/features/recovery/application/recovery_application.dart';
import 'package:repforge/src/features/settings/application/settings_application.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

import '../../domain/analytics_domain.dart';
import '../read_models/muscle_load_dashboard_read_model.dart';

final class MuscleLoadDashboardQuery {
  MuscleLoadDashboardQuery({
    required DateTime now,
    this.weeklyWindow = const Duration(days: 7),
    this.rollingWindow = const Duration(days: 28),
    this.historyLimit = 100,
  }) : now = now.toUtc() {
    if (weeklyWindow <= Duration.zero) {
      throw ArgumentError.value(weeklyWindow, 'weeklyWindow');
    }
    if (rollingWindow < weeklyWindow) {
      throw ArgumentError.value(rollingWindow, 'rollingWindow');
    }
    if (historyLimit <= 0 || historyLimit > 100) {
      throw ArgumentError.value(historyLimit, 'historyLimit');
    }
  }

  final DateTime now;
  final Duration weeklyWindow;
  final Duration rollingWindow;
  final int historyLimit;
}

final class GetMuscleLoadDashboard {
  const GetMuscleLoadDashboard({
    required this.workoutSetRepository,
    required this.exerciseCatalogRepository,
    required this.loadSettingsProfile,
    required this.getTodayReadiness,
    this.estimator = const MuscleLoadEstimator(),
    this.detector = const MuscleBalanceDetector(),
  });

  final WorkoutSetRepository workoutSetRepository;
  final ExerciseCatalogRepository exerciseCatalogRepository;
  final LoadSettingsProfile loadSettingsProfile;
  final GetTodayReadiness getTodayReadiness;
  final MuscleLoadEstimator estimator;
  final MuscleBalanceDetector detector;

  Future<MuscleLoadDashboardReadModel> call(
    MuscleLoadDashboardQuery query,
  ) async {
    final history = await workoutSetRepository.searchHistory(
      WorkoutSetHistoryQuery(limit: query.historyLimit, offset: 0),
    );
    final settings = await loadSettingsProfile();
    final readiness = await getTodayReadiness();
    final rollingStart = query.now.subtract(query.rollingWindow);
    final weeklyStart = query.now.subtract(query.weeklyWindow);
    final rollingSets = _setsInWindow(
      history.items,
      startInclusive: rollingStart,
      endExclusive: query.now,
    );
    final weeklySets = _setsInWindow(
      history.items,
      startInclusive: weeklyStart,
      endExclusive: query.now,
    );
    final catalogExercises = await _catalogExercisesFor(rollingSets);
    final profiles = _activationProfilesFor(rollingSets, catalogExercises);
    final rollingEstimate = estimator.estimate(
      inputs: rollingSets.map(MuscleLoadInput.fromSet),
      profiles: profiles,
    );
    final weeklyEstimate = estimator.estimate(
      inputs: weeklySets.map(MuscleLoadInput.fromSet),
      profiles: profiles,
    );
    final assessment = detector.assess(
      MuscleBalanceInput(
        muscleLoadEstimate: rollingEstimate,
        loggedSetCount: rollingSets.length,
        focusProfile: settings.focusProfile,
        movementPatternCoverage: MovementPatternCoverage.known(
          patterns: _movementPatternsFor(catalogExercises.values),
        ),
        rollingWindow: MuscleBalanceRollingWindow(
          startInclusive: rollingStart,
          endExclusive: query.now,
        ),
      ),
    );

    return MuscleLoadDashboardReadModel(
      weeklyEstimate: weeklyEstimate,
      rollingEstimate: rollingEstimate,
      balanceAssessment: assessment,
      focusProfile: settings.focusProfile,
      readiness: readiness,
      weeklyLoggedSetCount: weeklySets.length,
      rollingLoggedSetCount: rollingSets.length,
      scannedSetCount: history.items.length,
      historyLimit: query.historyLimit,
      reachedHistoryLimit:
          history.hasMore || history.items.length >= query.historyLimit,
    );
  }

  List<WorkoutSet> _setsInWindow(
    Iterable<WorkoutSet> sets, {
    required DateTime startInclusive,
    required DateTime endExclusive,
  }) {
    return sets
        .where(
          (set) =>
              !set.performedAt.value.isBefore(startInclusive) &&
              set.performedAt.value.isBefore(endExclusive),
        )
        .toList(growable: false);
  }

  Future<Map<String, OfficialExercise>> _catalogExercisesFor(
    Iterable<WorkoutSet> sets,
  ) async {
    final ids = <String>{};
    for (final set in sets) {
      if (set.exerciseRef.source == ExerciseSource.official) {
        ids.add(set.exerciseRef.id);
      }
    }

    final exercises = <String, OfficialExercise>{};
    for (final id in ids) {
      final exercise = await exerciseCatalogRepository.findOfficialExerciseById(
        OfficialExerciseId(id),
      );
      if (exercise != null) {
        exercises[id] = exercise;
      }
    }

    return exercises;
  }

  List<ExerciseActivationProfile> _activationProfilesFor(
    Iterable<WorkoutSet> sets,
    Map<String, OfficialExercise> catalogExercises,
  ) {
    final seen = <String>{};
    final profiles = <ExerciseActivationProfile>[];
    for (final set in sets) {
      final ref = set.exerciseRef;
      final key = '${ref.source.name}:${ref.id}';
      if (!seen.add(key)) {
        continue;
      }
      if (ref.source != ExerciseSource.official) {
        profiles.add(
          ExerciseActivationProfile.unavailable(
            exerciseSource: ref.source,
            exerciseId: ref.id,
          ),
        );
        continue;
      }

      final exercise = catalogExercises[ref.id];
      if (exercise == null) {
        profiles.add(
          ExerciseActivationProfile.unavailable(
            exerciseSource: ref.source,
            exerciseId: ref.id,
          ),
        );
        continue;
      }

      profiles.add(_profileFromExercise(exercise));
    }

    return profiles;
  }

  ExerciseActivationProfile _profileFromExercise(OfficialExercise exercise) {
    final entries = <MuscleActivationEntry>[];
    final seen = <String>{};
    for (final muscle in exercise.primaryMuscles) {
      if (seen.add(muscle.value)) {
        entries.add(
          MuscleActivationEntry(
            muscleId: MuscleId(muscle.value),
            weight: ActivationWeight(1),
          ),
        );
      }
    }
    for (final muscle in exercise.secondaryMuscles) {
      if (seen.add(muscle.value)) {
        entries.add(
          MuscleActivationEntry(
            muscleId: MuscleId(muscle.value),
            weight: ActivationWeight(0.5),
          ),
        );
      }
    }

    return ExerciseActivationProfile.known(
      exerciseSource: ExerciseSource.official,
      exerciseId: exercise.id.value,
      entries: entries,
    );
  }

  List<MovementPattern> _movementPatternsFor(
    Iterable<OfficialExercise> exercises,
  ) {
    return exercises
        .expand((exercise) => exercise.movementPatterns)
        .toList(growable: false);
  }
}
