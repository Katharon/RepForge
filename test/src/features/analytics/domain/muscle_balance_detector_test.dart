import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/analytics/domain/analytics_domain.dart';
import 'package:repforge/src/features/exercise_catalog/domain/exercise_catalog_domain.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

void main() {
  group('MuscleBalanceDetector', () {
    test('empty history returns insufficient data', () {
      const detector = MuscleBalanceDetector();

      final assessment = detector.assess(
        MuscleBalanceInput(
          muscleLoadEstimate: MuscleLoadEstimate(
            muscleLoads: const <MuscleLoad>[],
            unknownExercises: const <ExerciseRef>[],
            confidence: MuscleLoadConfidence.estimated,
          ),
          loggedSetCount: 0,
        ),
      );

      expect(assessment.status, MuscleBalanceAssessmentStatus.insufficientData);
      expect(assessment.confidence, MuscleBalanceConfidence.insufficient);
      expect(assessment.signals, hasLength(1));
      expect(
        assessment.signals.single.type,
        MuscleBalanceSignalType.insufficientData,
      );
      expect(
        assessment.signals.single.evidence.code,
        'muscle_balance.insufficient_data',
      );
    });

    test('too little data returns low-confidence insufficient state', () {
      const detector = MuscleBalanceDetector();

      final assessment = detector.assess(
        MuscleBalanceInput(
          muscleLoadEstimate: _estimate(chest: 100, lats: 100, quadriceps: 100),
          loggedSetCount: 2,
        ),
      );

      expect(assessment.status, MuscleBalanceAssessmentStatus.insufficientData);
      expect(assessment.confidence, MuscleBalanceConfidence.insufficient);
      expect(
        assessment.signals.single.evidence.code,
        'muscle_balance.insufficient_data',
      );
    });

    test('balanced full-body history returns balanced signal', () {
      const detector = MuscleBalanceDetector();

      final assessment = detector.assess(
        MuscleBalanceInput(
          muscleLoadEstimate: _estimate(
            chest: 500,
            triceps: 200,
            frontDeltoids: 150,
            lats: 450,
            upperBack: 250,
            rearDeltoids: 120,
            quadriceps: 500,
            hamstrings: 250,
            glutes: 350,
          ),
          loggedSetCount: 10,
          movementPatternCoverage: MovementPatternCoverage.known(
            patterns: <MovementPattern>[
              MovementPattern('horizontal_push'),
              MovementPattern('horizontal_pull'),
              MovementPattern('squat'),
              MovementPattern('hinge'),
            ],
          ),
        ),
      );

      expect(assessment.status, MuscleBalanceAssessmentStatus.balanced);
      expect(assessment.confidence, MuscleBalanceConfidence.high);
      expect(assessment.signals, hasLength(1));
      expect(assessment.signals.single.type, MuscleBalanceSignalType.balanced);
      expect(
        assessment.signals.single.evidence.code,
        'muscle_balance.balanced',
      );
    });

    test('push-heavy history produces explainable push-heavy signal', () {
      const detector = MuscleBalanceDetector();

      final assessment = detector.assess(
        MuscleBalanceInput(
          muscleLoadEstimate: _estimate(
            chest: 1200,
            triceps: 400,
            frontDeltoids: 250,
            lats: 300,
            upperBack: 150,
            quadriceps: 500,
            glutes: 250,
            hamstrings: 150,
          ),
          loggedSetCount: 8,
        ),
      );

      final signal = assessment.signalOfType(MuscleBalanceSignalType.pushHeavy);
      expect(assessment.status, MuscleBalanceAssessmentStatus.imbalanced);
      expect(signal, isNotNull);
      expect(signal?.severity, MuscleBalanceSeverity.watch);
      expect(signal?.evidence.code, 'muscle_balance.push_heavy');
      expect(signal?.evidence.affectedMuscles, contains(MuscleId('chest')));
      expect(signal?.evidence.actualValue, greaterThan(1.6));
    });

    test('pull-neglect history produces explainable back signal', () {
      const detector = MuscleBalanceDetector();

      final assessment = detector.assess(
        MuscleBalanceInput(
          muscleLoadEstimate: _estimate(
            chest: 600,
            triceps: 250,
            quadriceps: 450,
            hamstrings: 200,
            glutes: 300,
          ),
          loggedSetCount: 7,
        ),
      );

      final signal = assessment.signalOfType(
        MuscleBalanceSignalType.pullNeglect,
      );
      expect(signal, isNotNull);
      expect(signal?.severity, MuscleBalanceSeverity.attention);
      expect(signal?.evidence.code, 'muscle_balance.pull_neglect');
      expect(signal?.evidence.affectedMuscles, contains(MuscleId('lats')));
    });

    test('leg-neglect history produces explainable lower-body signal', () {
      const detector = MuscleBalanceDetector();

      final assessment = detector.assess(
        MuscleBalanceInput(
          muscleLoadEstimate: _estimate(
            chest: 700,
            triceps: 250,
            lats: 650,
            upperBack: 250,
            rearDeltoids: 100,
            quadriceps: 80,
          ),
          loggedSetCount: 7,
        ),
      );

      final signal = assessment.signalOfType(
        MuscleBalanceSignalType.legNeglect,
      );
      expect(signal, isNotNull);
      expect(signal?.evidence.code, 'muscle_balance.leg_neglect');
      expect(
        signal?.evidence.affectedMuscles,
        contains(MuscleId('quadriceps')),
      );
      expect(signal?.evidence.actualValue, lessThan(0.25));
    });

    test('upper-focus profile tolerates higher upper-body emphasis', () {
      const detector = MuscleBalanceDetector();

      final assessment = detector.assess(
        MuscleBalanceInput(
          focusProfile: FocusProfile.upperBodyFocus,
          muscleLoadEstimate: _estimate(
            chest: 800,
            triceps: 300,
            lats: 700,
            upperBack: 300,
            rearDeltoids: 150,
            quadriceps: 180,
            glutes: 120,
          ),
          loggedSetCount: 9,
        ),
      );

      expect(assessment.status, MuscleBalanceAssessmentStatus.balanced);
      expect(
        assessment.signalOfType(MuscleBalanceSignalType.legNeglect),
        isNull,
      );
      expect(assessment.targetRange.focusProfile, FocusProfile.upperBodyFocus);
    });

    test('lower-focus profile expects stronger lower-body coverage', () {
      const detector = MuscleBalanceDetector();

      final assessment = detector.assess(
        MuscleBalanceInput(
          focusProfile: FocusProfile.lowerBodyGluteFocus,
          muscleLoadEstimate: _estimate(
            chest: 500,
            triceps: 150,
            lats: 500,
            upperBack: 200,
            quadriceps: 350,
            hamstrings: 150,
            glutes: 150,
          ),
          loggedSetCount: 9,
        ),
      );

      final signal = assessment.signalOfType(
        MuscleBalanceSignalType.lowerBodyUnderTarget,
      );
      expect(signal, isNotNull);
      expect(signal?.evidence.code, 'muscle_balance.lower_body_under_target');
      expect(signal?.evidence.targetMinimum, 0.4);
    });

    test('general fitness defaults use balanced target ranges', () {
      const detector = MuscleBalanceDetector();

      final assessment = detector.assess(
        MuscleBalanceInput(
          muscleLoadEstimate: _estimate(
            chest: 400,
            lats: 400,
            quadriceps: 400,
            hamstrings: 200,
          ),
          loggedSetCount: 6,
        ),
      );

      expect(assessment.targetRange.focusProfile, FocusProfile.balanced);
      expect(assessment.targetRange.lowerBodyShareMinimum, 0.25);
      expect(assessment.targetRange.pushPullRatioMaximum, 1.6);
    });

    test('unknown activation evidence lowers confidence and is reported', () {
      const detector = MuscleBalanceDetector();

      final estimate = MuscleLoadEstimate(
        muscleLoads: <MuscleLoad>[
          MuscleLoad(muscleId: MuscleId('chest'), estimatedLoadKg: 500),
          MuscleLoad(muscleId: MuscleId('lats'), estimatedLoadKg: 450),
          MuscleLoad(muscleId: MuscleId('quadriceps'), estimatedLoadKg: 450),
        ],
        unknownExercises: <ExerciseRef>[
          ExerciseRef.custom(
            id: CustomExerciseId('custom-press'),
            displayNameSnapshot: 'Custom Press',
          ),
        ],
        confidence: MuscleLoadConfidence.unavailable,
      );

      final assessment = detector.assess(
        MuscleBalanceInput(muscleLoadEstimate: estimate, loggedSetCount: 6),
      );

      final signal = assessment.signalOfType(
        MuscleBalanceSignalType.incompleteData,
      );
      expect(assessment.confidence, MuscleBalanceConfidence.low);
      expect(signal, isNotNull);
      expect(
        signal?.evidence.code,
        'muscle_balance.incomplete_activation_data',
      );
      expect(signal?.evidence.unknownExerciseCount, 1);
    });

    test('missing movement-pattern coverage is reported deterministically', () {
      const detector = MuscleBalanceDetector();

      final assessment = detector.assess(
        MuscleBalanceInput(
          muscleLoadEstimate: _estimate(
            chest: 400,
            lats: 400,
            quadriceps: 400,
            hamstrings: 200,
          ),
          loggedSetCount: 8,
          movementPatternCoverage: MovementPatternCoverage.known(
            patterns: <MovementPattern>[
              MovementPattern('horizontal_push'),
              MovementPattern('horizontal_pull'),
            ],
          ),
        ),
      );

      final signal = assessment.signalOfType(
        MuscleBalanceSignalType.movementPatternGap,
      );
      expect(signal, isNotNull);
      expect(signal?.evidence.code, 'muscle_balance.movement_pattern_gap');
      expect(
        signal?.evidence.affectedMovementPatterns,
        contains(MovementPattern('squat')),
      );
      expect(
        signal?.evidence.affectedMovementPatterns,
        contains(MovementPattern('hinge')),
      );
    });

    test('API names avoid diagnosis and shaming wording', () {
      final forbidden = RegExp('diagnos|shame|injury|medical');

      for (final type in MuscleBalanceSignalType.values) {
        expect(type.name, isNot(matches(forbidden)));
      }
      for (final severity in MuscleBalanceSeverity.values) {
        expect(severity.name, isNot(matches(forbidden)));
      }
    });

    test('does not mutate supplied muscle-load estimates', () {
      const detector = MuscleBalanceDetector();
      final estimate = _estimate(chest: 400, lats: 400, quadriceps: 400);
      final before = MuscleLoadEstimate(
        muscleLoads: estimate.muscleLoads,
        unknownExercises: estimate.unknownExercises,
        confidence: estimate.confidence,
      );

      detector.assess(
        MuscleBalanceInput(muscleLoadEstimate: estimate, loggedSetCount: 6),
      );

      expect(estimate, before);
    });
  });
}

MuscleLoadEstimate _estimate({
  double chest = 0,
  double triceps = 0,
  double frontDeltoids = 0,
  double lats = 0,
  double upperBack = 0,
  double rearDeltoids = 0,
  double biceps = 0,
  double quadriceps = 0,
  double hamstrings = 0,
  double glutes = 0,
  double calves = 0,
}) {
  final loads = <MuscleLoad>[
    if (chest > 0)
      MuscleLoad(muscleId: MuscleId('chest'), estimatedLoadKg: chest),
    if (triceps > 0)
      MuscleLoad(muscleId: MuscleId('triceps'), estimatedLoadKg: triceps),
    if (frontDeltoids > 0)
      MuscleLoad(
        muscleId: MuscleId('front_deltoids'),
        estimatedLoadKg: frontDeltoids,
      ),
    if (lats > 0) MuscleLoad(muscleId: MuscleId('lats'), estimatedLoadKg: lats),
    if (upperBack > 0)
      MuscleLoad(muscleId: MuscleId('upper_back'), estimatedLoadKg: upperBack),
    if (rearDeltoids > 0)
      MuscleLoad(
        muscleId: MuscleId('rear_deltoids'),
        estimatedLoadKg: rearDeltoids,
      ),
    if (biceps > 0)
      MuscleLoad(muscleId: MuscleId('biceps'), estimatedLoadKg: biceps),
    if (quadriceps > 0)
      MuscleLoad(muscleId: MuscleId('quadriceps'), estimatedLoadKg: quadriceps),
    if (hamstrings > 0)
      MuscleLoad(muscleId: MuscleId('hamstrings'), estimatedLoadKg: hamstrings),
    if (glutes > 0)
      MuscleLoad(muscleId: MuscleId('glutes'), estimatedLoadKg: glutes),
    if (calves > 0)
      MuscleLoad(muscleId: MuscleId('calves'), estimatedLoadKg: calves),
  ];

  return MuscleLoadEstimate(
    muscleLoads: loads,
    unknownExercises: const <ExerciseRef>[],
    confidence: MuscleLoadConfidence.estimated,
  );
}
