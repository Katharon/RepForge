import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/recovery/domain/recovery_domain.dart';

void main() {
  group('Recovery readiness domain', () {
    test('valid check-in stores bounded local feedback', () {
      final checkIn = ReadinessCheckIn(
        id: ReadinessCheckInId('check-in-1'),
        checkedInAt: DateTime.utc(2026, 6, 2, 8),
        soreness: SorenessRating.moderate(),
        sleepQuality: SleepQualityRating(4),
        energy: EnergyRating(4),
        stress: StressRating(2),
        motivation: MotivationRating(4),
      );

      expect(checkIn.id.value, 'check-in-1');
      expect(checkIn.soreness.value, 2);
      expect(checkIn.checkedInAt, DateTime.utc(2026, 6, 2, 8));
    });

    test('invalid rating bounds are rejected deterministically', () {
      expect(
        () => SorenessRating(-1),
        throwsA(isA<RecoveryValidationException>()),
      );
      expect(
        () => SorenessRating(5),
        throwsA(isA<RecoveryValidationException>()),
      );
      expect(
        () => SleepQualityRating(0),
        throwsA(isA<RecoveryValidationException>()),
      );
      expect(
        () => EnergyRating(6),
        throwsA(isA<RecoveryValidationException>()),
      );
      expect(
        () => StressRating(double.nan),
        throwsA(isA<RecoveryValidationException>()),
      );
      expect(
        () => MotivationRating(double.infinity),
        throwsA(isA<RecoveryValidationException>()),
      );
    });

    test('high soreness lowers readiness but never blocks logging', () {
      const calculator = ReadinessScoreCalculator();
      final fresh = calculator.calculate(
        ReadinessCheckIn(
          id: ReadinessCheckInId('fresh'),
          checkedInAt: DateTime.utc(2026, 6, 2, 8),
          soreness: SorenessRating.none(),
          sleepQuality: SleepQualityRating(5),
          energy: EnergyRating(5),
          stress: StressRating(1),
          motivation: MotivationRating(5),
        ),
      );
      final sore = calculator.calculate(
        ReadinessCheckIn(
          id: ReadinessCheckInId('sore'),
          checkedInAt: DateTime.utc(2026, 6, 2, 8),
          soreness: SorenessRating.high(),
          sleepQuality: SleepQualityRating(5),
          energy: EnergyRating(5),
          stress: StressRating(1),
          motivation: MotivationRating(5),
        ),
      );

      expect(sore.score.value, lessThan(fresh.score.value));
      expect(sore.allowsWorkoutLogging, isTrue);
      expect(sore.reasons, contains(ReadinessReason.highSoreness));
    });

    test('poor sleep and low energy lower readiness', () {
      const calculator = ReadinessScoreCalculator();
      final good = calculator.calculate(
        _checkIn(id: 'good', sleep: 5, energy: 5, stress: 1, motivation: 5),
      );
      final tired = calculator.calculate(
        _checkIn(id: 'tired', sleep: 1, energy: 1, stress: 1, motivation: 5),
      );

      expect(tired.score.value, lessThan(good.score.value));
      expect(tired.reasons, contains(ReadinessReason.poorSleep));
      expect(tired.reasons, contains(ReadinessReason.lowEnergy));
    });

    test('readiness score and level mapping are deterministic', () {
      const calculator = ReadinessScoreCalculator();

      final result = calculator.calculate(
        _checkIn(
          id: 'deterministic',
          sleep: 4,
          energy: 3,
          stress: 3,
          motivation: 4,
        ),
      );

      expect(result.score, ReadinessScore(70));
      expect(result.level, ReadinessLevel.medium);
      expect(result.confidence, ReadinessConfidence.reported);
      expect(
        calculator.calculate(
          _checkIn(
            id: 'deterministic',
            sleep: 4,
            energy: 3,
            stress: 3,
            motivation: 4,
          ),
        ),
        result,
      );
    });

    test('empty read model is explicit and does not block logging', () {
      final model = ReadinessReadModel.empty(forDate: DateTime.utc(2026, 6, 2));

      expect(model.status, ReadinessReadModelStatus.empty);
      expect(model.score, isNull);
      expect(model.level, isNull);
      expect(model.confidence, ReadinessConfidence.unavailable);
      expect(model.allowsWorkoutLogging, isTrue);
    });

    test('API names avoid diagnosis and blocking wording', () {
      final forbidden = RegExp('diagnos|injury|medical|block|prevent|mustNot');

      for (final level in ReadinessLevel.values) {
        expect(level.name, isNot(matches(forbidden)));
      }
      for (final reason in ReadinessReason.values) {
        expect(reason.name, isNot(matches(forbidden)));
      }
    });
  });
}

ReadinessCheckIn _checkIn({
  required String id,
  required int sleep,
  required int energy,
  required int stress,
  required int motivation,
}) {
  return ReadinessCheckIn(
    id: ReadinessCheckInId(id),
    checkedInAt: DateTime.utc(2026, 6, 2, 8),
    soreness: SorenessRating.light(),
    sleepQuality: SleepQualityRating(sleep),
    energy: EnergyRating(energy),
    stress: StressRating(stress),
    motivation: MotivationRating(motivation),
  );
}
