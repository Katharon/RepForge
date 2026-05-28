import '../../rest_timer/presentation/rest_timer_presentation.dart';

final class TodayDashboardReadModel {
  const TodayDashboardReadModel({
    required this.setCount,
    required this.totalVolumeKg,
    required this.restTimer,
    this.lastLoggedSet,
  });

  final int setCount;
  final double totalVolumeKg;
  final TodayLastLoggedSetViewModel? lastLoggedSet;
  final RestTimerCountdownState restTimer;

  bool get hasLoggedSets => setCount > 0;

  bool get hasVisibleRestTimer => restTimer.isVisible;
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
