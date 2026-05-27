import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/rest_timer/domain/rest_timer_domain.dart';
import 'package:repforge/src/features/rest_timer/presentation/rest_timer_presentation.dart';

void main() {
  test('formats remaining countdown as minutes and seconds', () {
    final state = RestTimerCountdownState.fromSnapshot(
      RestTimerSnapshot.running(
        duration: RestTimerDuration(const Duration(seconds: 95)),
        startedAt: DateTime.utc(2026, 5, 27, 12),
        currentAt: DateTime.utc(2026, 5, 27, 12, 0, 5),
      ),
    );

    expect(state.status, RestTimerStatus.running);
    expect(state.remaining, const Duration(seconds: 90));
    expect(state.displayText, '01:30');
    expect(state.isVisible, isTrue);
  });

  test('shows zero countdown for finished state', () {
    final state = RestTimerCountdownState.fromSnapshot(
      RestTimerSnapshot.running(
        duration: RestTimerDuration(const Duration(seconds: 30)),
        startedAt: DateTime.utc(2026, 5, 27, 12),
        currentAt: DateTime.utc(2026, 5, 27, 12, 1),
      ),
    );

    expect(state.status, RestTimerStatus.finished);
    expect(state.remaining, Duration.zero);
    expect(state.displayText, '00:00');
    expect(state.isVisible, isTrue);
  });

  test('keeps idle and cancelled states hidden', () {
    final now = DateTime.utc(2026, 5, 27, 12);

    final idle = RestTimerCountdownState.fromSnapshot(
      RestTimerSnapshot.idle(now),
    );
    final cancelled = RestTimerCountdownState.fromSnapshot(
      RestTimerSnapshot.cancelled(now),
    );

    expect(idle.displayText, '00:00');
    expect(idle.isVisible, isFalse);
    expect(cancelled.displayText, '00:00');
    expect(cancelled.isVisible, isFalse);
  });
}
