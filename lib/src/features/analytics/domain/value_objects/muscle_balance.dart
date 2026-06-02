import 'package:repforge/src/features/exercise_catalog/domain/exercise_catalog_domain.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';

import 'muscle_activation.dart';

enum MuscleBalanceAssessmentStatus { insufficientData, balanced, imbalanced }

enum MuscleBalanceSignalType {
  insufficientData,
  balanced,
  pushHeavy,
  pullNeglect,
  legNeglect,
  lowerBodyUnderTarget,
  upperBodyUnderTarget,
  movementPatternGap,
  incompleteData,
}

enum MuscleBalanceSeverity { info, watch, attention }

enum MuscleBalanceConfidence { high, medium, low, insufficient }

enum MovementPatternCoverageState { unknown, known }

final class MuscleBalanceRollingWindow {
  const MuscleBalanceRollingWindow({
    required this.startInclusive,
    required this.endExclusive,
  });

  final DateTime startInclusive;
  final DateTime endExclusive;

  @override
  bool operator ==(Object other) {
    return other is MuscleBalanceRollingWindow &&
        other.startInclusive == startInclusive &&
        other.endExclusive == endExclusive;
  }

  @override
  int get hashCode => Object.hash(startInclusive, endExclusive);
}

final class MuscleBalanceTargetRange {
  const MuscleBalanceTargetRange({
    required this.focusProfile,
    required this.lowerBodyShareMinimum,
    required this.upperBodyShareMinimum,
    required this.pushPullRatioMaximum,
  });

  factory MuscleBalanceTargetRange.forFocus(FocusProfile? focusProfile) {
    final resolvedFocus = focusProfile ?? FocusProfile.balanced;
    return switch (resolvedFocus) {
      FocusProfile.upperBodyFocus => const MuscleBalanceTargetRange(
        focusProfile: FocusProfile.upperBodyFocus,
        lowerBodyShareMinimum: 0.1,
        upperBodyShareMinimum: 0.65,
        pushPullRatioMaximum: 1.8,
      ),
      FocusProfile.lowerBodyGluteFocus => const MuscleBalanceTargetRange(
        focusProfile: FocusProfile.lowerBodyGluteFocus,
        lowerBodyShareMinimum: 0.4,
        upperBodyShareMinimum: 0.25,
        pushPullRatioMaximum: 1.6,
      ),
      FocusProfile.armsChestFocus => const MuscleBalanceTargetRange(
        focusProfile: FocusProfile.armsChestFocus,
        lowerBodyShareMinimum: 0.12,
        upperBodyShareMinimum: 0.55,
        pushPullRatioMaximum: 1.7,
      ),
      FocusProfile.strengthBasics ||
      FocusProfile.timeEfficient ||
      FocusProfile.beginnerFoundation ||
      FocusProfile.custom ||
      FocusProfile.balanced => MuscleBalanceTargetRange(
        focusProfile: resolvedFocus == FocusProfile.custom
            ? FocusProfile.balanced
            : resolvedFocus,
        lowerBodyShareMinimum: 0.25,
        upperBodyShareMinimum: 0.45,
        pushPullRatioMaximum: 1.6,
      ),
    };
  }

  final FocusProfile focusProfile;
  final double lowerBodyShareMinimum;
  final double upperBodyShareMinimum;
  final double pushPullRatioMaximum;

  @override
  bool operator ==(Object other) {
    return other is MuscleBalanceTargetRange &&
        other.focusProfile == focusProfile &&
        other.lowerBodyShareMinimum == lowerBodyShareMinimum &&
        other.upperBodyShareMinimum == upperBodyShareMinimum &&
        other.pushPullRatioMaximum == pushPullRatioMaximum;
  }

  @override
  int get hashCode {
    return Object.hash(
      focusProfile,
      lowerBodyShareMinimum,
      upperBodyShareMinimum,
      pushPullRatioMaximum,
    );
  }
}

final class MovementPatternCoverage {
  const MovementPatternCoverage._({
    required this.state,
    required this.patterns,
  });

  factory MovementPatternCoverage.unknown() {
    return const MovementPatternCoverage._(
      state: MovementPatternCoverageState.unknown,
      patterns: <MovementPattern>[],
    );
  }

  factory MovementPatternCoverage.known({
    required Iterable<MovementPattern> patterns,
  }) {
    return MovementPatternCoverage._known(patterns);
  }

  MovementPatternCoverage._known(Iterable<MovementPattern> sourcePatterns)
    : state = MovementPatternCoverageState.known,
      patterns = _dedupePatterns(sourcePatterns);

  final MovementPatternCoverageState state;
  final List<MovementPattern> patterns;

  bool coversAny(Iterable<String> patternValues) {
    final allowed = patternValues.toSet();
    for (final pattern in patterns) {
      if (allowed.contains(pattern.value)) {
        return true;
      }
    }

    return false;
  }

  @override
  bool operator ==(Object other) {
    return other is MovementPatternCoverage &&
        other.state == state &&
        _listEquals(other.patterns, patterns);
  }

  @override
  int get hashCode => Object.hash(state, Object.hashAll(patterns));
}

final class MuscleBalanceInput {
  MuscleBalanceInput({
    required this.muscleLoadEstimate,
    required this.loggedSetCount,
    this.focusProfile,
    MovementPatternCoverage? movementPatternCoverage,
    this.rollingWindow,
  }) : movementPatternCoverage =
           movementPatternCoverage ?? MovementPatternCoverage.unknown();

  final MuscleLoadEstimate muscleLoadEstimate;
  final int loggedSetCount;
  final FocusProfile? focusProfile;
  final MovementPatternCoverage movementPatternCoverage;
  final MuscleBalanceRollingWindow? rollingWindow;
}

final class MuscleBalanceEvidence {
  MuscleBalanceEvidence({
    required this.code,
    this.actualValue,
    this.targetMinimum,
    this.targetMaximum,
    Iterable<MuscleId> affectedMuscles = const <MuscleId>[],
    Iterable<MovementPattern> affectedMovementPatterns =
        const <MovementPattern>[],
    this.unknownExerciseCount = 0,
  }) : affectedMuscles = List<MuscleId>.unmodifiable(affectedMuscles),
       affectedMovementPatterns = List<MovementPattern>.unmodifiable(
         affectedMovementPatterns,
       );

  final String code;
  final double? actualValue;
  final double? targetMinimum;
  final double? targetMaximum;
  final List<MuscleId> affectedMuscles;
  final List<MovementPattern> affectedMovementPatterns;
  final int unknownExerciseCount;

  @override
  bool operator ==(Object other) {
    return other is MuscleBalanceEvidence &&
        other.code == code &&
        other.actualValue == actualValue &&
        other.targetMinimum == targetMinimum &&
        other.targetMaximum == targetMaximum &&
        _listEquals(other.affectedMuscles, affectedMuscles) &&
        _listEquals(other.affectedMovementPatterns, affectedMovementPatterns) &&
        other.unknownExerciseCount == unknownExerciseCount;
  }

  @override
  int get hashCode {
    return Object.hash(
      code,
      actualValue,
      targetMinimum,
      targetMaximum,
      Object.hashAll(affectedMuscles),
      Object.hashAll(affectedMovementPatterns),
      unknownExerciseCount,
    );
  }
}

final class MuscleBalanceSignal {
  const MuscleBalanceSignal({
    required this.type,
    required this.severity,
    required this.evidence,
  });

  final MuscleBalanceSignalType type;
  final MuscleBalanceSeverity severity;
  final MuscleBalanceEvidence evidence;

  @override
  bool operator ==(Object other) {
    return other is MuscleBalanceSignal &&
        other.type == type &&
        other.severity == severity &&
        other.evidence == evidence;
  }

  @override
  int get hashCode => Object.hash(type, severity, evidence);
}

final class MuscleBalanceAssessment {
  MuscleBalanceAssessment({
    required this.status,
    required this.confidence,
    required this.targetRange,
    required Iterable<MuscleBalanceSignal> signals,
    required this.totalKnownLoadKg,
    this.rollingWindow,
  }) : signals = List<MuscleBalanceSignal>.unmodifiable(signals);

  final MuscleBalanceAssessmentStatus status;
  final MuscleBalanceConfidence confidence;
  final MuscleBalanceTargetRange targetRange;
  final List<MuscleBalanceSignal> signals;
  final double totalKnownLoadKg;
  final MuscleBalanceRollingWindow? rollingWindow;

  MuscleBalanceSignal? signalOfType(MuscleBalanceSignalType type) {
    for (final signal in signals) {
      if (signal.type == type) {
        return signal;
      }
    }

    return null;
  }

  @override
  bool operator ==(Object other) {
    return other is MuscleBalanceAssessment &&
        other.status == status &&
        other.confidence == confidence &&
        other.targetRange == targetRange &&
        _listEquals(other.signals, signals) &&
        other.totalKnownLoadKg == totalKnownLoadKg &&
        other.rollingWindow == rollingWindow;
  }

  @override
  int get hashCode {
    return Object.hash(
      status,
      confidence,
      targetRange,
      Object.hashAll(signals),
      totalKnownLoadKg,
      rollingWindow,
    );
  }
}

List<MovementPattern> _dedupePatterns(Iterable<MovementPattern> patterns) {
  final byValue = <String, MovementPattern>{};
  for (final pattern in patterns) {
    byValue.putIfAbsent(pattern.value, () => pattern);
  }

  return List<MovementPattern>.unmodifiable(byValue.values);
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
