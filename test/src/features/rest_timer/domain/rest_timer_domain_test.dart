import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/rest_timer/domain/rest_timer_domain.dart';

void main() {
  group('RestTimerDuration', () {
    test('accepts positive durations', () {
      final duration = RestTimerDuration(const Duration(seconds: 90));

      expect(duration.value, const Duration(seconds: 90));
      expect(duration.inSeconds, 90);
    });

    test('rejects zero and negative durations', () {
      expect(
        () => RestTimerDuration(Duration.zero),
        throwsA(
          isA<RestTimerValidationException>().having(
            (RestTimerValidationException error) => error.field,
            'field',
            'duration',
          ),
        ),
      );
      expect(
        () => RestTimerDuration(const Duration(seconds: -1)),
        throwsA(isA<RestTimerValidationException>()),
      );
    });
  });

  group('RestTimerSnapshot', () {
    test('idle state has no remaining time and is not visible', () {
      final now = DateTime.utc(2026, 5, 27, 12);

      final snapshot = RestTimerSnapshot.idle(now);

      expect(snapshot.status, RestTimerStatus.idle);
      expect(snapshot.currentAt, now);
      expect(snapshot.remaining, Duration.zero);
      expect(snapshot.startedAt, isNull);
      expect(snapshot.targetAt, isNull);
      expect(snapshot.isVisible, isFalse);
    });

    test('running state stores startedAt, targetAt, and remaining time', () {
      final startedAt = DateTime.utc(2026, 5, 27, 12);
      final currentAt = DateTime.utc(2026, 5, 27, 12, 1);

      final snapshot = RestTimerSnapshot.running(
        duration: RestTimerDuration(const Duration(seconds: 90)),
        startedAt: startedAt,
        currentAt: currentAt,
      );

      expect(snapshot.status, RestTimerStatus.running);
      expect(snapshot.startedAt, startedAt);
      expect(snapshot.targetAt, DateTime.utc(2026, 5, 27, 12, 1, 30));
      expect(snapshot.currentAt, currentAt);
      expect(snapshot.remaining, const Duration(seconds: 30));
      expect(snapshot.isVisible, isTrue);
    });

    test('finished state clamps remaining time to zero', () {
      final startedAt = DateTime.utc(2026, 5, 27, 12);

      final snapshot = RestTimerSnapshot.running(
        duration: RestTimerDuration(const Duration(seconds: 90)),
        startedAt: startedAt,
        currentAt: DateTime.utc(2026, 5, 27, 12, 2),
      );

      expect(snapshot.status, RestTimerStatus.finished);
      expect(snapshot.remaining, Duration.zero);
      expect(snapshot.isVisible, isTrue);
    });

    test('cancelled state has no remaining time and is not visible', () {
      final now = DateTime.utc(2026, 5, 27, 12);

      final snapshot = RestTimerSnapshot.cancelled(now);

      expect(snapshot.status, RestTimerStatus.cancelled);
      expect(snapshot.remaining, Duration.zero);
      expect(snapshot.isVisible, isFalse);
    });
  });
}
