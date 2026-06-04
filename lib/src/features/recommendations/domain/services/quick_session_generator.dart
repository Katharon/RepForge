import 'package:repforge/src/features/analytics/domain/analytics_domain.dart';
import 'package:repforge/src/features/exercise_catalog/domain/exercise_catalog_domain.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

import '../value_objects/quick_session_models.dart';
import '../value_objects/recommendation_models.dart';
import 'recommendation_engine.dart';

abstract interface class QuickSessionGenerator {
  QuickSessionPlan generate(QuickSessionRequest request);
}

final class DeterministicQuickSessionGenerator
    implements QuickSessionGenerator {
  const DeterministicQuickSessionGenerator({
    this.engine = const DeterministicRecommendationEngine(),
  });

  final RecommendationEngine engine;

  @override
  QuickSessionPlan generate(QuickSessionRequest request) {
    final recommendationPlan = engine.generate(request.recommendationRequest);
    final baseReasons = <QuickSessionReasonCode>{
      _durationReason(request.duration),
      QuickSessionReasonCode.stableTieBreak,
      QuickSessionReasonCode.normalSessionPreserved,
    };

    if (recommendationPlan.status == RecommendationPlanStatus.unavailable ||
        recommendationPlan.recommendations.isEmpty) {
      baseReasons.addAll(_constraintReasons(recommendationPlan));
      if (recommendationPlan.inputReasons.contains(
        RecommendationReasonCode.candidateListEmpty,
      )) {
        baseReasons.add(QuickSessionReasonCode.candidateListEmpty);
      }

      return QuickSessionPlan.unavailable(
        duration: request.duration,
        recommendationPlan: recommendationPlan,
        skippedItems: _constraintSkippedItems(recommendationPlan),
        reasons: _sortedReasons(baseReasons),
      );
    }

    final selected = _selectRecommendations(request, recommendationPlan);
    final selectedKeys = selected.map(_recommendationKey).toSet();
    final exercises = <QuickSessionExercise>[];
    final plannedMinutes = _plannedMinutes(
      request.duration.minutes,
      selected.length,
    );

    for (var index = 0; index < selected.length; index += 1) {
      final recommendation = selected[index];
      exercises.add(
        QuickSessionExercise(
          order: index + 1,
          recommendation: recommendation,
          plannedMinutes: plannedMinutes,
          reasons: _quickReasonsFor(recommendation),
        ),
      );
    }

    final skippedItems = <QuickSessionSkippedItem>[
      ..._constraintSkippedItems(recommendationPlan),
      ..._timeBudgetSkippedItems(recommendationPlan, selectedKeys),
      ..._coverageSkippedItems(recommendationPlan, selectedKeys),
    ];
    final coverage = _coverageFor(recommendationPlan, selectedKeys);
    baseReasons
      ..add(QuickSessionReasonCode.coverageComputed)
      ..addAll(_constraintReasons(recommendationPlan))
      ..addAll(_selectionReasons(recommendationPlan, selected, request))
      ..addAll(_skippedReasons(skippedItems));

    return QuickSessionPlan(
      status: QuickSessionPlanStatus.available,
      duration: request.duration,
      inputQuality: _inputQualityFor(
        recommendationPlan,
        selected.length,
        request.duration.targetExerciseCount,
      ),
      exercises: exercises,
      coverage: coverage,
      skippedItems: skippedItems,
      recommendationPlan: recommendationPlan,
      reasons: _sortedReasons(baseReasons),
    );
  }
}

List<RecommendedExercise> _selectRecommendations(
  QuickSessionRequest request,
  RecommendationPlan recommendationPlan,
) {
  final targetCount = request.duration.targetExerciseCount.clamp(
    0,
    request.duration.maxExerciseCount,
  );
  final ranked = recommendationPlan.recommendations;
  if (!_shouldUseBalancedFallback(request, ranked, targetCount)) {
    return ranked.take(targetCount).toList(growable: false);
  }

  final selected = <RecommendedExercise>[];
  final selectedKeys = <String>{};
  for (final category in _CoverageCategory.values) {
    final match = _firstOrNull(
      ranked.where((item) {
        return !selectedKeys.contains(_recommendationKey(item)) &&
            _categoryFor(item.recommendationCandidate) == category;
      }),
    );
    if (match == null) {
      continue;
    }
    selected.add(match);
    selectedKeys.add(_recommendationKey(match));
  }

  for (final recommendation in ranked) {
    if (selected.length >= targetCount) {
      break;
    }
    final key = _recommendationKey(recommendation);
    if (selectedKeys.add(key)) {
      selected.add(recommendation);
    }
  }

  return selected.take(targetCount).toList(growable: false);
}

bool _shouldUseBalancedFallback(
  QuickSessionRequest request,
  List<RecommendedExercise> ranked,
  int targetCount,
) {
  if (targetCount < 3 ||
      request.recommendationRequest.muscleBalanceAssessment != null) {
    return false;
  }
  final focus = request.recommendationRequest.effectiveFocusProfile;
  if (focus != FocusProfile.balanced && focus != FocusProfile.custom) {
    return false;
  }
  final categories = ranked
      .map((item) => _categoryFor(item.recommendationCandidate))
      .whereType<_CoverageCategory>()
      .toSet();
  return categories.containsAll(_CoverageCategory.values);
}

QuickSessionCoverage _coverageFor(
  RecommendationPlan recommendationPlan,
  Set<String> selectedKeys,
) {
  final coveredMuscles = <String, MuscleId>{};
  final skippedMuscles = <String, MuscleId>{};
  final coveredPatterns = <String, MovementPattern>{};
  final skippedPatterns = <String, MovementPattern>{};

  for (final recommendation in recommendationPlan.recommendations) {
    final selected = selectedKeys.contains(_recommendationKey(recommendation));
    final candidate = recommendation.recommendationCandidate;
    for (final muscle in candidate.allMuscles) {
      if (selected) {
        coveredMuscles[muscle.value] = muscle;
      } else {
        skippedMuscles[muscle.value] = muscle;
      }
    }
    for (final pattern in candidate.movementPatterns) {
      if (selected) {
        coveredPatterns[pattern.value] = pattern;
      } else {
        skippedPatterns[pattern.value] = pattern;
      }
    }
  }

  for (final key in coveredMuscles.keys) {
    skippedMuscles.remove(key);
  }
  for (final key in coveredPatterns.keys) {
    skippedPatterns.remove(key);
  }

  return QuickSessionCoverage(
    coveredMuscles: _sortedMuscles(coveredMuscles.values),
    skippedMuscles: _sortedMuscles(skippedMuscles.values),
    coveredMovementPatterns: _sortedPatterns(coveredPatterns.values),
    skippedMovementPatterns: _sortedPatterns(skippedPatterns.values),
  );
}

List<QuickSessionSkippedItem> _coverageSkippedItems(
  RecommendationPlan recommendationPlan,
  Set<String> selectedKeys,
) {
  final coverage = _coverageFor(recommendationPlan, selectedKeys);
  return <QuickSessionSkippedItem>[
    for (final muscle in coverage.skippedMuscles)
      QuickSessionSkippedItem(
        code: QuickSessionSkippedCode.timeBudget,
        muscle: muscle,
      ),
    for (final pattern in coverage.skippedMovementPatterns)
      QuickSessionSkippedItem(
        code: QuickSessionSkippedCode.timeBudget,
        movementPattern: pattern,
      ),
  ];
}

List<QuickSessionSkippedItem> _timeBudgetSkippedItems(
  RecommendationPlan recommendationPlan,
  Set<String> selectedKeys,
) {
  return <QuickSessionSkippedItem>[
    for (final recommendation in recommendationPlan.recommendations)
      if (!selectedKeys.contains(_recommendationKey(recommendation)))
        QuickSessionSkippedItem(
          code:
              recommendation.reasons.contains(
                RecommendationReasonCode.readinessReducedIntensity,
              )
              ? QuickSessionSkippedCode.readinessReduced
              : QuickSessionSkippedCode.timeBudget,
          exerciseRef: recommendation.recommendationCandidate.exerciseRef,
        ),
  ];
}

List<QuickSessionSkippedItem> _constraintSkippedItems(
  RecommendationPlan recommendationPlan,
) {
  return <QuickSessionSkippedItem>[
    for (final constraint in recommendationPlan.constraints)
      QuickSessionSkippedItem(
        code: switch (constraint.code) {
          RecommendationConstraintCode.unavailableEquipment =>
            QuickSessionSkippedCode.unavailableEquipment,
          RecommendationConstraintCode.maxLoadExceeded =>
            QuickSessionSkippedCode.maxLoadAdjusted,
          RecommendationConstraintCode.excludedExercise =>
            QuickSessionSkippedCode.excludedExercise,
        },
        exerciseRef: constraint.exerciseRef,
      ),
  ];
}

Set<QuickSessionReasonCode> _selectionReasons(
  RecommendationPlan recommendationPlan,
  List<RecommendedExercise> selected,
  QuickSessionRequest request,
) {
  final selectedKeys = selected.map(_recommendationKey).toSet();
  final reasons = <QuickSessionReasonCode>{};
  if (selected.length < recommendationPlan.recommendations.length) {
    reasons.add(QuickSessionReasonCode.timeBudgetLimited);
  }
  if (_shouldUseBalancedFallback(
    request,
    recommendationPlan.recommendations,
    request.duration.targetExerciseCount,
  )) {
    reasons.add(QuickSessionReasonCode.balancedFallback);
  }

  for (final recommendation in recommendationPlan.recommendations) {
    final recommendationSelected = selectedKeys.contains(
      _recommendationKey(recommendation),
    );
    if (recommendationSelected) {
      reasons.addAll(_quickReasonsFor(recommendation));
    } else if (recommendation.reasons.contains(
      RecommendationReasonCode.readinessReducedIntensity,
    )) {
      reasons.add(QuickSessionReasonCode.readinessAdjusted);
    }
  }
  return reasons;
}

Set<QuickSessionReasonCode> _constraintReasons(
  RecommendationPlan recommendationPlan,
) {
  final reasons = <QuickSessionReasonCode>{};
  for (final constraint in recommendationPlan.constraints) {
    switch (constraint.code) {
      case RecommendationConstraintCode.unavailableEquipment:
        reasons.add(QuickSessionReasonCode.equipmentLimited);
      case RecommendationConstraintCode.maxLoadExceeded:
        reasons.add(QuickSessionReasonCode.loadAdjusted);
      case RecommendationConstraintCode.excludedExercise:
        reasons.add(QuickSessionReasonCode.timeBudgetLimited);
    }
  }
  if (recommendationPlan.inputReasons.contains(
    RecommendationReasonCode.equipmentFiltered,
  )) {
    reasons.add(QuickSessionReasonCode.equipmentLimited);
  }
  return reasons;
}

Set<QuickSessionReasonCode> _skippedReasons(
  List<QuickSessionSkippedItem> skippedItems,
) {
  final reasons = <QuickSessionReasonCode>{};
  for (final item in skippedItems) {
    switch (item.code) {
      case QuickSessionSkippedCode.timeBudget:
      case QuickSessionSkippedCode.excludedExercise:
        reasons.add(QuickSessionReasonCode.timeBudgetLimited);
      case QuickSessionSkippedCode.unavailableEquipment:
        reasons.add(QuickSessionReasonCode.equipmentLimited);
      case QuickSessionSkippedCode.maxLoadAdjusted:
        reasons.add(QuickSessionReasonCode.loadAdjusted);
      case QuickSessionSkippedCode.readinessReduced:
        reasons.add(QuickSessionReasonCode.readinessAdjusted);
    }
  }
  return reasons;
}

Set<QuickSessionReasonCode> _quickReasonsFor(
  RecommendedExercise recommendation,
) {
  final reasons = <QuickSessionReasonCode>{};
  for (final reason in recommendation.reasons) {
    switch (reason) {
      case RecommendationReasonCode.loadAdjustedForConstraint:
        reasons.add(QuickSessionReasonCode.loadAdjusted);
      case RecommendationReasonCode.readinessReducedIntensity:
        reasons.add(QuickSessionReasonCode.readinessAdjusted);
      case RecommendationReasonCode.balancePullPriority:
      case RecommendationReasonCode.balanceLowerPriority:
      case RecommendationReasonCode.balancePushSuppressed:
        reasons.add(QuickSessionReasonCode.muscleBalancePriority);
      case RecommendationReasonCode.stableTieBreak:
        reasons.add(QuickSessionReasonCode.stableTieBreak);
      case RecommendationReasonCode.candidateListEmpty:
      case RecommendationReasonCode.groupAssignment:
      case RecommendationReasonCode.equipmentAvailable:
      case RecommendationReasonCode.equipmentFiltered:
      case RecommendationReasonCode.focusMatch:
      case RecommendationReasonCode.timeBudgetFit:
      case RecommendationReasonCode.readinessNoCheckIn:
      case RecommendationReasonCode.alternativeAvailable:
      case RecommendationReasonCode.substitutionApplied:
      case RecommendationReasonCode.excludedByUser:
        break;
    }
  }
  if (recommendation.constraints.any(
    (constraint) =>
        constraint.code == RecommendationConstraintCode.maxLoadExceeded,
  )) {
    reasons.add(QuickSessionReasonCode.loadAdjusted);
  }
  return reasons;
}

QuickSessionInputQuality _inputQualityFor(
  RecommendationPlan recommendationPlan,
  int selectedCount,
  int targetCount,
) {
  if (recommendationPlan.inputQuality ==
      RecommendationInputQuality.unavailable) {
    return QuickSessionInputQuality.unavailable;
  }
  if (selectedCount < targetCount ||
      recommendationPlan.inputQuality == RecommendationInputQuality.partial) {
    return QuickSessionInputQuality.partial;
  }
  return QuickSessionInputQuality.ready;
}

QuickSessionReasonCode _durationReason(QuickSessionDuration duration) {
  return switch (duration) {
    QuickSessionDuration.fifteen => QuickSessionReasonCode.duration15,
    QuickSessionDuration.twentyFive => QuickSessionReasonCode.duration25,
    QuickSessionDuration.thirtyFive => QuickSessionReasonCode.duration35,
  };
}

int _plannedMinutes(int totalMinutes, int exerciseCount) {
  if (exerciseCount <= 0) {
    return 0;
  }
  return totalMinutes ~/ exerciseCount;
}

List<MuscleId> _sortedMuscles(Iterable<MuscleId> muscles) {
  return muscles.toList(growable: false)
    ..sort((left, right) => left.value.compareTo(right.value));
}

List<MovementPattern> _sortedPatterns(Iterable<MovementPattern> patterns) {
  return patterns.toList(growable: false)
    ..sort((left, right) => left.value.compareTo(right.value));
}

List<QuickSessionReasonCode> _sortedReasons(
  Iterable<QuickSessionReasonCode> reasons,
) {
  return reasons.toList(growable: false)
    ..sort((left, right) => left.index.compareTo(right.index));
}

String _recommendationKey(RecommendedExercise recommendation) {
  return _exerciseKey(recommendation.recommendationCandidate.exerciseRef);
}

String _exerciseKey(ExerciseRef exerciseRef) {
  return '${exerciseRef.source.name}:${exerciseRef.id}';
}

T? _firstOrNull<T>(Iterable<T> values) {
  for (final value in values) {
    return value;
  }
  return null;
}

enum _CoverageCategory { push, pull, lower }

_CoverageCategory? _categoryFor(RecommendationCandidate candidate) {
  if (_isPush(candidate)) {
    return _CoverageCategory.push;
  }
  if (_isPull(candidate)) {
    return _CoverageCategory.pull;
  }
  if (_isLower(candidate)) {
    return _CoverageCategory.lower;
  }
  return null;
}

bool _isPush(RecommendationCandidate candidate) {
  return candidate.coversAnyMuscle(_pushMuscles) ||
      candidate.coversAnyPattern(_pushPatterns);
}

bool _isPull(RecommendationCandidate candidate) {
  return candidate.coversAnyMuscle(_pullMuscles) ||
      candidate.coversAnyPattern(_pullPatterns);
}

bool _isLower(RecommendationCandidate candidate) {
  return candidate.coversAnyMuscle(_lowerMuscles) ||
      candidate.coversAnyPattern(_lowerPatterns);
}

const _pushMuscles = <String>[
  'chest',
  'triceps',
  'front_deltoids',
  'shoulders',
  'upper_chest',
];

const _pullMuscles = <String>[
  'lats',
  'upper_back',
  'rear_deltoids',
  'biceps',
  'forearms',
  'traps',
];

const _lowerMuscles = <String>[
  'quadriceps',
  'hamstrings',
  'glutes',
  'calves',
  'erector_spinae',
];

const _pushPatterns = <String>['horizontal_push', 'vertical_push'];
const _pullPatterns = <String>['horizontal_pull', 'vertical_pull'];
const _lowerPatterns = <String>['squat', 'knee_dominant', 'lunge', 'hinge'];

extension on RecommendedExercise {
  RecommendationCandidate get recommendationCandidate => exercise;
}
