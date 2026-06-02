import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/analytics/domain/analytics_domain.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

void main() {
  group('MuscleId', () {
    test('accepts and trims valid ids', () {
      expect(MuscleId(' chest ').value, 'chest');
      expect(MuscleId('chest'), MuscleId('chest'));
    });

    test('rejects blank ids', () {
      expect(
        () => MuscleId(' '),
        throwsA(
          isA<AnalyticsValidationException>().having(
            (AnalyticsValidationException error) => error.field,
            'field',
            'muscleId',
          ),
        ),
      );
    });
  });

  group('ActivationWeight', () {
    test('accepts bounded values', () {
      expect(ActivationWeight(0).value, 0);
      expect(ActivationWeight(0.65).value, 0.65);
      expect(ActivationWeight(1).value, 1);
    });

    test('rejects invalid weights', () {
      for (final invalid in <num>[
        -0.01,
        1.01,
        double.nan,
        double.infinity,
        double.negativeInfinity,
      ]) {
        expect(
          () => ActivationWeight(invalid),
          throwsA(
            isA<AnalyticsValidationException>().having(
              (AnalyticsValidationException error) => error.field,
              'field',
              'activationWeight',
            ),
          ),
        );
      }
    });
  });

  group('ExerciseActivationProfile', () {
    test('stores one or more muscle activation entries', () {
      final profile = ExerciseActivationProfile.known(
        exerciseSource: ExerciseSource.official,
        exerciseId: 'barbell_bench_press',
        entries: <MuscleActivationEntry>[
          MuscleActivationEntry(
            muscleId: MuscleId('chest'),
            weight: ActivationWeight(1),
          ),
        ],
      );

      expect(profile.state, ExerciseActivationProfileState.known);
      expect(profile.exerciseId, 'barbell_bench_press');
      expect(profile.entries, hasLength(1));
      expect(profile.confidence, MuscleLoadConfidence.estimated);
    });

    test('supports explicitly unavailable activation data', () {
      final profile = ExerciseActivationProfile.unavailable(
        exerciseSource: ExerciseSource.custom,
        exerciseId: 'custom-row',
      );

      expect(profile.state, ExerciseActivationProfileState.unavailable);
      expect(profile.entries, isEmpty);
      expect(profile.confidence, MuscleLoadConfidence.unavailable);
    });

    test('rejects duplicate muscle entries deterministically', () {
      expect(
        () => ExerciseActivationProfile.known(
          exerciseSource: ExerciseSource.official,
          exerciseId: 'barbell_bench_press',
          entries: <MuscleActivationEntry>[
            MuscleActivationEntry(
              muscleId: MuscleId('chest'),
              weight: ActivationWeight(1),
            ),
            MuscleActivationEntry(
              muscleId: MuscleId('chest'),
              weight: ActivationWeight(0.5),
            ),
          ],
        ),
        throwsA(
          isA<AnalyticsValidationException>().having(
            (AnalyticsValidationException error) => error.field,
            'field',
            'exerciseActivationProfile.entries',
          ),
        ),
      );
    });
  });

  group('MuscleLoadEstimator', () {
    test(
      'returns unavailable confidence for an exercise without a profile',
      () {
        const estimator = MuscleLoadEstimator();

        final estimate = estimator.estimate(
          inputs: <MuscleLoadInput>[MuscleLoadInput.fromSet(_set(id: 'set-1'))],
          profiles: const <ExerciseActivationProfile>[],
        );

        expect(estimate.confidence, MuscleLoadConfidence.unavailable);
        expect(estimate.muscleLoads, isEmpty);
        expect(estimate.unknownExercises, hasLength(1));
        expect(estimate.unknownExercises.single.id, 'barbell_bench_press');
      },
    );

    test('calculates estimated load for a weighted set', () {
      const estimator = MuscleLoadEstimator();

      final estimate = estimator.estimate(
        inputs: <MuscleLoadInput>[MuscleLoadInput.fromSet(_set(id: 'set-1'))],
        profiles: <ExerciseActivationProfile>[_benchPressProfile()],
      );

      expect(estimate.confidence, MuscleLoadConfidence.estimated);
      expect(estimate.loadFor(MuscleId('chest'))?.estimatedLoadKg, 500);
      expect(estimate.loadFor(MuscleId('triceps'))?.estimatedLoadKg, 300);
    });

    test('sums multiple sets for the same exercise', () {
      const estimator = MuscleLoadEstimator();

      final estimate = estimator.estimate(
        inputs: <MuscleLoadInput>[
          MuscleLoadInput.fromSet(_set(id: 'set-1')),
          MuscleLoadInput.fromSet(
            _set(id: 'set-2', loadKg: 80, repetitions: 10),
          ),
        ],
        profiles: <ExerciseActivationProfile>[_benchPressProfile()],
      );

      expect(estimate.loadFor(MuscleId('chest'))?.estimatedLoadKg, 1300);
      expect(estimate.loadFor(MuscleId('triceps'))?.estimatedLoadKg, 780);
      expect(estimate.totalKnownLoadKg, 2600);
    });

    test('allocates proportional estimated load across multiple muscles', () {
      const estimator = MuscleLoadEstimator();

      final estimate = estimator.estimate(
        inputs: <MuscleLoadInput>[
          MuscleLoadInput.fromSet(
            _set(id: 'set-1', loadKg: 50, repetitions: 10),
          ),
        ],
        profiles: <ExerciseActivationProfile>[_benchPressProfile()],
      );

      expect(estimate.muscleLoads, hasLength(3));
      expect(estimate.loadFor(MuscleId('chest'))?.estimatedLoadKg, 500);
      expect(estimate.loadFor(MuscleId('triceps'))?.estimatedLoadKg, 300);
      expect(
        estimate.loadFor(MuscleId('front_deltoids'))?.estimatedLoadKg,
        200,
      );
    });

    test('handles zero-load sets deterministically', () {
      const estimator = MuscleLoadEstimator();

      final estimate = estimator.estimate(
        inputs: <MuscleLoadInput>[
          MuscleLoadInput.fromSet(
            _set(id: 'set-1', loadKg: 0, repetitions: 12),
          ),
        ],
        profiles: <ExerciseActivationProfile>[_benchPressProfile()],
      );

      expect(estimate.confidence, MuscleLoadConfidence.estimated);
      expect(estimate.loadFor(MuscleId('chest'))?.estimatedLoadKg, 0);
      expect(estimate.totalKnownLoadKg, 0);
    });

    test('marks incomplete load inputs as conservative estimates', () {
      const estimator = MuscleLoadEstimator();

      final estimate = estimator.estimate(
        inputs: <MuscleLoadInput>[
          MuscleLoadInput.fromSet(
            _set(id: 'set-1', loadKg: 0, repetitions: 8),
            loadState: MuscleLoadInputLoadState.incomplete,
          ),
        ],
        profiles: <ExerciseActivationProfile>[_benchPressProfile()],
      );

      expect(estimate.confidence, MuscleLoadConfidence.conservative);
      expect(estimate.loadFor(MuscleId('chest'))?.estimatedLoadKg, 0);
    });

    test('existing workout set history is not mutated', () {
      const estimator = MuscleLoadEstimator();
      final original = <WorkoutSet>[
        _set(id: 'set-1'),
        _set(id: 'set-2', loadKg: 80, repetitions: 10),
      ];
      final snapshot = List<WorkoutSet>.of(original);

      estimator.estimate(
        inputs: original.map(MuscleLoadInput.fromSet),
        profiles: <ExerciseActivationProfile>[_benchPressProfile()],
      );

      expect(original, snapshot);
    });

    test('workout set zero repetitions remain rejected upstream', () {
      expect(
        () => Repetitions(0),
        throwsA(isA<TrainingLogValidationException>()),
      );
    });
  });
}

ExerciseActivationProfile _benchPressProfile() {
  return ExerciseActivationProfile.known(
    exerciseSource: ExerciseSource.official,
    exerciseId: 'barbell_bench_press',
    entries: <MuscleActivationEntry>[
      MuscleActivationEntry(
        muscleId: MuscleId('chest'),
        weight: ActivationWeight(1),
      ),
      MuscleActivationEntry(
        muscleId: MuscleId('triceps'),
        weight: ActivationWeight(0.6),
      ),
      MuscleActivationEntry(
        muscleId: MuscleId('front_deltoids'),
        weight: ActivationWeight(0.4),
      ),
    ],
  );
}

WorkoutSet _set({required String id, num loadKg = 100, int repetitions = 5}) {
  return WorkoutSet(
    id: WorkoutSetId(id),
    exerciseRef: ExerciseRef.official(
      id: OfficialExerciseId('barbell_bench_press'),
      displayNameSnapshot: 'Barbell Bench Press',
      catalogVersionSnapshot: '2026.06.0',
    ),
    repetitions: Repetitions(repetitions),
    load: LoadKg(loadKg),
    performedAt: PerformedAt(DateTime.utc(2026, 6, 2, 12)),
  );
}
