import 'logged_set_values.dart';

enum WorkoutSetInputWarningReason {
  highRepetitions,
  highLoad,
  highSetVolume,
  highDailyVolume,
}

final class WorkoutSetInputGuardThresholds {
  const WorkoutSetInputGuardThresholds({
    this.highRepetitions = 100,
    this.highLoadKg = 500,
    this.highSetVolumeKg = 20000,
    this.highDailyVolumeKg = 100000,
  });

  final int highRepetitions;
  final double highLoadKg;
  final double highSetVolumeKg;
  final double highDailyVolumeKg;
}

final class WorkoutSetInputGuardInput {
  const WorkoutSetInputGuardInput({
    required this.repetitions,
    required this.load,
  });

  final Repetitions repetitions;
  final LoadKg load;

  double get setVolumeKg => repetitions.value * load.value;
}

final class WorkoutSetInputGuardResult {
  const WorkoutSetInputGuardResult({required this.reasons});

  final List<WorkoutSetInputWarningReason> reasons;

  bool get hasWarning => reasons.isNotEmpty;

  bool contains(WorkoutSetInputWarningReason reason) {
    return reasons.contains(reason);
  }
}

final class WorkoutSetInputGuard {
  const WorkoutSetInputGuard({
    this.thresholds = const WorkoutSetInputGuardThresholds(),
  });

  final WorkoutSetInputGuardThresholds thresholds;

  WorkoutSetInputGuardResult evaluate(WorkoutSetInputGuardInput input) {
    final reasons = <WorkoutSetInputWarningReason>[];
    if (input.repetitions.value > thresholds.highRepetitions) {
      reasons.add(WorkoutSetInputWarningReason.highRepetitions);
    }
    if (input.load.value > thresholds.highLoadKg) {
      reasons.add(WorkoutSetInputWarningReason.highLoad);
    }
    if (input.setVolumeKg > thresholds.highSetVolumeKg) {
      reasons.add(WorkoutSetInputWarningReason.highSetVolume);
    }

    return WorkoutSetInputGuardResult(
      reasons: List<WorkoutSetInputWarningReason>.unmodifiable(reasons),
    );
  }

  WorkoutSetInputGuardResult evaluateDailyVolume(double totalVolumeKg) {
    if (totalVolumeKg > thresholds.highDailyVolumeKg) {
      return const WorkoutSetInputGuardResult(
        reasons: [WorkoutSetInputWarningReason.highDailyVolume],
      );
    }

    return const WorkoutSetInputGuardResult(reasons: []);
  }

  bool isSetUnusuallyHigh({
    required Repetitions repetitions,
    required LoadKg load,
  }) {
    return evaluate(
      WorkoutSetInputGuardInput(repetitions: repetitions, load: load),
    ).hasWarning;
  }

  bool isDailyVolumeUnusuallyHigh(double totalVolumeKg) {
    return evaluateDailyVolume(totalVolumeKg).hasWarning;
  }
}
