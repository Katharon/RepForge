import 'package:repforge/src/features/analytics/domain/analytics_domain.dart';
import 'package:repforge/src/features/exercise_catalog/domain/exercise_catalog_domain.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

import 'recommendation_models.dart';

enum QuickSessionDuration {
  fifteen(minutes: 15, targetExerciseCount: 2, maxExerciseCount: 3),
  twentyFive(minutes: 25, targetExerciseCount: 3, maxExerciseCount: 4),
  thirtyFive(minutes: 35, targetExerciseCount: 5, maxExerciseCount: 5);

  const QuickSessionDuration({
    required this.minutes,
    required this.targetExerciseCount,
    required this.maxExerciseCount,
  });

  final int minutes;
  final int targetExerciseCount;
  final int maxExerciseCount;
}

enum QuickSessionPlanStatus { unavailable, available }

enum QuickSessionInputQuality { unavailable, partial, ready }

enum QuickSessionReasonCode {
  candidateListEmpty,
  duration15,
  duration25,
  duration35,
  timeBudgetLimited,
  balancedFallback,
  equipmentLimited,
  loadAdjusted,
  readinessAdjusted,
  muscleBalancePriority,
  coverageComputed,
  stableTieBreak,
  normalSessionPreserved,
}

enum QuickSessionSkippedCode {
  timeBudget,
  unavailableEquipment,
  maxLoadAdjusted,
  excludedExercise,
  readinessReduced,
}

final class QuickSessionRequest {
  const QuickSessionRequest({
    required this.duration,
    required this.recommendationRequest,
  });

  final QuickSessionDuration duration;
  final RecommendationRequest recommendationRequest;
}

final class QuickSessionExercise {
  QuickSessionExercise({
    required this.order,
    required this.recommendation,
    required this.plannedMinutes,
    Iterable<QuickSessionReasonCode> reasons = const <QuickSessionReasonCode>[],
  }) : reasons = List<QuickSessionReasonCode>.unmodifiable(reasons);

  final int order;
  final RecommendedExercise recommendation;
  final int plannedMinutes;
  final List<QuickSessionReasonCode> reasons;

  double? get suggestedLoadKg => recommendation.suggestedLoadKg;
}

final class QuickSessionCoverage {
  QuickSessionCoverage({
    Iterable<MuscleId> coveredMuscles = const <MuscleId>[],
    Iterable<MuscleId> skippedMuscles = const <MuscleId>[],
    Iterable<MovementPattern> coveredMovementPatterns =
        const <MovementPattern>[],
    Iterable<MovementPattern> skippedMovementPatterns =
        const <MovementPattern>[],
  }) : coveredMuscles = List<MuscleId>.unmodifiable(coveredMuscles),
       skippedMuscles = List<MuscleId>.unmodifiable(skippedMuscles),
       coveredMovementPatterns = List<MovementPattern>.unmodifiable(
         coveredMovementPatterns,
       ),
       skippedMovementPatterns = List<MovementPattern>.unmodifiable(
         skippedMovementPatterns,
       );

  factory QuickSessionCoverage.empty() {
    return QuickSessionCoverage();
  }

  final List<MuscleId> coveredMuscles;
  final List<MuscleId> skippedMuscles;
  final List<MovementPattern> coveredMovementPatterns;
  final List<MovementPattern> skippedMovementPatterns;
}

final class QuickSessionSkippedItem {
  const QuickSessionSkippedItem({
    required this.code,
    this.exerciseRef,
    this.muscle,
    this.movementPattern,
  });

  final QuickSessionSkippedCode code;
  final ExerciseRef? exerciseRef;
  final MuscleId? muscle;
  final MovementPattern? movementPattern;
}

final class QuickSessionPlan {
  QuickSessionPlan({
    required this.status,
    required this.duration,
    required this.inputQuality,
    required Iterable<QuickSessionExercise> exercises,
    required this.coverage,
    required this.recommendationPlan,
    Iterable<QuickSessionSkippedItem> skippedItems =
        const <QuickSessionSkippedItem>[],
    Iterable<QuickSessionReasonCode> reasons = const <QuickSessionReasonCode>[],
  }) : exercises = List<QuickSessionExercise>.unmodifiable(exercises),
       skippedItems = List<QuickSessionSkippedItem>.unmodifiable(skippedItems),
       reasons = List<QuickSessionReasonCode>.unmodifiable(reasons);

  factory QuickSessionPlan.unavailable({
    required QuickSessionDuration duration,
    required RecommendationPlan recommendationPlan,
    Iterable<QuickSessionReasonCode> reasons = const <QuickSessionReasonCode>[],
    Iterable<QuickSessionSkippedItem> skippedItems =
        const <QuickSessionSkippedItem>[],
  }) {
    return QuickSessionPlan(
      status: QuickSessionPlanStatus.unavailable,
      duration: duration,
      inputQuality: QuickSessionInputQuality.unavailable,
      exercises: const <QuickSessionExercise>[],
      coverage: QuickSessionCoverage.empty(),
      recommendationPlan: recommendationPlan,
      skippedItems: skippedItems,
      reasons: reasons,
    );
  }

  final QuickSessionPlanStatus status;
  final QuickSessionDuration duration;
  final QuickSessionInputQuality inputQuality;
  final List<QuickSessionExercise> exercises;
  final QuickSessionCoverage coverage;
  final List<QuickSessionSkippedItem> skippedItems;
  final List<QuickSessionReasonCode> reasons;
  final RecommendationPlan recommendationPlan;

  bool get allowsWorkoutLogging => true;

  bool get replacesNormalGroupSession => false;
}
