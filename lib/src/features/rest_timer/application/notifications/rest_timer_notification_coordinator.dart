import '../../domain/rest_timer_domain.dart';
import '../rest_timer_controller.dart';
import 'rest_timer_notification_gateway.dart';

final class RestTimerNotificationCoordinator {
  RestTimerNotificationCoordinator({
    required this.timerController,
    required this.notificationGateway,
    this.notificationId = defaultNotificationId,
  });

  static const int defaultNotificationId = 1701;

  final RestTimerController timerController;
  final RestTimerNotificationGateway notificationGateway;
  final int notificationId;
  bool _hasScheduledNotification = false;

  RestTimerSnapshot get snapshot => timerController.snapshot;

  Future<RestTimerSnapshot> start(
    RestTimerDuration duration, {
    required RestTimerNotificationContent content,
  }) async {
    await _cancelScheduledNotification();

    final snapshot = timerController.start(duration);
    final targetAt = snapshot.targetAt;
    if (targetAt == null) {
      return snapshot;
    }

    final permission = await notificationGateway.requestPermission();
    if (permission != RestTimerNotificationPermissionStatus.granted) {
      return snapshot;
    }

    await notificationGateway.scheduleRestTimerFinished(
      RestTimerNotificationRequest(
        notificationId: notificationId,
        targetAt: targetAt,
        content: content.privacySafe,
      ),
    );
    _hasScheduledNotification = true;
    return snapshot;
  }

  Future<RestTimerSnapshot> tick() async {
    final snapshot = timerController.tick();
    if (snapshot.status == RestTimerStatus.finished) {
      await _cancelScheduledNotification();
    }
    return snapshot;
  }

  Future<RestTimerSnapshot> cancel() async {
    final snapshot = timerController.cancel();
    await _cancelScheduledNotification();
    return snapshot;
  }

  Future<RestTimerSnapshot> reset() async {
    final snapshot = timerController.reset();
    await _cancelScheduledNotification();
    return snapshot;
  }

  Future<void> _cancelScheduledNotification() async {
    if (!_hasScheduledNotification) {
      return;
    }

    await notificationGateway.cancelRestTimer(notificationId);
    _hasScheduledNotification = false;
  }
}
