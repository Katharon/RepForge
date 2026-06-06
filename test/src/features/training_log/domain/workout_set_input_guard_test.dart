import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

void main() {
  const guard = WorkoutSetInputGuard();

  test('normal set input has no warning', () {
    final result = guard.evaluate(
      WorkoutSetInputGuardInput(repetitions: Repetitions(8), load: LoadKg(100)),
    );

    expect(result.hasWarning, isFalse);
    expect(result.reasons, isEmpty);
  });

  test('high repetitions trigger a soft warning', () {
    final result = guard.evaluate(
      WorkoutSetInputGuardInput(
        repetitions: Repetitions(101),
        load: LoadKg(40),
      ),
    );

    expect(result.hasWarning, isTrue);
    expect(result.contains(WorkoutSetInputWarningReason.highRepetitions), true);
  });

  test('high load triggers a soft warning', () {
    final result = guard.evaluate(
      WorkoutSetInputGuardInput(repetitions: Repetitions(2), load: LoadKg(501)),
    );

    expect(result.hasWarning, isTrue);
    expect(result.contains(WorkoutSetInputWarningReason.highLoad), true);
  });

  test('high single-set volume triggers a soft warning', () {
    final result = guard.evaluate(
      WorkoutSetInputGuardInput(
        repetitions: Repetitions(80),
        load: LoadKg(251),
      ),
    );

    expect(result.hasWarning, isTrue);
    expect(result.contains(WorkoutSetInputWarningReason.highSetVolume), true);
  });

  test('repetition and load thresholds are exclusive', () {
    final result = guard.evaluate(
      WorkoutSetInputGuardInput(
        repetitions: Repetitions(100),
        load: LoadKg(500),
      ),
    );

    expect(result.hasWarning, isTrue);
    expect(
      result.contains(WorkoutSetInputWarningReason.highRepetitions),
      isFalse,
    );
    expect(result.contains(WorkoutSetInputWarningReason.highLoad), isFalse);
    expect(result.contains(WorkoutSetInputWarningReason.highSetVolume), isTrue);
  });

  test('daily volume warning is display-only and threshold based', () {
    expect(guard.isDailyVolumeUnusuallyHigh(100000), isFalse);
    expect(guard.isDailyVolumeUnusuallyHigh(100000.1), isTrue);
  });
}
