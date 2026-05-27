import '../domain/rest_timer_domain.dart';

final class RestTimerController {
  RestTimerController({required TimeProvider timeProvider})
    : _timeProvider = timeProvider,
      _snapshot = RestTimerSnapshot.idle(timeProvider.now());

  final TimeProvider _timeProvider;
  RestTimerSnapshot _snapshot;

  RestTimerSnapshot get snapshot => _snapshot;

  RestTimerSnapshot start(RestTimerDuration duration) {
    final now = _timeProvider.now();
    _snapshot = RestTimerSnapshot.running(
      duration: duration,
      startedAt: now,
      currentAt: now,
    );
    return _snapshot;
  }

  RestTimerSnapshot tick() {
    final duration = _snapshot.duration;
    final startedAt = _snapshot.startedAt;
    if (duration == null || startedAt == null) {
      return _snapshot;
    }

    _snapshot = RestTimerSnapshot.running(
      duration: duration,
      startedAt: startedAt,
      currentAt: _timeProvider.now(),
    );
    return _snapshot;
  }

  RestTimerSnapshot cancel() {
    _snapshot = RestTimerSnapshot.cancelled(_timeProvider.now());
    return _snapshot;
  }

  RestTimerSnapshot reset() {
    _snapshot = RestTimerSnapshot.idle(_timeProvider.now());
    return _snapshot;
  }
}
