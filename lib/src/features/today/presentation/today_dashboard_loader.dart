import '../../recovery/application/recovery_application.dart';
import '../../rest_timer/application/rest_timer_application.dart';
import '../../rest_timer/presentation/rest_timer_presentation.dart';
import '../../training_log/domain/training_log_domain.dart';
import 'today_dashboard_models.dart';

typedef TodayDashboardNowProvider = DateTime Function();

abstract interface class TodayDashboardLoader {
  Future<TodayDashboardReadModel> load();
}

final class RestTimerTodayDashboardLoader implements TodayDashboardLoader {
  const RestTimerTodayDashboardLoader({
    required this.restTimerNotifications,
    required this.workoutSetRepository,
    required this.getTodayReadiness,
    this.nowProvider = _systemNow,
  });

  final RestTimerNotificationCoordinator restTimerNotifications;
  final WorkoutSetRepository workoutSetRepository;
  final GetTodayReadiness getTodayReadiness;
  final TodayDashboardNowProvider nowProvider;

  @override
  Future<TodayDashboardReadModel> load() async {
    final now = nowProvider().toLocal();
    final dayStart = DateTime(now.year, now.month, now.day);
    final summary = await workoutSetRepository.dailySummary(
      WorkoutSetDailySummaryQuery(
        startInclusive: dayStart,
        endExclusive: dayStart.add(const Duration(days: 1)),
      ),
    );
    final lastLoggedSet = summary.lastLoggedSet;
    final readiness = await getTodayReadiness();

    return TodayDashboardReadModel(
      setCount: summary.setCount,
      totalVolumeKg: summary.totalVolumeKg,
      lastLoggedSet: lastLoggedSet == null
          ? null
          : TodayLastLoggedSetViewModel(
              exerciseName: lastLoggedSet.exerciseRef.displayNameSnapshot,
              repetitions: lastLoggedSet.repetitions.value,
              loadKg: lastLoggedSet.load.value,
            ),
      restTimer: RestTimerCountdownState.fromSnapshot(
        restTimerNotifications.snapshot,
      ),
      readiness: readiness,
    );
  }
}

DateTime _systemNow() => DateTime.now();
