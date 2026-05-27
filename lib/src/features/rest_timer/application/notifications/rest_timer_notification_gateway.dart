final class RestTimerNotificationContent {
  const RestTimerNotificationContent({required this.title, required this.body});

  final String title;
  final String body;

  @override
  bool operator ==(Object other) {
    return other is RestTimerNotificationContent &&
        other.title == title &&
        other.body == body;
  }

  @override
  int get hashCode => Object.hash(title, body);
}

final class RestTimerNotificationRequest {
  const RestTimerNotificationRequest({
    required this.notificationId,
    required this.targetAt,
    required this.content,
  });

  final int notificationId;
  final DateTime targetAt;
  final RestTimerNotificationContent content;

  @override
  bool operator ==(Object other) {
    return other is RestTimerNotificationRequest &&
        other.notificationId == notificationId &&
        other.targetAt == targetAt &&
        other.content == content;
  }

  @override
  int get hashCode => Object.hash(notificationId, targetAt, content);
}

enum RestTimerNotificationPermissionStatus { granted, denied }

abstract interface class RestTimerNotificationGateway {
  Future<RestTimerNotificationPermissionStatus> requestPermission();

  Future<void> scheduleRestTimerFinished(RestTimerNotificationRequest request);

  Future<void> cancelRestTimer(int notificationId);
}
