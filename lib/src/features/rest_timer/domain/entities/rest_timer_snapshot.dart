import '../value_objects/rest_timer_duration.dart';

enum RestTimerStatus { idle, running, finished, cancelled }

final class RestTimerSnapshot {
  const RestTimerSnapshot._({
    required this.status,
    required this.currentAt,
    required this.remaining,
    this.duration,
    this.startedAt,
    this.targetAt,
  });

  factory RestTimerSnapshot.idle(DateTime currentAt) {
    return RestTimerSnapshot._(
      status: RestTimerStatus.idle,
      currentAt: currentAt.toUtc(),
      remaining: Duration.zero,
    );
  }

  factory RestTimerSnapshot.running({
    required RestTimerDuration duration,
    required DateTime startedAt,
    required DateTime currentAt,
  }) {
    final utcStartedAt = startedAt.toUtc();
    final utcCurrentAt = currentAt.toUtc();
    final targetAt = utcStartedAt.add(duration.value);
    final rawRemaining = targetAt.difference(utcCurrentAt);
    final remaining = rawRemaining.isNegative ? Duration.zero : rawRemaining;

    return RestTimerSnapshot._(
      status: remaining == Duration.zero
          ? RestTimerStatus.finished
          : RestTimerStatus.running,
      duration: duration,
      startedAt: utcStartedAt,
      targetAt: targetAt,
      currentAt: utcCurrentAt,
      remaining: remaining,
    );
  }

  factory RestTimerSnapshot.cancelled(DateTime currentAt) {
    return RestTimerSnapshot._(
      status: RestTimerStatus.cancelled,
      currentAt: currentAt.toUtc(),
      remaining: Duration.zero,
    );
  }

  final RestTimerStatus status;
  final RestTimerDuration? duration;
  final DateTime? startedAt;
  final DateTime? targetAt;
  final DateTime currentAt;
  final Duration remaining;

  bool get isVisible {
    return status == RestTimerStatus.running ||
        status == RestTimerStatus.finished;
  }

  @override
  bool operator ==(Object other) {
    return other is RestTimerSnapshot &&
        other.status == status &&
        other.duration == duration &&
        other.startedAt == startedAt &&
        other.targetAt == targetAt &&
        other.currentAt == currentAt &&
        other.remaining == remaining;
  }

  @override
  int get hashCode {
    return Object.hash(
      status,
      duration,
      startedAt,
      targetAt,
      currentAt,
      remaining,
    );
  }
}
