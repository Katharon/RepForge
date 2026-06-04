import 'package:repforge/src/features/analytics/domain/analytics_domain.dart';
import 'package:repforge/src/features/exercise_catalog/domain/exercise_catalog_domain.dart';
import 'package:repforge/src/features/recovery/domain/recovery_domain.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

enum RecommendationPlanStatus { unavailable, available }

enum RecommendationInputQuality { unavailable, partial, ready }

enum RecommendationReasonCode {
  candidateListEmpty,
  groupAssignment,
  equipmentAvailable,
  equipmentFiltered,
  loadAdjustedForConstraint,
  focusMatch,
  timeBudgetFit,
  balancePullPriority,
  balanceLowerPriority,
  balancePushSuppressed,
  readinessReducedIntensity,
  readinessNoCheckIn,
  alternativeAvailable,
  substitutionApplied,
  excludedByUser,
  stableTieBreak,
}

enum RecommendationConstraintCode {
  unavailableEquipment,
  maxLoadExceeded,
  excludedExercise,
}

final class RecommendationScore {
  RecommendationScore(num value) : value = value.toDouble();

  final double value;

  @override
  bool operator ==(Object other) {
    return other is RecommendationScore && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

final class RecommendationConstraint {
  RecommendationConstraint({
    required this.code,
    required this.exerciseRef,
    this.equipment,
    this.requestedLoadKg,
    this.adjustedLoadKg,
  });

  final RecommendationConstraintCode code;
  final ExerciseRef exerciseRef;
  final AvailableEquipment? equipment;
  final double? requestedLoadKg;
  final double? adjustedLoadKg;

  @override
  bool operator ==(Object other) {
    return other is RecommendationConstraint &&
        other.code == code &&
        other.exerciseRef == exerciseRef &&
        other.equipment == equipment &&
        other.requestedLoadKg == requestedLoadKg &&
        other.adjustedLoadKg == adjustedLoadKg;
  }

  @override
  int get hashCode {
    return Object.hash(
      code,
      exerciseRef,
      equipment,
      requestedLoadKg,
      adjustedLoadKg,
    );
  }
}

final class RecommendationCandidate {
  RecommendationCandidate({
    required this.exerciseRef,
    required Iterable<EquipmentTag> equipment,
    required Iterable<MovementPattern> movementPatterns,
    required Iterable<MuscleId> primaryMuscles,
    Iterable<MuscleId> secondaryMuscles = const <MuscleId>[],
    this.groupPosition,
    this.estimatedWorkingLoadKg,
  }) : equipment = List<EquipmentTag>.unmodifiable(equipment),
       movementPatterns = List<MovementPattern>.unmodifiable(movementPatterns),
       primaryMuscles = List<MuscleId>.unmodifiable(primaryMuscles),
       secondaryMuscles = List<MuscleId>.unmodifiable(secondaryMuscles) {
    final load = estimatedWorkingLoadKg;
    if (load != null && (!load.isFinite || load < 0)) {
      throw ArgumentError.value(
        estimatedWorkingLoadKg,
        'estimatedWorkingLoadKg',
        'Must be finite and non-negative.',
      );
    }
  }

  factory RecommendationCandidate.fromOfficial(
    OfficialExercise exercise, {
    int? groupPosition,
    double? estimatedWorkingLoadKg,
  }) {
    return RecommendationCandidate(
      exerciseRef: ExerciseRef.official(
        id: exercise.id,
        displayNameSnapshot: exercise.englishName,
        catalogVersionSnapshot: exercise.catalogVersion.value,
      ),
      equipment: exercise.equipment,
      movementPatterns: exercise.movementPatterns,
      primaryMuscles: exercise.primaryMuscles.map(
        (muscle) => MuscleId(muscle.value),
      ),
      secondaryMuscles: exercise.secondaryMuscles.map(
        (muscle) => MuscleId(muscle.value),
      ),
      groupPosition: groupPosition,
      estimatedWorkingLoadKg: estimatedWorkingLoadKg,
    );
  }

  final ExerciseRef exerciseRef;
  final List<EquipmentTag> equipment;
  final List<MovementPattern> movementPatterns;
  final List<MuscleId> primaryMuscles;
  final List<MuscleId> secondaryMuscles;
  final int? groupPosition;
  final double? estimatedWorkingLoadKg;

  List<MuscleId> get allMuscles {
    return <MuscleId>[...primaryMuscles, ...secondaryMuscles];
  }

  bool coversAnyMuscle(Iterable<String> muscleIds) {
    final allowed = muscleIds.toSet();
    return allMuscles.any((muscle) => allowed.contains(muscle.value));
  }

  bool coversAnyPattern(Iterable<String> patternValues) {
    final allowed = patternValues.toSet();
    return movementPatterns.any((pattern) => allowed.contains(pattern.value));
  }

  @override
  bool operator ==(Object other) {
    return other is RecommendationCandidate &&
        other.exerciseRef == exerciseRef &&
        _listEquals(other.equipment, equipment) &&
        _listEquals(other.movementPatterns, movementPatterns) &&
        _listEquals(other.primaryMuscles, primaryMuscles) &&
        _listEquals(other.secondaryMuscles, secondaryMuscles) &&
        other.groupPosition == groupPosition &&
        other.estimatedWorkingLoadKg == estimatedWorkingLoadKg;
  }

  @override
  int get hashCode {
    return Object.hash(
      exerciseRef,
      Object.hashAll(equipment),
      Object.hashAll(movementPatterns),
      Object.hashAll(primaryMuscles),
      Object.hashAll(secondaryMuscles),
      groupPosition,
      estimatedWorkingLoadKg,
    );
  }
}

final class RecommendationSubstitution {
  const RecommendationSubstitution({
    required this.skippedExerciseRef,
    required this.selectedExerciseRef,
  });

  final ExerciseRef skippedExerciseRef;
  final ExerciseRef selectedExerciseRef;
}

final class RecommendationRequest {
  RecommendationRequest({
    required Iterable<RecommendationCandidate> candidates,
    this.settingsProfile,
    this.equipmentInventory,
    this.focusProfile,
    this.trainingGoal,
    this.sessionDuration,
    this.muscleBalanceAssessment,
    this.readiness,
    Iterable<ExerciseRef> excludedExerciseRefs = const <ExerciseRef>[],
    Iterable<RecommendationSubstitution> substitutions =
        const <RecommendationSubstitution>[],
    this.maxRecommendations = 6,
  }) : candidates = List<RecommendationCandidate>.unmodifiable(candidates),
       excludedExerciseRefs = List<ExerciseRef>.unmodifiable(
         excludedExerciseRefs,
       ),
       substitutions = List<RecommendationSubstitution>.unmodifiable(
         substitutions,
       );

  final List<RecommendationCandidate> candidates;
  final SettingsProfile? settingsProfile;
  final EquipmentInventory? equipmentInventory;
  final FocusProfile? focusProfile;
  final TrainingGoal? trainingGoal;
  final SessionDurationPreference? sessionDuration;
  final MuscleBalanceAssessment? muscleBalanceAssessment;
  final ReadinessReadModel? readiness;
  final List<ExerciseRef> excludedExerciseRefs;
  final List<RecommendationSubstitution> substitutions;
  final int maxRecommendations;

  EquipmentInventory get effectiveEquipmentInventory {
    return equipmentInventory ??
        settingsProfile?.equipmentInventory ??
        EquipmentInventory.defaults();
  }

  FocusProfile get effectiveFocusProfile {
    return focusProfile ??
        settingsProfile?.focusProfile ??
        FocusProfile.balanced;
  }

  TrainingGoal get effectiveTrainingGoal {
    return trainingGoal ??
        settingsProfile?.trainingGoal ??
        TrainingGoal.generalFitness;
  }

  SessionDurationPreference get effectiveSessionDuration {
    return sessionDuration ??
        settingsProfile?.sessionDuration ??
        SessionDurationPreference.fortyFive;
  }
}

final class RecommendationAlternative {
  RecommendationAlternative({
    required this.replacesExerciseRef,
    required this.exercise,
    required this.score,
    required Iterable<RecommendationReasonCode> reasons,
  }) : reasons = List<RecommendationReasonCode>.unmodifiable(reasons);

  final ExerciseRef replacesExerciseRef;
  final RecommendationCandidate exercise;
  final RecommendationScore score;
  final List<RecommendationReasonCode> reasons;
}

final class RecommendedExercise {
  RecommendedExercise({
    required this.rank,
    required this.exercise,
    required this.score,
    required Iterable<RecommendationReasonCode> reasons,
    Iterable<RecommendationConstraint> constraints =
        const <RecommendationConstraint>[],
    Iterable<RecommendationAlternative> alternatives =
        const <RecommendationAlternative>[],
    this.suggestedLoadKg,
  }) : reasons = List<RecommendationReasonCode>.unmodifiable(reasons),
       constraints = List<RecommendationConstraint>.unmodifiable(constraints),
       alternatives = List<RecommendationAlternative>.unmodifiable(
         alternatives,
       );

  final int rank;
  final RecommendationCandidate exercise;
  final RecommendationScore score;
  final List<RecommendationReasonCode> reasons;
  final List<RecommendationConstraint> constraints;
  final List<RecommendationAlternative> alternatives;
  final double? suggestedLoadKg;
}

final class RecommendationPlan {
  RecommendationPlan({
    required this.status,
    required this.inputQuality,
    required Iterable<RecommendedExercise> recommendations,
    Iterable<RecommendationAlternative> alternatives =
        const <RecommendationAlternative>[],
    Iterable<RecommendationConstraint> constraints =
        const <RecommendationConstraint>[],
    Iterable<RecommendationReasonCode> inputReasons =
        const <RecommendationReasonCode>[],
  }) : recommendations = List<RecommendedExercise>.unmodifiable(
         recommendations,
       ),
       alternatives = List<RecommendationAlternative>.unmodifiable(
         alternatives,
       ),
       constraints = List<RecommendationConstraint>.unmodifiable(constraints),
       inputReasons = List<RecommendationReasonCode>.unmodifiable(inputReasons);

  factory RecommendationPlan.unavailable({
    Iterable<RecommendationReasonCode> inputReasons =
        const <RecommendationReasonCode>[],
  }) {
    return RecommendationPlan(
      status: RecommendationPlanStatus.unavailable,
      inputQuality: RecommendationInputQuality.unavailable,
      recommendations: const <RecommendedExercise>[],
      inputReasons: inputReasons,
    );
  }

  final RecommendationPlanStatus status;
  final RecommendationInputQuality inputQuality;
  final List<RecommendedExercise> recommendations;
  final List<RecommendationAlternative> alternatives;
  final List<RecommendationConstraint> constraints;
  final List<RecommendationReasonCode> inputReasons;

  bool get allowsWorkoutLogging => true;
}

bool _listEquals<T>(List<T> left, List<T> right) {
  if (left.length != right.length) {
    return false;
  }

  for (var index = 0; index < left.length; index += 1) {
    if (left[index] != right[index]) {
      return false;
    }
  }
  return true;
}
