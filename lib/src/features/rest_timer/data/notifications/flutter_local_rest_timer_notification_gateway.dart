import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as timezone_data;
import 'package:timezone/timezone.dart' as timezone;

import '../../application/rest_timer_application.dart';

final class FlutterLocalRestTimerNotificationGateway
    implements RestTimerNotificationGateway {
  FlutterLocalRestTimerNotificationGateway({
    FlutterLocalNotificationsPlugin? plugin,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const String _androidChannelId = 'rest_timer';
  static const String _androidChannelName = 'Rest timer';
  static const String _androidChannelDescription =
      'Notifications when a rest timer finishes.';

  final FlutterLocalNotificationsPlugin _plugin;
  bool _isInitialized = false;

  @override
  Future<RestTimerNotificationPermissionStatus> requestPermission() async {
    await _ensureInitialized();

    final androidGranted = await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    final iosGranted = await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, sound: true);

    if (androidGranted == false || iosGranted == false) {
      return RestTimerNotificationPermissionStatus.denied;
    }

    return RestTimerNotificationPermissionStatus.granted;
  }

  @override
  Future<void> scheduleRestTimerFinished(
    RestTimerNotificationRequest request,
  ) async {
    await _ensureInitialized();

    await _plugin.zonedSchedule(
      id: request.notificationId,
      title: request.content.title,
      body: request.content.body,
      scheduledDate: timezone.TZDateTime.from(
        request.targetAt.toUtc(),
        timezone.UTC,
      ),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannelId,
          _androidChannelName,
          channelDescription: _androidChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: false,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: 'rest_timer_finished',
    );
  }

  @override
  Future<void> cancelRestTimer(int notificationId) async {
    await _ensureInitialized();
    await _plugin.cancel(id: notificationId);
  }

  Future<void> _ensureInitialized() async {
    if (_isInitialized) {
      return;
    }

    timezone_data.initializeTimeZones();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    _isInitialized = true;
  }
}
