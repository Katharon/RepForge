import 'package:flutter/widgets.dart';

import '../../recommendations/domain/recommendations_domain.dart';
import '../../recovery/domain/recovery_domain.dart';
import '../../settings/domain/settings_domain.dart';
import '../../training_log/domain/training_log_domain.dart';
import '../domain/exercise_catalog_domain.dart';

abstract interface class ExerciseDetailAdaptiveSuggestionLoader {
  Future<ExerciseDetailAdaptiveSuggestionViewModel?> load(
    ExerciseRef exerciseRef, {
    Locale? locale,
  });
}

final class RepositoryExerciseDetailAdaptiveSuggestionLoader
    implements ExerciseDetailAdaptiveSuggestionLoader {
  const RepositoryExerciseDetailAdaptiveSuggestionLoader({
    required this.workoutSetRepository,
    required this.exerciseCatalogRepository,
    this.loadTodayReadiness,
    this.loadSettingsProfile,
    this.ensureCatalogImported,
    this.suggester = const DeterministicAdaptiveSetSuggester(),
  });

  final WorkoutSetRepository workoutSetRepository;
  final ExerciseCatalogRepository exerciseCatalogRepository;
  final Future<ReadinessReadModel> Function()? loadTodayReadiness;
  final Future<SettingsProfile> Function()? loadSettingsProfile;
  final Future<void> Function()? ensureCatalogImported;
  final AdaptiveSetSuggester suggester;

  @override
  Future<ExerciseDetailAdaptiveSuggestionViewModel?> load(
    ExerciseRef exerciseRef, {
    Locale? locale,
  }) async {
    await ensureCatalogImported?.call();
    final timeline = await workoutSetRepository.timelineForExercise(
      WorkoutSetTimelineQuery(exerciseRef: exerciseRef, limit: 2),
    );
    if (timeline.items.isEmpty) {
      return null;
    }

    final sets = timeline.items.toList(growable: false)..sort(_newestFirst);
    final current = sets.first;
    final baseline = sets.length > 1 ? sets[1] : null;
    final readiness = await loadTodayReadiness?.call();
    final settings = await loadSettingsProfile?.call();
    final primaryEquipment = await _primaryEquipmentFor(
      current.exerciseRef,
      settings?.equipmentInventory,
    );
    final suggestion = suggester.suggest(
      AdaptiveSetSuggestionRequest(
        currentSet: CurrentSetPerformance(
          exerciseRef: current.exerciseRef,
          load: current.load,
          repetitions: current.repetitions,
        ),
        baseline: baseline == null
            ? null
            : SetPerformanceBaseline(
                exerciseRef: baseline.exerciseRef,
                load: baseline.load,
                repetitions: baseline.repetitions,
              ),
        readiness: readiness,
        equipmentInventory: settings?.equipmentInventory,
        primaryEquipment: primaryEquipment,
      ),
    );

    return ExerciseDetailAdaptiveSuggestionViewModel.fromDomain(
      suggestion,
      hasComparableBaseline: baseline != null,
    );
  }

  Future<AvailableEquipment?> _primaryEquipmentFor(
    ExerciseRef exerciseRef,
    EquipmentInventory? inventory,
  ) async {
    if (inventory == null || exerciseRef.source != ExerciseSource.official) {
      return null;
    }

    final exercise = await exerciseCatalogRepository.findOfficialExerciseById(
      OfficialExerciseId(exerciseRef.id),
    );
    if (exercise == null) {
      return null;
    }

    for (final tag in exercise.equipment) {
      final equipment = _equipmentForTag(tag.value);
      if (equipment != null && inventory.contains(equipment)) {
        return equipment;
      }
    }
    return null;
  }
}

final class ExerciseDetailAdaptiveSuggestionViewModel {
  const ExerciseDetailAdaptiveSuggestionViewModel({
    required this.direction,
    required this.inputQuality,
    required this.currentLoadKg,
    required this.currentRepetitions,
    required this.hasComparableBaseline,
    required this.allowsWorkoutLogging,
    required this.userOverrideAllowed,
    required this.reasons,
    this.suggestedLoadKg,
    this.suggestedRepetitions,
  });

  factory ExerciseDetailAdaptiveSuggestionViewModel.fromDomain(
    AdaptiveSetSuggestion suggestion, {
    required bool hasComparableBaseline,
  }) {
    return ExerciseDetailAdaptiveSuggestionViewModel(
      direction: suggestion.direction,
      inputQuality: suggestion.inputQuality,
      currentLoadKg: suggestion.currentLoad.value,
      currentRepetitions: suggestion.currentRepetitions.value,
      suggestedLoadKg: suggestion.suggestedLoadKg,
      suggestedRepetitions: suggestion.suggestedRepetitionsValue,
      hasComparableBaseline: hasComparableBaseline,
      allowsWorkoutLogging: suggestion.allowsWorkoutLogging,
      userOverrideAllowed: suggestion.userOverrideAllowed,
      reasons: suggestion.reasons,
    );
  }

  final AdaptiveSetDirection direction;
  final AdaptiveSetInputQuality inputQuality;
  final double currentLoadKg;
  final int currentRepetitions;
  final double? suggestedLoadKg;
  final int? suggestedRepetitions;
  final bool hasComparableBaseline;
  final bool allowsWorkoutLogging;
  final bool userOverrideAllowed;
  final List<AdaptiveSetReasonCode> reasons;
}

int _newestFirst(WorkoutSet left, WorkoutSet right) {
  final performedAtComparison = right.performedAt.value.compareTo(
    left.performedAt.value,
  );
  if (performedAtComparison != 0) {
    return performedAtComparison;
  }
  return right.id.value.compareTo(left.id.value);
}

AvailableEquipment? _equipmentForTag(String rawValue) {
  final value = rawValue
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_');
  return switch (value) {
    'bodyweight' => AvailableEquipment.bodyweight,
    'barbell' => AvailableEquipment.barbell,
    'dumbbell' || 'dumbbells' => AvailableEquipment.dumbbell,
    'cable' || 'cable_machine' => AvailableEquipment.cable,
    'machine' => AvailableEquipment.machine,
    'smith_machine' => AvailableEquipment.smithMachine,
    'pull_up_bar' => AvailableEquipment.pullUpBar,
    'bench' => AvailableEquipment.bench,
    'rack' => AvailableEquipment.rack,
    'leg_press' => AvailableEquipment.legPress,
    _ => null,
  };
}
