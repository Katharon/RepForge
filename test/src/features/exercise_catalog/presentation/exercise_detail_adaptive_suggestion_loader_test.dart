import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/exercise_catalog/domain/exercise_catalog_domain.dart';
import 'package:repforge/src/features/exercise_catalog/presentation/exercise_catalog_presentation.dart';
import 'package:repforge/src/features/recommendations/domain/recommendations_domain.dart';
import 'package:repforge/src/features/recovery/domain/recovery_domain.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

void main() {
  group('RepositoryExerciseDetailAdaptiveSuggestionLoader', () {
    test('returns null when no logged set exists', () async {
      final loader = _loader(sets: const <WorkoutSet>[]);

      final suggestion = await loader.load(_benchRef);

      expect(suggestion, isNull);
    });

    test(
      'uses bounded local history and keeps single-set advice partial',
      () async {
        final repository = _RecordingWorkoutSetRepository([
          _set(id: 'current', repetitions: 8, loadKg: 80),
        ]);
        final loader = _loader(repository: repository);

        final suggestion = await loader.load(_benchRef);

        expect(repository.requestedLimits, [2]);
        expect(suggestion, isNotNull);
        expect(suggestion!.direction, AdaptiveSetDirection.maintain);
        expect(suggestion.inputQuality, AdaptiveSetInputQuality.partial);
        expect(suggestion.hasComparableBaseline, isFalse);
        expect(suggestion.allowsWorkoutLogging, isTrue);
      },
    );

    test('suggests adding weight after exceeding the prior set', () async {
      final loader = _loader(
        sets: [
          _set(id: 'current', repetitions: 8, loadKg: 82.5),
          _set(
            id: 'baseline',
            repetitions: 8,
            loadKg: 80,
            performedAt: DateTime.utc(2026, 6, 5, 9),
          ),
        ],
      );

      final suggestion = await loader.load(_benchRef);

      expect(suggestion, isNotNull);
      expect(suggestion!.direction, AdaptiveSetDirection.addWeight);
      expect(suggestion.suggestedLoadKg, 85);
      expect(suggestion.suggestedRepetitions, 8);
      expect(suggestion.hasComparableBaseline, isTrue);
    });

    test('suggests adding reps when equipment load is capped', () async {
      final loader = _loader(
        sets: [
          _set(id: 'current', repetitions: 9, loadKg: 80),
          _set(
            id: 'baseline',
            repetitions: 8,
            loadKg: 80,
            performedAt: DateTime.utc(2026, 6, 5, 9),
          ),
        ],
        settings: SettingsProfile.defaults().copyWith(
          equipmentInventory: EquipmentInventory(
            const <AvailableEquipment>[AvailableEquipment.barbell],
            loadConstraints: {
              AvailableEquipment.barbell: EquipmentLoadConstraint(
                maxLoadKg: MaxLoadKg(80),
                incrementKg: LoadIncrementKg(2.5),
              ),
            },
          ),
        ),
      );

      final suggestion = await loader.load(_benchRef);

      expect(suggestion, isNotNull);
      expect(suggestion!.direction, AdaptiveSetDirection.addReps);
      expect(suggestion.suggestedLoadKg, 80);
      expect(suggestion.suggestedRepetitions, 10);
    });

    test('suggests a backoff when readiness is low', () async {
      final loader = _loader(
        sets: [
          _set(id: 'current', repetitions: 8, loadKg: 80),
          _set(
            id: 'baseline',
            repetitions: 8,
            loadKg: 80,
            performedAt: DateTime.utc(2026, 6, 5, 9),
          ),
        ],
        readiness: ReadinessReadModel(
          status: ReadinessReadModelStatus.available,
          forDate: DateTime.utc(2026, 6, 6),
          confidence: ReadinessConfidence.reported,
          latestCheckIn: null,
          score: ReadinessScore(45),
          level: ReadinessLevel.low,
          reasons: const <ReadinessReason>[ReadinessReason.lowEnergy],
        ),
      );

      final suggestion = await loader.load(_benchRef);

      expect(suggestion, isNotNull);
      expect(suggestion!.direction, AdaptiveSetDirection.backoff);
      expect(suggestion.suggestedRepetitions, 6);
      expect(suggestion.allowsWorkoutLogging, isTrue);
    });
  });
}

RepositoryExerciseDetailAdaptiveSuggestionLoader _loader({
  List<WorkoutSet>? sets,
  _RecordingWorkoutSetRepository? repository,
  ReadinessReadModel? readiness,
  SettingsProfile? settings,
}) {
  return RepositoryExerciseDetailAdaptiveSuggestionLoader(
    workoutSetRepository:
        repository ?? _RecordingWorkoutSetRepository(sets ?? _defaultSets),
    exerciseCatalogRepository: const _StaticExerciseCatalogRepository(),
    loadTodayReadiness: () async =>
        readiness ??
        ReadinessReadModel.empty(forDate: DateTime.utc(2026, 6, 6)),
    loadSettingsProfile: () async => settings ?? SettingsProfile.defaults(),
  );
}

final _benchRef = ExerciseRef.official(
  id: OfficialExerciseId('barbell_bench_press'),
  displayNameSnapshot: 'Barbell Bench Press',
  catalogVersionSnapshot: '2026.06.0',
);

final _defaultSets = [
  _set(id: 'current', repetitions: 8, loadKg: 80),
  _set(
    id: 'baseline',
    repetitions: 8,
    loadKg: 80,
    performedAt: DateTime.utc(2026, 6, 5, 9),
  ),
];

WorkoutSet _set({
  required String id,
  required int repetitions,
  required double loadKg,
  DateTime? performedAt,
}) {
  return WorkoutSet(
    id: WorkoutSetId(id),
    exerciseRef: _benchRef,
    repetitions: Repetitions(repetitions),
    load: LoadKg(loadKg),
    performedAt: PerformedAt(performedAt ?? DateTime.utc(2026, 6, 6, 9)),
  );
}

final class _RecordingWorkoutSetRepository implements WorkoutSetRepository {
  _RecordingWorkoutSetRepository(this.sets);

  final List<WorkoutSet> sets;
  final List<int> requestedLimits = [];

  @override
  Future<WorkoutSetTimelinePage> timelineForExercise(
    WorkoutSetTimelineQuery query,
  ) async {
    requestedLimits.add(query.limit);
    return WorkoutSetTimelinePage(
      items: sets.take(query.limit),
      hasMore: sets.length > query.limit,
      nextCursor: null,
    );
  }

  @override
  Future<void> deleteById(WorkoutSetId id) {
    throw UnimplementedError();
  }

  @override
  Future<WorkoutSetDailySummary> dailySummary(
    WorkoutSetDailySummaryQuery query,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<WorkoutSet?> findById(WorkoutSetId id) {
    throw UnimplementedError();
  }

  @override
  Future<List<WorkoutSet>> historyForExercise(ExerciseRef exerciseRef) {
    throw UnimplementedError();
  }

  @override
  Future<void> save(WorkoutSet set) {
    throw UnimplementedError();
  }

  @override
  Future<WorkoutSetHistoryPage> searchHistory(WorkoutSetHistoryQuery query) {
    throw UnimplementedError();
  }

  @override
  Future<List<WorkoutSet>> setsForWorkoutSession(
    WorkoutSessionId workoutSessionId,
  ) {
    throw UnimplementedError();
  }
}

final class _StaticExerciseCatalogRepository
    implements ExerciseCatalogRepository {
  const _StaticExerciseCatalogRepository();

  @override
  Future<OfficialExercise?> findOfficialExerciseById(OfficialExerciseId id) {
    return Future.value(
      OfficialExercise(
        id: id,
        catalogVersion: CatalogVersion('2026.06.0'),
        englishName: 'Barbell Bench Press',
        germanName: 'Bankdruecken mit Langhantel',
        equipment: [EquipmentTag('barbell')],
        movementPatterns: [MovementPattern('horizontal_push')],
        primaryMuscles: [MuscleGroup('chest')],
      ),
    );
  }

  @override
  Future<ExerciseCatalogPage> findOfficialExercises(
    ExerciseCatalogQuery query,
  ) {
    throw UnimplementedError();
  }
}
