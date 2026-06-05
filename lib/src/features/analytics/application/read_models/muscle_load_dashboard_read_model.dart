import 'package:repforge/src/features/analytics/domain/analytics_domain.dart';
import 'package:repforge/src/features/recovery/domain/recovery_domain.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';

final class MuscleLoadDashboardReadModel {
  MuscleLoadDashboardReadModel({
    required this.weeklyEstimate,
    required this.rollingEstimate,
    required this.balanceAssessment,
    required this.focusProfile,
    required this.readiness,
    required this.weeklyLoggedSetCount,
    required this.rollingLoggedSetCount,
    required this.scannedSetCount,
    required this.historyLimit,
    required this.reachedHistoryLimit,
  });

  final MuscleLoadEstimate weeklyEstimate;
  final MuscleLoadEstimate rollingEstimate;
  final MuscleBalanceAssessment balanceAssessment;
  final FocusProfile focusProfile;
  final ReadinessReadModel readiness;
  final int weeklyLoggedSetCount;
  final int rollingLoggedSetCount;
  final int scannedSetCount;
  final int historyLimit;
  final bool reachedHistoryLimit;

  bool get hasLoggedSets => rollingLoggedSetCount > 0;
}
