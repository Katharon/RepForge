import '../../rest_timer/application/rest_timer_application.dart';
import '../../rest_timer/presentation/rest_timer_presentation.dart';
import 'today_dashboard_models.dart';

abstract interface class TodayDashboardLoader {
  Future<TodayDashboardReadModel> load();
}

final class RestTimerTodayDashboardLoader implements TodayDashboardLoader {
  const RestTimerTodayDashboardLoader({required this.restTimerNotifications});

  final RestTimerNotificationCoordinator restTimerNotifications;

  @override
  Future<TodayDashboardReadModel> load() async {
    return TodayDashboardReadModel(
      setCount: 0,
      totalVolumeKg: 0,
      restTimer: RestTimerCountdownState.fromSnapshot(
        restTimerNotifications.snapshot,
      ),
    );
  }
}
