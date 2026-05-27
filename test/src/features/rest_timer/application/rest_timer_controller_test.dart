import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/rest_timer/application/rest_timer_application.dart';
import 'package:repforge/src/features/rest_timer/domain/rest_timer_domain.dart';

void main() {
  late _FakeTimeProvider clock;
  late RestTimerController controller;

  setUp(() {
    clock = _FakeTimeProvider(DateTime.utc(2026, 5, 27, 12));
    controller = RestTimerController(timeProvider: clock);
  });

  test('starts idle with deterministic current time', () {
    expect(controller.snapshot.status, RestTimerStatus.idle);
    expect(controller.snapshot.currentAt, DateTime.utc(2026, 5, 27, 12));
  });

  test('start creates a running countdown from the injected clock', () {
    final snapshot = controller.start(
      RestTimerDuration(const Duration(seconds: 120)),
    );

    expect(snapshot.status, RestTimerStatus.running);
    expect(snapshot.startedAt, DateTime.utc(2026, 5, 27, 12));
    expect(snapshot.targetAt, DateTime.utc(2026, 5, 27, 12, 2));
    expect(snapshot.remaining, const Duration(seconds: 120));
  });

  test('tick recomputes remaining time without real waiting', () {
    controller.start(RestTimerDuration(const Duration(seconds: 120)));

    clock.advance(const Duration(seconds: 45));
    final snapshot = controller.tick();

    expect(snapshot.status, RestTimerStatus.running);
    expect(snapshot.currentAt, DateTime.utc(2026, 5, 27, 12, 0, 45));
    expect(snapshot.remaining, const Duration(seconds: 75));
  });

  test('tick detects finished state and avoids negative remaining time', () {
    controller.start(RestTimerDuration(const Duration(seconds: 60)));

    clock.advance(const Duration(seconds: 75));
    final snapshot = controller.tick();

    expect(snapshot.status, RestTimerStatus.finished);
    expect(snapshot.remaining, Duration.zero);
  });

  test('cancel clears active countdown state', () {
    controller.start(RestTimerDuration(const Duration(seconds: 60)));
    clock.advance(const Duration(seconds: 10));

    final snapshot = controller.cancel();

    expect(snapshot.status, RestTimerStatus.cancelled);
    expect(snapshot.remaining, Duration.zero);
    expect(snapshot.startedAt, isNull);
    expect(snapshot.targetAt, isNull);
  });

  test('reset returns to idle with current clock time', () {
    controller.start(RestTimerDuration(const Duration(seconds: 60)));
    clock.advance(const Duration(seconds: 10));

    final snapshot = controller.reset();

    expect(snapshot.status, RestTimerStatus.idle);
    expect(snapshot.currentAt, DateTime.utc(2026, 5, 27, 12, 0, 10));
    expect(snapshot.remaining, Duration.zero);
  });

  test('tick leaves idle and cancelled states stable', () {
    expect(controller.tick().status, RestTimerStatus.idle);

    controller.start(RestTimerDuration(const Duration(seconds: 60)));
    controller.cancel();
    clock.advance(const Duration(seconds: 10));

    expect(controller.tick().status, RestTimerStatus.cancelled);
  });
}

final class _FakeTimeProvider implements TimeProvider {
  _FakeTimeProvider(this._now);

  DateTime _now;

  void advance(Duration duration) {
    _now = _now.add(duration);
  }

  @override
  DateTime now() => _now;
}
