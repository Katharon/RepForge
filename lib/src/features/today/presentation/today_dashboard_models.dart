import '../../recovery/domain/recovery_domain.dart';
import '../../rest_timer/presentation/rest_timer_presentation.dart';
import '../../training_log/domain/training_log_domain.dart';

final class TodayDashboardReadModel {
  const TodayDashboardReadModel({
    required this.setCount,
    required this.totalVolumeKg,
    required this.restTimer,
    required this.readiness,
    this.lastLoggedSet,
  });

  final int setCount;
  final double totalVolumeKg;
  final TodayLastLoggedSetViewModel? lastLoggedSet;
  final RestTimerCountdownState restTimer;
  final ReadinessReadModel readiness;

  bool get hasLoggedSets => setCount > 0;

  bool get hasVisibleRestTimer => restTimer.isVisible;

  bool get hasReadinessEstimate =>
      readiness.status == ReadinessReadModelStatus.available;

  bool get hasUnusuallyHighDailyVolume {
    return const WorkoutSetInputGuard().isDailyVolumeUnusuallyHigh(
      totalVolumeKg,
    );
  }
}

final class TodayLastLoggedSetViewModel {
  const TodayLastLoggedSetViewModel({
    required this.exerciseName,
    required this.repetitions,
    required this.loadKg,
  });

  final String exerciseName;
  final int repetitions;
  final double loadKg;
}
