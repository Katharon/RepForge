import 'package:repforge/src/features/analytics/domain/analytics_domain.dart';
import 'package:repforge/src/features/recovery/domain/recovery_domain.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

import '../value_objects/recommendation_models.dart';

abstract interface class RecommendationEngine {
  RecommendationPlan generate(RecommendationRequest request);
}

final class RecommendationPolicy {
  const RecommendationPolicy({
    this.groupPositionBonus = 30,
    this.focusBonus = 28,
    this.balancePriorityBonus = 36,
    this.balanceSuppressionPenalty = 24,
    this.readinessHeavyPenalty = 34,
    this.loadConstraintPenalty = 22,
    this.shortSessionMinutes = 25,
  });

  final double groupPositionBonus;
  final double focusBonus;
  final double balancePriorityBonus;
  final double balanceSuppressionPenalty;
  final double readinessHeavyPenalty;
  final double loadConstraintPenalty;
  final int shortSessionMinutes;
}

final class DeterministicRecommendationEngine implements RecommendationEngine {
  const DeterministicRecommendationEngine({
    this.policy = const RecommendationPolicy(),
  });

  final RecommendationPolicy policy;

  @override
  RecommendationPlan generate(RecommendationRequest request) {
    if (request.candidates.isEmpty) {
      return RecommendationPlan.unavailable(
        inputReasons: const <RecommendationReasonCode>[
          RecommendationReasonCode.candidateListEmpty,
        ],
      );
    }

    final constraints = <RecommendationConstraint>[];
    final scored = <_ScoredCandidate>[];
    final excludedKeys = request.excludedExerciseRefs.map(_exerciseKey).toSet();

    for (final candidate in request.candidates) {
      if (excludedKeys.contains(_exerciseKey(candidate.exerciseRef))) {
        constraints.add(
          RecommendationConstraint(
            code: RecommendationConstraintCode.excludedExercise,
            exerciseRef: candidate.exerciseRef,
          ),
        );
        continue;
      }

      final equipmentResult = _equipmentResultFor(
        candidate,
        request.effectiveEquipmentInventory,
      );
      if (!equipmentResult.available) {
        constraints.add(
          RecommendationConstraint(
            code: RecommendationConstraintCode.unavailableEquipment,
            exerciseRef: candidate.exerciseRef,
            equipment: equipmentResult.missingEquipment,
          ),
        );
        continue;
      }

      scored.add(_scoreCandidate(candidate, request, equipmentResult));
    }

    if (scored.isEmpty) {
      return RecommendationPlan(
        status: RecommendationPlanStatus.unavailable,
        inputQuality: RecommendationInputQuality.partial,
        recommendations: const <RecommendedExercise>[],
        alternatives: _alternativesForFiltered(
          request.candidates,
          scored,
          constraints,
        ),
        constraints: constraints,
        inputReasons: const <RecommendationReasonCode>[
          RecommendationReasonCode.equipmentFiltered,
        ],
      );
    }

    scored.sort(_compareScoredCandidates);

    final ranked = scored.take(request.maxRecommendations).toList();
    final recommendations = <RecommendedExercise>[];
    for (var index = 0; index < ranked.length; index += 1) {
      final item = ranked[index];
      recommendations.add(
        RecommendedExercise(
          rank: index + 1,
          exercise: item.candidate,
          score: RecommendationScore(item.score),
          reasons: item.reasons,
          constraints: item.constraints,
          alternatives: _alternativesForRecommended(item, scored),
          suggestedLoadKg: item.suggestedLoadKg,
        ),
      );
    }

    final inputReasons = <RecommendationReasonCode>[];
    if (request.readiness == null ||
        request.readiness?.status == ReadinessReadModelStatus.empty) {
      inputReasons.add(RecommendationReasonCode.readinessNoCheckIn);
    }
    if (constraints.isNotEmpty) {
      inputReasons.add(RecommendationReasonCode.equipmentFiltered);
    }
    if (request.substitutions.isNotEmpty) {
      inputReasons.add(RecommendationReasonCode.substitutionApplied);
    }

    return RecommendationPlan(
      status: RecommendationPlanStatus.available,
      inputQuality: inputReasons.isEmpty
          ? RecommendationInputQuality.ready
          : RecommendationInputQuality.partial,
      recommendations: recommendations,
      alternatives: _alternativesForFiltered(
        request.candidates,
        scored,
        constraints,
      ),
      constraints: constraints,
      inputReasons: inputReasons,
    );
  }

  _ScoredCandidate _scoreCandidate(
    RecommendationCandidate candidate,
    RecommendationRequest request,
    _EquipmentResult equipmentResult,
  ) {
    var score = 100.0;
    var suggestedLoadKg = candidate.estimatedWorkingLoadKg;
    final reasons = <RecommendationReasonCode>{
      RecommendationReasonCode.equipmentAvailable,
      RecommendationReasonCode.stableTieBreak,
    };
    final constraints = <RecommendationConstraint>[];

    final groupPosition = candidate.groupPosition;
    if (groupPosition != null) {
      score += (policy.groupPositionBonus - groupPosition * 2).clamp(0, 30);
      reasons.add(RecommendationReasonCode.groupAssignment);
    }

    if (_matchesFocus(candidate, request.effectiveFocusProfile)) {
      score += policy.focusBonus;
      reasons.add(RecommendationReasonCode.focusMatch);
    }

    if (_matchesTrainingGoal(candidate, request.effectiveTrainingGoal)) {
      score += 8;
      reasons.add(RecommendationReasonCode.focusMatch);
    }

    if (request.effectiveSessionDuration.minutes <=
            policy.shortSessionMinutes &&
        _isTimeEfficient(candidate)) {
      score += 10;
      reasons.add(RecommendationReasonCode.timeBudgetFit);
    }

    final balanceAdjustment = _balanceAdjustmentFor(
      candidate,
      request.muscleBalanceAssessment,
    );
    score += balanceAdjustment.scoreDelta;
    reasons.addAll(balanceAdjustment.reasons);

    if (_isReadinessSensitive(candidate, request.readiness)) {
      score -= policy.readinessHeavyPenalty;
      reasons.add(RecommendationReasonCode.readinessReducedIntensity);
    }

    for (final equipment in equipmentResult.availableEquipment) {
      final constraint = request.effectiveEquipmentInventory.loadConstraintFor(
        equipment,
      );
      final maxLoad = constraint?.maxLoadKg?.value;
      final requestedLoad = candidate.estimatedWorkingLoadKg;
      if (maxLoad != null && requestedLoad != null && requestedLoad > maxLoad) {
        suggestedLoadKg = suggestedLoadKg == null
            ? maxLoad
            : _min(suggestedLoadKg, maxLoad);
        score -= policy.loadConstraintPenalty;
        final recommendationConstraint = RecommendationConstraint(
          code: RecommendationConstraintCode.maxLoadExceeded,
          exerciseRef: candidate.exerciseRef,
          equipment: equipment,
          requestedLoadKg: requestedLoad,
          adjustedLoadKg: maxLoad,
        );
        constraints.add(recommendationConstraint);
        reasons.add(RecommendationReasonCode.loadAdjustedForConstraint);
      }
    }

    if (_substitutionAffects(candidate, request.substitutions)) {
      score -= 18;
      reasons.add(RecommendationReasonCode.substitutionApplied);
    } else if (request.substitutions.isNotEmpty) {
      score += 4;
      reasons.add(RecommendationReasonCode.substitutionApplied);
    }

    return _ScoredCandidate(
      candidate: candidate,
      score: score,
      reasons: reasons.toList(growable: false),
      constraints: constraints,
      suggestedLoadKg: suggestedLoadKg,
    );
  }
}

List<RecommendationAlternative> _alternativesForRecommended(
  _ScoredCandidate source,
  List<_ScoredCandidate> allScored,
) {
  final alternatives = <RecommendationAlternative>[];
  for (final candidate in allScored) {
    if (candidate.candidate.exerciseRef == source.candidate.exerciseRef) {
      continue;
    }
    if (!_isSimilar(source.candidate, candidate.candidate)) {
      continue;
    }
    alternatives.add(
      RecommendationAlternative(
        replacesExerciseRef: source.candidate.exerciseRef,
        exercise: candidate.candidate,
        score: RecommendationScore(candidate.score),
        reasons: const <RecommendationReasonCode>[
          RecommendationReasonCode.alternativeAvailable,
        ],
      ),
    );
    if (alternatives.length == 2) {
      break;
    }
  }
  return alternatives;
}

List<RecommendationAlternative> _alternativesForFiltered(
  List<RecommendationCandidate> allCandidates,
  List<_ScoredCandidate> scored,
  List<RecommendationConstraint> constraints,
) {
  final scoredCandidates = scored.map((item) => item.candidate).toList();
  final alternatives = <RecommendationAlternative>[];
  for (final constraint in constraints) {
    final filtered = _firstOrNull(
      allCandidates.where(
        (candidate) => candidate.exerciseRef == constraint.exerciseRef,
      ),
    );
    if (filtered == null) {
      continue;
    }

    final replacement = _firstOrNull(
      scoredCandidates.where((candidate) => _isSimilar(filtered, candidate)),
    );
    if (replacement == null) {
      continue;
    }

    alternatives.add(
      RecommendationAlternative(
        replacesExerciseRef: filtered.exerciseRef,
        exercise: replacement,
        score: RecommendationScore(0),
        reasons: const <RecommendationReasonCode>[
          RecommendationReasonCode.alternativeAvailable,
        ],
      ),
    );
  }
  return alternatives;
}

int _compareScoredCandidates(_ScoredCandidate left, _ScoredCandidate right) {
  final scoreCompare = right.score.compareTo(left.score);
  if (scoreCompare != 0) {
    return scoreCompare;
  }

  final leftPosition = left.candidate.groupPosition ?? 1 << 20;
  final rightPosition = right.candidate.groupPosition ?? 1 << 20;
  final positionCompare = leftPosition.compareTo(rightPosition);
  if (positionCompare != 0) {
    return positionCompare;
  }

  final sourceCompare = left.candidate.exerciseRef.source.index.compareTo(
    right.candidate.exerciseRef.source.index,
  );
  if (sourceCompare != 0) {
    return sourceCompare;
  }

  final idCompare = left.candidate.exerciseRef.id.compareTo(
    right.candidate.exerciseRef.id,
  );
  if (idCompare != 0) {
    return idCompare;
  }

  return left.candidate.exerciseRef.displayNameSnapshot.compareTo(
    right.candidate.exerciseRef.displayNameSnapshot,
  );
}

_EquipmentResult _equipmentResultFor(
  RecommendationCandidate candidate,
  EquipmentInventory inventory,
) {
  final availableEquipment = <AvailableEquipment>[];
  for (final tag in candidate.equipment) {
    final equipment = _equipmentForTag(tag.value);
    if (equipment == null || !inventory.contains(equipment)) {
      return _EquipmentResult(
        available: false,
        availableEquipment: availableEquipment,
        missingEquipment: equipment,
      );
    }
    availableEquipment.add(equipment);
  }

  return _EquipmentResult(
    available: true,
    availableEquipment: availableEquipment,
  );
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
    'cable' => AvailableEquipment.cable,
    'machine' => AvailableEquipment.machine,
    'smith_machine' => AvailableEquipment.smithMachine,
    'pull_up_bar' => AvailableEquipment.pullUpBar,
    'bench' => AvailableEquipment.bench,
    'rack' => AvailableEquipment.rack,
    'leg_press' => AvailableEquipment.legPress,
    _ => null,
  };
}

_BalanceAdjustment _balanceAdjustmentFor(
  RecommendationCandidate candidate,
  MuscleBalanceAssessment? assessment,
) {
  if (assessment == null) {
    return const _BalanceAdjustment();
  }

  var scoreDelta = 0.0;
  final reasons = <RecommendationReasonCode>{};
  for (final signal in assessment.signals) {
    switch (signal.type) {
      case MuscleBalanceSignalType.pushHeavy:
        if (_isPull(candidate)) {
          scoreDelta += 36;
          reasons.add(RecommendationReasonCode.balancePullPriority);
        }
        if (_isPush(candidate)) {
          scoreDelta -= 24;
          reasons.add(RecommendationReasonCode.balancePushSuppressed);
        }
      case MuscleBalanceSignalType.pullNeglect:
        if (_isPull(candidate)) {
          scoreDelta += 36;
          reasons.add(RecommendationReasonCode.balancePullPriority);
        }
      case MuscleBalanceSignalType.legNeglect:
      case MuscleBalanceSignalType.lowerBodyUnderTarget:
        if (_isLower(candidate)) {
          scoreDelta += 36;
          reasons.add(RecommendationReasonCode.balanceLowerPriority);
        } else {
          scoreDelta -= 5;
        }
      case MuscleBalanceSignalType.upperBodyUnderTarget:
        if (_isUpper(candidate)) {
          scoreDelta += 20;
          reasons.add(RecommendationReasonCode.focusMatch);
        }
      case MuscleBalanceSignalType.movementPatternGap:
        final patterns = signal.evidence.affectedMovementPatterns.map(
          (pattern) => pattern.value,
        );
        if (candidate.coversAnyPattern(patterns)) {
          scoreDelta += 18;
          reasons.add(RecommendationReasonCode.focusMatch);
        }
      case MuscleBalanceSignalType.insufficientData:
      case MuscleBalanceSignalType.balanced:
      case MuscleBalanceSignalType.incompleteData:
        break;
    }
  }

  return _BalanceAdjustment(
    scoreDelta: scoreDelta,
    reasons: reasons.toList(growable: false),
  );
}

bool _matchesFocus(RecommendationCandidate candidate, FocusProfile focus) {
  return switch (focus) {
    FocusProfile.lowerBodyGluteFocus => _isLower(candidate),
    FocusProfile.upperBodyFocus => _isUpper(candidate),
    FocusProfile.armsChestFocus =>
      candidate.coversAnyMuscle(const <String>[
            'chest',
            'biceps',
            'triceps',
            'front_deltoids',
          ]) ||
          _isPull(candidate),
    FocusProfile.strengthBasics => candidate.coversAnyPattern(const <String>[
      'squat',
      'hinge',
      'horizontal_push',
      'vertical_push',
      'horizontal_pull',
      'vertical_pull',
    ]),
    FocusProfile.timeEfficient => _isTimeEfficient(candidate),
    FocusProfile.beginnerFoundation => candidate.equipment.any((tag) {
      return tag.value == 'bodyweight' ||
          tag.value == 'dumbbell' ||
          tag.value == 'machine';
    }),
    FocusProfile.balanced || FocusProfile.custom => false,
  };
}

bool _matchesTrainingGoal(
  RecommendationCandidate candidate,
  TrainingGoal trainingGoal,
) {
  return switch (trainingGoal) {
    TrainingGoal.strength => candidate.coversAnyPattern(const <String>[
      'squat',
      'hinge',
      'horizontal_push',
      'vertical_push',
      'horizontal_pull',
      'vertical_pull',
    ]),
    TrainingGoal.hypertrophy => candidate.allMuscles.isNotEmpty,
    TrainingGoal.generalFitness ||
    TrainingGoal.recomposition ||
    TrainingGoal.maintenance => false,
  };
}

bool _isReadinessSensitive(
  RecommendationCandidate candidate,
  ReadinessReadModel? readiness,
) {
  final level = readiness?.level;
  final highSoreness =
      readiness?.reasons.contains(ReadinessReason.highSoreness) ?? false;
  if (level != ReadinessLevel.low &&
      level != ReadinessLevel.veryLow &&
      !highSoreness) {
    return false;
  }

  final load = candidate.estimatedWorkingLoadKg ?? 0;
  final usesHeavyEquipment = candidate.equipment.any((tag) {
    final equipment = _equipmentForTag(tag.value);
    return equipment == AvailableEquipment.barbell ||
        equipment == AvailableEquipment.smithMachine ||
        equipment == AvailableEquipment.legPress;
  });

  return load >= 80 ||
      usesHeavyEquipment ||
      candidate.primaryMuscles.length > 1;
}

bool _substitutionAffects(
  RecommendationCandidate candidate,
  List<RecommendationSubstitution> substitutions,
) {
  final key = _exerciseKey(candidate.exerciseRef);
  return substitutions.any((substitution) {
    return _exerciseKey(substitution.skippedExerciseRef) == key ||
        _exerciseKey(substitution.selectedExerciseRef) == key;
  });
}

bool _isSimilar(RecommendationCandidate left, RecommendationCandidate right) {
  if (left.exerciseRef == right.exerciseRef) {
    return false;
  }
  final leftMuscles = left.allMuscles.map((muscle) => muscle.value).toSet();
  final rightMuscles = right.allMuscles.map((muscle) => muscle.value).toSet();
  if (leftMuscles.intersection(rightMuscles).isNotEmpty) {
    return true;
  }

  final leftPatterns = left.movementPatterns
      .map((pattern) => pattern.value)
      .toSet();
  final rightPatterns = right.movementPatterns
      .map((pattern) => pattern.value)
      .toSet();
  return leftPatterns.intersection(rightPatterns).isNotEmpty;
}

bool _isTimeEfficient(RecommendationCandidate candidate) {
  return candidate.allMuscles.length >= 2 || candidate.equipment.length <= 1;
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

bool _isUpper(RecommendationCandidate candidate) {
  return _isPush(candidate) || _isPull(candidate);
}

String _exerciseKey(ExerciseRef exerciseRef) {
  return '${exerciseRef.source.name}:${exerciseRef.id}';
}

double _min(double left, double right) => left < right ? left : right;

T? _firstOrNull<T>(Iterable<T> values) {
  for (final value in values) {
    return value;
  }
  return null;
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

final class _EquipmentResult {
  const _EquipmentResult({
    required this.available,
    required this.availableEquipment,
    this.missingEquipment,
  });

  final bool available;
  final List<AvailableEquipment> availableEquipment;
  final AvailableEquipment? missingEquipment;
}

final class _ScoredCandidate {
  const _ScoredCandidate({
    required this.candidate,
    required this.score,
    required this.reasons,
    required this.constraints,
    required this.suggestedLoadKg,
  });

  final RecommendationCandidate candidate;
  final double score;
  final List<RecommendationReasonCode> reasons;
  final List<RecommendationConstraint> constraints;
  final double? suggestedLoadKg;
}

final class _BalanceAdjustment {
  const _BalanceAdjustment({
    this.scoreDelta = 0,
    this.reasons = const <RecommendationReasonCode>[],
  });

  final double scoreDelta;
  final List<RecommendationReasonCode> reasons;
}
