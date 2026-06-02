import 'package:repforge/src/features/exercise_catalog/domain/exercise_catalog_domain.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';

import '../value_objects/muscle_activation.dart';
import '../value_objects/muscle_balance.dart';

final class MuscleBalanceDetector {
  const MuscleBalanceDetector({this.minimumLoggedSetCount = 3});

  final int minimumLoggedSetCount;

  MuscleBalanceAssessment assess(MuscleBalanceInput input) {
    final targetRange = MuscleBalanceTargetRange.forFocus(input.focusProfile);
    final totalKnownLoadKg = input.muscleLoadEstimate.totalKnownLoadKg;
    if (input.loggedSetCount < minimumLoggedSetCount || totalKnownLoadKg <= 0) {
      return MuscleBalanceAssessment(
        status: MuscleBalanceAssessmentStatus.insufficientData,
        confidence: MuscleBalanceConfidence.insufficient,
        targetRange: targetRange,
        signals: <MuscleBalanceSignal>[
          MuscleBalanceSignal(
            type: MuscleBalanceSignalType.insufficientData,
            severity: MuscleBalanceSeverity.info,
            evidence: MuscleBalanceEvidence(
              code: 'muscle_balance.insufficient_data',
              actualValue: input.loggedSetCount.toDouble(),
              targetMinimum: minimumLoggedSetCount.toDouble(),
            ),
          ),
        ],
        totalKnownLoadKg: totalKnownLoadKg,
        rollingWindow: input.rollingWindow,
      );
    }

    final signals = <MuscleBalanceSignal>[];
    final confidence = _confidenceFor(input.muscleLoadEstimate.confidence);

    if (input.muscleLoadEstimate.confidence ==
            MuscleLoadConfidence.unavailable ||
        input.muscleLoadEstimate.unknownExercises.isNotEmpty) {
      signals.add(
        MuscleBalanceSignal(
          type: MuscleBalanceSignalType.incompleteData,
          severity: MuscleBalanceSeverity.info,
          evidence: MuscleBalanceEvidence(
            code: 'muscle_balance.incomplete_activation_data',
            unknownExerciseCount:
                input.muscleLoadEstimate.unknownExercises.length,
          ),
        ),
      );
    }

    final loadBuckets = _LoadBuckets.from(input.muscleLoadEstimate.muscleLoads);
    final lowerShare = loadBuckets.lowerLoadKg / totalKnownLoadKg;
    final upperShare = loadBuckets.upperLoadKg / totalKnownLoadKg;
    final pushPullRatio = loadBuckets.pullLoadKg == 0
        ? double.infinity
        : loadBuckets.pushLoadKg / loadBuckets.pullLoadKg;

    if (pushPullRatio > targetRange.pushPullRatioMaximum &&
        loadBuckets.pushLoadKg > 0) {
      signals.add(
        MuscleBalanceSignal(
          type: MuscleBalanceSignalType.pushHeavy,
          severity: MuscleBalanceSeverity.watch,
          evidence: MuscleBalanceEvidence(
            code: 'muscle_balance.push_heavy',
            actualValue: pushPullRatio,
            targetMaximum: targetRange.pushPullRatioMaximum,
            affectedMuscles: _pushMuscles,
          ),
        ),
      );
    }

    if (loadBuckets.pullLoadKg <= 0 ||
        loadBuckets.pullLoadKg < loadBuckets.pushLoadKg / 2.2) {
      signals.add(
        MuscleBalanceSignal(
          type: MuscleBalanceSignalType.pullNeglect,
          severity: MuscleBalanceSeverity.attention,
          evidence: MuscleBalanceEvidence(
            code: 'muscle_balance.pull_neglect',
            actualValue: loadBuckets.pullLoadKg / totalKnownLoadKg,
            targetMinimum: 0.18,
            affectedMuscles: _pullMuscles,
          ),
        ),
      );
    }

    if (lowerShare < targetRange.lowerBodyShareMinimum) {
      final type = targetRange.focusProfile == FocusProfile.lowerBodyGluteFocus
          ? MuscleBalanceSignalType.lowerBodyUnderTarget
          : MuscleBalanceSignalType.legNeglect;
      signals.add(
        MuscleBalanceSignal(
          type: type,
          severity: MuscleBalanceSeverity.attention,
          evidence: MuscleBalanceEvidence(
            code: type == MuscleBalanceSignalType.lowerBodyUnderTarget
                ? 'muscle_balance.lower_body_under_target'
                : 'muscle_balance.leg_neglect',
            actualValue: lowerShare,
            targetMinimum: targetRange.lowerBodyShareMinimum,
            affectedMuscles: _lowerMuscles,
          ),
        ),
      );
    }

    if (targetRange.focusProfile == FocusProfile.lowerBodyGluteFocus &&
        upperShare < targetRange.upperBodyShareMinimum) {
      signals.add(
        MuscleBalanceSignal(
          type: MuscleBalanceSignalType.upperBodyUnderTarget,
          severity: MuscleBalanceSeverity.watch,
          evidence: MuscleBalanceEvidence(
            code: 'muscle_balance.upper_body_under_target',
            actualValue: upperShare,
            targetMinimum: targetRange.upperBodyShareMinimum,
            affectedMuscles: <MuscleId>[..._pushMuscles, ..._pullMuscles],
          ),
        ),
      );
    }

    final movementGap = _movementPatternGapFor(
      input.movementPatternCoverage,
      targetRange.focusProfile,
    );
    if (movementGap.isNotEmpty) {
      signals.add(
        MuscleBalanceSignal(
          type: MuscleBalanceSignalType.movementPatternGap,
          severity: MuscleBalanceSeverity.watch,
          evidence: MuscleBalanceEvidence(
            code: 'muscle_balance.movement_pattern_gap',
            affectedMovementPatterns: movementGap,
          ),
        ),
      );
    }

    final imbalanceSignals = signals
        .where(
          (signal) => signal.type != MuscleBalanceSignalType.incompleteData,
        )
        .toList(growable: false);
    if (imbalanceSignals.isEmpty) {
      signals.add(
        MuscleBalanceSignal(
          type: MuscleBalanceSignalType.balanced,
          severity: MuscleBalanceSeverity.info,
          evidence: MuscleBalanceEvidence(
            code: 'muscle_balance.balanced',
            actualValue: lowerShare,
            targetMinimum: targetRange.lowerBodyShareMinimum,
          ),
        ),
      );
    }

    return MuscleBalanceAssessment(
      status: imbalanceSignals.isEmpty
          ? MuscleBalanceAssessmentStatus.balanced
          : MuscleBalanceAssessmentStatus.imbalanced,
      confidence: confidence,
      targetRange: targetRange,
      signals: signals,
      totalKnownLoadKg: totalKnownLoadKg,
      rollingWindow: input.rollingWindow,
    );
  }

  MuscleBalanceConfidence _confidenceFor(MuscleLoadConfidence confidence) {
    return switch (confidence) {
      MuscleLoadConfidence.estimated => MuscleBalanceConfidence.high,
      MuscleLoadConfidence.conservative => MuscleBalanceConfidence.medium,
      MuscleLoadConfidence.unavailable => MuscleBalanceConfidence.low,
    };
  }

  List<MovementPattern> _movementPatternGapFor(
    MovementPatternCoverage coverage,
    FocusProfile focusProfile,
  ) {
    if (coverage.state == MovementPatternCoverageState.unknown) {
      return const <MovementPattern>[];
    }

    final requiredGroups = switch (focusProfile) {
      FocusProfile.upperBodyFocus ||
      FocusProfile.armsChestFocus => const [_pushPatterns, _pullPatterns],
      FocusProfile.lowerBodyGluteFocus => const [
        _pullPatterns,
        _squatPatterns,
        _hingePatterns,
      ],
      _ => const [_pushPatterns, _pullPatterns, _squatPatterns, _hingePatterns],
    };

    final missing = <MovementPattern>[];
    for (final group in requiredGroups) {
      if (!coverage.coversAny(group)) {
        missing.add(MovementPattern(group.first));
      }
    }

    return missing;
  }
}

final class _LoadBuckets {
  const _LoadBuckets({
    required this.pushLoadKg,
    required this.pullLoadKg,
    required this.lowerLoadKg,
  });

  factory _LoadBuckets.from(List<MuscleLoad> loads) {
    var pushLoadKg = 0.0;
    var pullLoadKg = 0.0;
    var lowerLoadKg = 0.0;

    for (final load in loads) {
      final muscleId = load.muscleId.value;
      if (_pushMuscleValues.contains(muscleId)) {
        pushLoadKg += load.estimatedLoadKg;
      }
      if (_pullMuscleValues.contains(muscleId)) {
        pullLoadKg += load.estimatedLoadKg;
      }
      if (_lowerMuscleValues.contains(muscleId)) {
        lowerLoadKg += load.estimatedLoadKg;
      }
    }

    return _LoadBuckets(
      pushLoadKg: pushLoadKg,
      pullLoadKg: pullLoadKg,
      lowerLoadKg: lowerLoadKg,
    );
  }

  final double pushLoadKg;
  final double pullLoadKg;
  final double lowerLoadKg;

  double get upperLoadKg => pushLoadKg + pullLoadKg;
}

final _pushMuscles = <MuscleId>[
  MuscleId('chest'),
  MuscleId('triceps'),
  MuscleId('front_deltoids'),
  MuscleId('shoulders'),
  MuscleId('upper_chest'),
];

final _pullMuscles = <MuscleId>[
  MuscleId('lats'),
  MuscleId('upper_back'),
  MuscleId('rear_deltoids'),
  MuscleId('biceps'),
  MuscleId('forearms'),
  MuscleId('traps'),
];

final _lowerMuscles = <MuscleId>[
  MuscleId('quadriceps'),
  MuscleId('hamstrings'),
  MuscleId('glutes'),
  MuscleId('calves'),
  MuscleId('erector_spinae'),
];

final _pushMuscleValues = _pushMuscles.map((muscle) => muscle.value).toSet();
final _pullMuscleValues = _pullMuscles.map((muscle) => muscle.value).toSet();
final _lowerMuscleValues = _lowerMuscles.map((muscle) => muscle.value).toSet();

const _pushPatterns = <String>['horizontal_push', 'vertical_push'];
const _pullPatterns = <String>['horizontal_pull', 'vertical_pull'];
const _squatPatterns = <String>['squat', 'knee_dominant', 'lunge'];
const _hingePatterns = <String>['hinge'];
