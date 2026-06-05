import 'package:repforge/src/features/analytics/application/analytics_application.dart';
import 'package:repforge/src/features/analytics/domain/analytics_domain.dart';
import 'package:repforge/src/features/recovery/domain/recovery_domain.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';

enum MuscleLoadDashboardOverallStatus {
  empty,
  onTrack,
  underTarget,
  overEmphasized,
  partialData,
  recoveryLimited,
}

enum MuscleLoadSignalStatus {
  onTrack,
  underTarget,
  overEmphasized,
  partialData,
  recoveryLimited,
}

final class MuscleLoadDashboardViewModel {
  MuscleLoadDashboardViewModel({
    required this.overallStatus,
    required this.focusProfile,
    required this.weeklyLoadKg,
    required this.rollingLoadKg,
    required this.loggedSetCount,
    required this.unknownExerciseCount,
    required this.topMuscles,
    required this.signals,
  });

  factory MuscleLoadDashboardViewModel.fromReadModel(
    MuscleLoadDashboardReadModel model,
  ) {
    if (!model.hasLoggedSets) {
      return MuscleLoadDashboardViewModel(
        overallStatus: MuscleLoadDashboardOverallStatus.empty,
        focusProfile: model.focusProfile,
        weeklyLoadKg: 0,
        rollingLoadKg: 0,
        loggedSetCount: 0,
        unknownExerciseCount: 0,
        topMuscles: const <MuscleLoadMetricViewModel>[],
        signals: const <MuscleBalanceSignalViewModel>[],
      );
    }

    final signals = <MuscleBalanceSignalViewModel>[
      if (_isRecoveryLimited(model.readiness))
        MuscleBalanceSignalViewModel(
          status: MuscleLoadSignalStatus.recoveryLimited,
          code: 'muscle_load.recovery_limited',
          affectedMuscles: const <String>[],
          affectedMovementPatterns: const <String>[],
        ),
      ...model.balanceAssessment.signals.map(
        MuscleBalanceSignalViewModel.fromSignal,
      ),
    ];

    return MuscleLoadDashboardViewModel(
      overallStatus: _overallStatusFor(signals),
      focusProfile: model.focusProfile,
      weeklyLoadKg: model.weeklyEstimate.totalKnownLoadKg,
      rollingLoadKg: model.rollingEstimate.totalKnownLoadKg,
      loggedSetCount: model.rollingLoggedSetCount,
      unknownExerciseCount: model.rollingEstimate.unknownExercises.length,
      topMuscles: _topMuscles(model.rollingEstimate),
      signals: signals,
    );
  }

  final MuscleLoadDashboardOverallStatus overallStatus;
  final FocusProfile focusProfile;
  final double weeklyLoadKg;
  final double rollingLoadKg;
  final int loggedSetCount;
  final int unknownExerciseCount;
  final List<MuscleLoadMetricViewModel> topMuscles;
  final List<MuscleBalanceSignalViewModel> signals;
}

final class MuscleLoadMetricViewModel {
  const MuscleLoadMetricViewModel({
    required this.muscleId,
    required this.estimatedLoadKg,
    required this.share,
  });

  final String muscleId;
  final double estimatedLoadKg;
  final double share;
}

final class MuscleBalanceSignalViewModel {
  const MuscleBalanceSignalViewModel({
    required this.status,
    required this.code,
    required this.affectedMuscles,
    required this.affectedMovementPatterns,
  });

  factory MuscleBalanceSignalViewModel.fromSignal(MuscleBalanceSignal signal) {
    return MuscleBalanceSignalViewModel(
      status: _statusForSignal(signal.type),
      code: signal.evidence.code,
      affectedMuscles: signal.evidence.affectedMuscles
          .map((muscle) => muscle.value)
          .toList(growable: false),
      affectedMovementPatterns: signal.evidence.affectedMovementPatterns
          .map((pattern) => pattern.value)
          .toList(growable: false),
    );
  }

  final MuscleLoadSignalStatus status;
  final String code;
  final List<String> affectedMuscles;
  final List<String> affectedMovementPatterns;
}

bool _isRecoveryLimited(ReadinessReadModel readiness) {
  return readiness.level == ReadinessLevel.low ||
      readiness.level == ReadinessLevel.veryLow;
}

MuscleLoadDashboardOverallStatus _overallStatusFor(
  List<MuscleBalanceSignalViewModel> signals,
) {
  if (signals.any(
    (signal) => signal.status == MuscleLoadSignalStatus.recoveryLimited,
  )) {
    return MuscleLoadDashboardOverallStatus.recoveryLimited;
  }
  if (signals.any(
    (signal) => signal.status == MuscleLoadSignalStatus.underTarget,
  )) {
    return MuscleLoadDashboardOverallStatus.underTarget;
  }
  if (signals.any(
    (signal) => signal.status == MuscleLoadSignalStatus.overEmphasized,
  )) {
    return MuscleLoadDashboardOverallStatus.overEmphasized;
  }
  if (signals.any(
    (signal) => signal.status == MuscleLoadSignalStatus.partialData,
  )) {
    return MuscleLoadDashboardOverallStatus.partialData;
  }

  return MuscleLoadDashboardOverallStatus.onTrack;
}

MuscleLoadSignalStatus _statusForSignal(MuscleBalanceSignalType type) {
  return switch (type) {
    MuscleBalanceSignalType.balanced => MuscleLoadSignalStatus.onTrack,
    MuscleBalanceSignalType.pushHeavy => MuscleLoadSignalStatus.overEmphasized,
    MuscleBalanceSignalType.pullNeglect ||
    MuscleBalanceSignalType.legNeglect ||
    MuscleBalanceSignalType.lowerBodyUnderTarget ||
    MuscleBalanceSignalType.upperBodyUnderTarget ||
    MuscleBalanceSignalType.movementPatternGap =>
      MuscleLoadSignalStatus.underTarget,
    MuscleBalanceSignalType.incompleteData ||
    MuscleBalanceSignalType.insufficientData =>
      MuscleLoadSignalStatus.partialData,
  };
}

List<MuscleLoadMetricViewModel> _topMuscles(MuscleLoadEstimate estimate) {
  final total = estimate.totalKnownLoadKg;
  if (total <= 0) {
    return const <MuscleLoadMetricViewModel>[];
  }
  final sorted = estimate.muscleLoads.toList()
    ..sort(
      (left, right) => right.estimatedLoadKg.compareTo(left.estimatedLoadKg),
    );

  return sorted
      .take(5)
      .map(
        (load) => MuscleLoadMetricViewModel(
          muscleId: load.muscleId.value,
          estimatedLoadKg: load.estimatedLoadKg,
          share: load.estimatedLoadKg / total,
        ),
      )
      .toList(growable: false);
}
