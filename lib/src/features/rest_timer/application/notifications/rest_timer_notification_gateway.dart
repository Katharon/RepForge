final class RestTimerNotificationContent {
  const RestTimerNotificationContent({required this.title, required this.body});

  static const RestTimerNotificationContent genericFinished =
      RestTimerNotificationContent(
        title: 'Rest timer finished',
        body: 'Your rest timer is complete.',
      );

  final String title;
  final String body;

  RestTimerNotificationContent get privacySafe {
    if (_looksWorkoutSpecific(title) || _looksWorkoutSpecific(body)) {
      return genericFinished;
    }
    return this;
  }

  @override
  bool operator ==(Object other) {
    return other is RestTimerNotificationContent &&
        other.title == title &&
        other.body == body;
  }

  @override
  int get hashCode => Object.hash(title, body);

  static bool _looksWorkoutSpecific(String value) {
    final normalized = value.toLowerCase();
    if (RegExp(r'\b\d+(\.\d+)?\s?(kg|lb|lbs|reps?)\b').hasMatch(normalized)) {
      return true;
    }

    const workoutTerms = <String>{
      'bench',
      'squat',
      'deadlift',
      'press',
      'row',
      'curl',
      'failure',
      'pain',
      'soreness',
      'comment',
      'set note',
      'personal record',
    };
    return workoutTerms.any(normalized.contains);
  }
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
