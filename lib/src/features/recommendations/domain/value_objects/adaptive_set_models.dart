import 'package:repforge/src/features/recovery/domain/recovery_domain.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

import 'recommendation_models.dart';

enum AdaptiveSetDirection {
  addWeight,
  addReps,
  maintain,
  backoff,
  stop,
  chooseAlternative,
  noSuggestion,
}

enum AdaptiveSetInputQuality { unavailable, partial, ready }

enum AdaptiveSetReasonCode {
  noBaseline,
  baselineMatched,
  baselineExceeded,
  baselineBelow,
  goodReadiness,
  lowReadiness,
  veryLowReadiness,
  highSoreness,
  strengthDown,
  equipmentMaxLoadReached,
  loadIncrementApplied,
  loadIncreaseUnavailable,
  repProgressionAvailable,
  alternativeAvailable,
  advisory,
  userOverrideAllowed,
  stableTieBreak,
  rpeNotRequired,
  conservativeStop,
}

final class ProgressiveOverloadPolicy {
  const ProgressiveOverloadPolicy({
    this.targetRepMinimum = 6,
    this.targetRepMaximum = 12,
    this.defaultLoadIncrementKg = 2.5,
  });

  final int targetRepMinimum;
  final int targetRepMaximum;
  final double defaultLoadIncrementKg;
}

final class BackoffPolicy {
  const BackoffPolicy({
    this.strengthDownRepetitionThreshold = 2,
    this.backoffLoadMultiplier = 0.9,
    this.backoffRepetitionDrop = 2,
  });

  final int strengthDownRepetitionThreshold;
  final double backoffLoadMultiplier;
  final int backoffRepetitionDrop;
}

final class CurrentSetPerformance {
  const CurrentSetPerformance({
    required this.exerciseRef,
    required this.load,
    required this.repetitions,
  });

  final ExerciseRef exerciseRef;
  final LoadKg load;
  final Repetitions repetitions;

  double get volumeKg => load.value * repetitions.value;
}

final class SetPerformanceBaseline {
  const SetPerformanceBaseline({
    required this.exerciseRef,
    required this.load,
    required this.repetitions,
  });

  final ExerciseRef exerciseRef;
  final LoadKg load;
  final Repetitions repetitions;

  double get volumeKg => load.value * repetitions.value;
}

final class AdaptiveSetAlternative {
  AdaptiveSetAlternative({
    required this.exerciseRef,
    required Iterable<AdaptiveSetReasonCode> reasons,
  }) : reasons = List<AdaptiveSetReasonCode>.unmodifiable(reasons);

  final ExerciseRef exerciseRef;
  final List<AdaptiveSetReasonCode> reasons;
}

final class AdaptiveSetSuggestionRequest {
  AdaptiveSetSuggestionRequest({
    required this.currentSet,
    this.baseline,
    this.readiness,
    this.equipmentInventory,
    this.primaryEquipment,
    Iterable<RecommendationAlternative> recommendationAlternatives =
        const <RecommendationAlternative>[],
    this.progressiveOverloadPolicy = const ProgressiveOverloadPolicy(),
    this.backoffPolicy = const BackoffPolicy(),
  }) : recommendationAlternatives =
           List<RecommendationAlternative>.unmodifiable(
             recommendationAlternatives,
           );

  final CurrentSetPerformance currentSet;
  final SetPerformanceBaseline? baseline;
  final ReadinessReadModel? readiness;
  final EquipmentInventory? equipmentInventory;
  final AvailableEquipment? primaryEquipment;
  final List<RecommendationAlternative> recommendationAlternatives;
  final ProgressiveOverloadPolicy progressiveOverloadPolicy;
  final BackoffPolicy backoffPolicy;

  EquipmentLoadConstraint? get primaryLoadConstraint {
    final equipment = primaryEquipment;
    if (equipment == null) {
      return null;
    }
    return equipmentInventory?.loadConstraintFor(equipment);
  }
}

final class AdaptiveSetSuggestion {
  AdaptiveSetSuggestion({
    required this.direction,
    required this.inputQuality,
    required this.exerciseRef,
    required this.currentLoad,
    required this.currentRepetitions,
    required Iterable<AdaptiveSetReasonCode> reasons,
    Iterable<AdaptiveSetAlternative> alternatives =
        const <AdaptiveSetAlternative>[],
    this.suggestedLoad,
    this.suggestedRepetitions,
  }) : reasons = List<AdaptiveSetReasonCode>.unmodifiable(reasons),
       alternatives = List<AdaptiveSetAlternative>.unmodifiable(alternatives);

  final AdaptiveSetDirection direction;
  final AdaptiveSetInputQuality inputQuality;
  final ExerciseRef exerciseRef;
  final LoadKg currentLoad;
  final Repetitions currentRepetitions;
  final LoadKg? suggestedLoad;
  final Repetitions? suggestedRepetitions;
  final List<AdaptiveSetAlternative> alternatives;
  final List<AdaptiveSetReasonCode> reasons;

  double? get suggestedLoadKg => suggestedLoad?.value;

  int? get suggestedRepetitionsValue => suggestedRepetitions?.value;

  bool get allowsWorkoutLogging => true;

  bool get userOverrideAllowed => true;
}
