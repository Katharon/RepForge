import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/analytics/domain/analytics_domain.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

void main() {
  group('FormulaIdentity', () {
    test('compares by name and version', () {
      expect(
        const FormulaIdentity(name: 'epley_one_rep_max', version: 1),
        const FormulaIdentity(name: 'epley_one_rep_max', version: 1),
      );
      expect(
        const FormulaIdentity(name: 'epley_one_rep_max', version: 1),
        isNot(const FormulaIdentity(name: 'epley_one_rep_max', version: 2)),
      );
    });
  });

  group('EpleyOneRepMaxFormula', () {
    test('exposes explicit formula identity metadata', () {
      const formula = EpleyOneRepMaxFormula();

      expect(
        formula.identity,
        const FormulaIdentity(name: 'epley_one_rep_max', version: 1),
      );
    });

    test('calculates common examples', () {
      const formula = EpleyOneRepMaxFormula();

      final fiveRepEstimate = formula.estimate(
        load: LoadKg(100),
        repetitions: Repetitions(5),
      );
      final tenRepEstimate = formula.estimate(
        load: LoadKg(80),
        repetitions: Repetitions(10),
      );

      expect(fiveRepEstimate.valueKg, closeTo(116.6666667, 0.000001));
      expect(tenRepEstimate.valueKg, closeTo(106.6666667, 0.000001));
      expect(fiveRepEstimate.formulaIdentity, formula.identity);
    });

    test('handles zero-load sets deterministically', () {
      const formula = EpleyOneRepMaxFormula();

      final estimate = formula.estimate(
        load: LoadKg(0),
        repetitions: Repetitions(12),
      );

      expect(estimate.valueKg, 0);
      expect(estimate.formulaIdentity, formula.identity);
    });
  });

  group('WorkoutSetAnalyticsFormulaService', () {
    test('returns an empty-safe summary for no sets', () {
      const service = WorkoutSetAnalyticsFormulaService();

      final summary = service.summarize(const <WorkoutSet>[]);

      expect(summary.setCount, 0);
      expect(summary.totalRepetitions, 0);
      expect(summary.totalVolumeKg, 0);
      expect(summary.averageKgPerRep, isNull);
      expect(summary.bestSetLoadKg, isNull);
      expect(summary.bestEstimatedOneRepMax, isNull);
      expect(
        summary.oneRepMaxFormulaIdentity,
        const FormulaIdentity(name: 'epley_one_rep_max', version: 1),
      );
    });

    test('summarizes a single set', () {
      const service = WorkoutSetAnalyticsFormulaService();

      final summary = service.summarize(<WorkoutSet>[
        _set(id: 'set-1', loadKg: 100, repetitions: 5),
      ]);

      expect(summary.setCount, 1);
      expect(summary.totalRepetitions, 5);
      expect(summary.totalVolumeKg, 500);
      expect(summary.averageKgPerRep, 100);
      expect(summary.bestSetLoadKg, 100);
      expect(
        summary.bestEstimatedOneRepMax?.valueKg,
        closeTo(116.6666667, 1e-6),
      );
    });

    test('summarizes multiple sets with decimal loads', () {
      const service = WorkoutSetAnalyticsFormulaService();

      final summary = service.summarize(<WorkoutSet>[
        _set(id: 'set-1', loadKg: 82.5, repetitions: 8),
        _set(id: 'set-2', loadKg: 90, repetitions: 6),
        _set(id: 'set-3', loadKg: 95.5, repetitions: 3),
      ]);

      expect(summary.setCount, 3);
      expect(summary.totalRepetitions, 17);
      expect(summary.totalVolumeKg, closeTo(1486.5, 1e-6));
      expect(summary.averageKgPerRep, closeTo(87.44117647, 1e-6));
      expect(summary.bestSetLoadKg, 95.5);
      expect(summary.bestEstimatedOneRepMax?.valueKg, closeTo(108, 1e-6));
    });

    test('handles zero-load sets with repetitions', () {
      const service = WorkoutSetAnalyticsFormulaService();

      final summary = service.summarize(<WorkoutSet>[
        _set(id: 'set-1', loadKg: 0, repetitions: 10),
        _set(id: 'set-2', loadKg: 0, repetitions: 12),
      ]);

      expect(summary.setCount, 2);
      expect(summary.totalRepetitions, 22);
      expect(summary.totalVolumeKg, 0);
      expect(summary.averageKgPerRep, 0);
      expect(summary.bestSetLoadKg, 0);
      expect(summary.bestEstimatedOneRepMax?.valueKg, 0);
    });

    test('does not mutate input WorkoutSet values', () {
      const service = WorkoutSetAnalyticsFormulaService();
      final original = <WorkoutSet>[
        _set(id: 'set-1', loadKg: 100, repetitions: 5),
        _set(id: 'set-2', loadKg: 80, repetitions: 10),
      ];
      final snapshot = List<WorkoutSet>.of(original);

      service.summarize(original);

      expect(original, snapshot);
    });
  });

  group('PeriodComparison', () {
    test('handles an absent previous value', () {
      final comparison = PeriodComparison.fromValues(current: 100);

      expect(comparison.current, 100);
      expect(comparison.previous, isNull);
      expect(comparison.absoluteDelta, isNull);
      expect(comparison.percentChange, isNull);
      expect(comparison.hasPrevious, isFalse);
    });

    test('handles a zero previous value explicitly', () {
      final comparison = PeriodComparison.fromValues(current: 100, previous: 0);

      expect(comparison.current, 100);
      expect(comparison.previous, 0);
      expect(comparison.absoluteDelta, 100);
      expect(comparison.percentChange, isNull);
      expect(comparison.hasPrevious, isTrue);
    });

    test('calculates equal, positive, and negative changes', () {
      final equal = PeriodComparison.fromValues(current: 100, previous: 100);
      final positive = PeriodComparison.fromValues(current: 125, previous: 100);
      final negative = PeriodComparison.fromValues(current: 75, previous: 100);

      expect(equal.absoluteDelta, 0);
      expect(equal.percentChange, 0);
      expect(positive.absoluteDelta, 25);
      expect(positive.percentChange, 0.25);
      expect(negative.absoluteDelta, -25);
      expect(negative.percentChange, -0.25);
    });
  });
}

WorkoutSet _set({
  required String id,
  required num loadKg,
  required int repetitions,
}) {
  return WorkoutSet(
    id: WorkoutSetId(id),
    exerciseRef: ExerciseRef.official(
      id: OfficialExerciseId('barbell-bench-press'),
      displayNameSnapshot: 'Barbell Bench Press',
      catalogVersionSnapshot: '2026.05.0',
    ),
    repetitions: Repetitions(repetitions),
    load: LoadKg(loadKg),
    performedAt: PerformedAt(DateTime.utc(2026, 5, 27, 12)),
  );
}
