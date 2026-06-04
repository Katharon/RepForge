import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/analytics/domain/analytics_domain.dart';
import 'package:repforge/src/features/exercise_catalog/domain/exercise_catalog_domain.dart';
import 'package:repforge/src/features/recommendations/domain/recommendations_domain.dart';
import 'package:repforge/src/features/recovery/domain/recovery_domain.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

void main() {
  group('DeterministicAdaptiveSetSuggester', () {
    test('no-history starter behavior returns safe maintain suggestion', () {
      final suggestion = _suggester.suggest(
        AdaptiveSetSuggestionRequest(currentSet: _current(load: 40, reps: 8)),
      );

      expect(suggestion.direction, AdaptiveSetDirection.maintain);
      expect(suggestion.inputQuality, AdaptiveSetInputQuality.partial);
      expect(suggestion.suggestedLoadKg, 40);
      expect(suggestion.suggestedRepetitionsValue, 8);
      expect(suggestion.allowsWorkoutLogging, isTrue);
      expect(suggestion.userOverrideAllowed, isTrue);
      expect(suggestion.reasons, contains(AdaptiveSetReasonCode.noBaseline));
    });

    test('good readiness and exceeded baseline suggests add weight', () {
      final suggestion = _suggester.suggest(
        AdaptiveSetSuggestionRequest(
          currentSet: _current(load: 80, reps: 12),
          baseline: _baseline(load: 80, reps: 10),
          readiness: _readiness(ReadinessLevel.high, soreness: 0),
          equipmentInventory: _equipment(
            AvailableEquipment.barbell,
            maxLoadKg: 120,
            incrementKg: 2.5,
          ),
          primaryEquipment: AvailableEquipment.barbell,
        ),
      );

      expect(suggestion.direction, AdaptiveSetDirection.addWeight);
      expect(suggestion.suggestedLoadKg, 82.5);
      expect(suggestion.suggestedRepetitionsValue, 10);
      expect(
        suggestion.reasons,
        containsAll(<AdaptiveSetReasonCode>[
          AdaptiveSetReasonCode.goodReadiness,
          AdaptiveSetReasonCode.baselineExceeded,
          AdaptiveSetReasonCode.loadIncrementApplied,
        ]),
      );
    });

    test(
      'max-load reached suggests reps or maintain, not impossible weight',
      () {
        final suggestion = _suggester.suggest(
          AdaptiveSetSuggestionRequest(
            currentSet: _current(load: 80, reps: 10),
            baseline: _baseline(load: 80, reps: 9),
            readiness: _readiness(ReadinessLevel.high, soreness: 0),
            equipmentInventory: _equipment(
              AvailableEquipment.barbell,
              maxLoadKg: 80,
              incrementKg: 2.5,
            ),
            primaryEquipment: AvailableEquipment.barbell,
          ),
        );

        expect(suggestion.direction, AdaptiveSetDirection.addReps);
        expect(suggestion.suggestedLoadKg, 80);
        expect(suggestion.suggestedRepetitionsValue, 11);
        expect(
          suggestion.reasons,
          contains(AdaptiveSetReasonCode.equipmentMaxLoadReached),
        );
      },
    );

    test('available load increment snaps suggested load deterministically', () {
      final suggestion = _suggester.suggest(
        AdaptiveSetSuggestionRequest(
          currentSet: _current(load: 82, reps: 12),
          baseline: _baseline(load: 80, reps: 12),
          readiness: _readiness(ReadinessLevel.high, soreness: 0),
          equipmentInventory: _equipment(
            AvailableEquipment.dumbbell,
            maxLoadKg: 100,
            incrementKg: 2.5,
          ),
          primaryEquipment: AvailableEquipment.dumbbell,
        ),
      );

      expect(suggestion.direction, AdaptiveSetDirection.addWeight);
      expect(suggestion.suggestedLoadKg, 82.5);
    });

    test('low readiness suggests backoff instead of progression', () {
      final suggestion = _suggester.suggest(
        AdaptiveSetSuggestionRequest(
          currentSet: _current(load: 80, reps: 12),
          baseline: _baseline(load: 80, reps: 10),
          readiness: _readiness(ReadinessLevel.low, soreness: 2),
          equipmentInventory: _equipment(
            AvailableEquipment.barbell,
            maxLoadKg: 120,
            incrementKg: 2.5,
          ),
          primaryEquipment: AvailableEquipment.barbell,
        ),
      );

      expect(suggestion.direction, AdaptiveSetDirection.backoff);
      expect(suggestion.suggestedLoadKg, 70);
      expect(suggestion.suggestedRepetitionsValue, 10);
      expect(suggestion.reasons, contains(AdaptiveSetReasonCode.lowReadiness));
    });

    test(
      'very high soreness suppresses progression and can choose alternative',
      () {
        final alternative = _alternative('cable-row', 'Cable Row');
        final suggestion = _suggester.suggest(
          AdaptiveSetSuggestionRequest(
            currentSet: _current(load: 100, reps: 12),
            baseline: _baseline(load: 100, reps: 10),
            readiness: _readiness(ReadinessLevel.veryLow, soreness: 4),
            recommendationAlternatives: <RecommendationAlternative>[
              alternative,
            ],
          ),
        );

        expect(suggestion.direction, AdaptiveSetDirection.chooseAlternative);
        expect(suggestion.alternatives.single.exerciseRef.id, 'cable-row');
        expect(
          suggestion.reasons,
          containsAll(<AdaptiveSetReasonCode>[
            AdaptiveSetReasonCode.veryLowReadiness,
            AdaptiveSetReasonCode.highSoreness,
            AdaptiveSetReasonCode.alternativeAvailable,
          ]),
        );
      },
    );

    test(
      'very low readiness without alternatives can return conservative stop',
      () {
        final suggestion = _suggester.suggest(
          AdaptiveSetSuggestionRequest(
            currentSet: _current(load: 100, reps: 12),
            baseline: _baseline(load: 100, reps: 10),
            readiness: _readiness(ReadinessLevel.veryLow, soreness: 4),
          ),
        );

        expect(suggestion.direction, AdaptiveSetDirection.stop);
        expect(
          suggestion.reasons,
          contains(AdaptiveSetReasonCode.conservativeStop),
        );
        expect(suggestion.allowsWorkoutLogging, isTrue);
      },
    );

    test('strength-down pattern suggests backoff', () {
      final suggestion = _suggester.suggest(
        AdaptiveSetSuggestionRequest(
          currentSet: _current(load: 80, reps: 6),
          baseline: _baseline(load: 80, reps: 10),
          readiness: _readiness(ReadinessLevel.medium, soreness: 1),
        ),
      );

      expect(suggestion.direction, AdaptiveSetDirection.backoff);
      expect(suggestion.reasons, contains(AdaptiveSetReasonCode.strengthDown));
    });

    test('matching baseline suggests maintain', () {
      final suggestion = _suggester.suggest(
        AdaptiveSetSuggestionRequest(
          currentSet: _current(load: 80, reps: 10),
          baseline: _baseline(load: 80, reps: 10),
          readiness: _readiness(ReadinessLevel.medium, soreness: 0),
        ),
      );

      expect(suggestion.direction, AdaptiveSetDirection.maintain);
      expect(
        suggestion.reasons,
        contains(AdaptiveSetReasonCode.baselineMatched),
      );
    });

    test(
      'small below-baseline dip with normal readiness suggests maintain',
      () {
        final suggestion = _suggester.suggest(
          AdaptiveSetSuggestionRequest(
            currentSet: _current(load: 80, reps: 9),
            baseline: _baseline(load: 80, reps: 10),
            readiness: _readiness(ReadinessLevel.medium, soreness: 1),
          ),
        );

        expect(suggestion.direction, AdaptiveSetDirection.maintain);
        expect(
          suggestion.reasons,
          contains(AdaptiveSetReasonCode.baselineBelow),
        );
      },
    );

    test('RPE missing does not fail and remains explicitly not required', () {
      final suggestion = _suggester.suggest(
        AdaptiveSetSuggestionRequest(
          currentSet: _current(load: 60, reps: 10),
          baseline: _baseline(load: 60, reps: 10),
        ),
      );

      expect(suggestion.direction, AdaptiveSetDirection.maintain);
      expect(
        suggestion.reasons,
        contains(AdaptiveSetReasonCode.rpeNotRequired),
      );
    });

    test('reason codes avoid mandatory stop and forced heavier wording', () {
      final names = AdaptiveSetReasonCode.values
          .map((code) => code.name)
          .join(' ');

      expect(
        names,
        isNot(matches(RegExp('must|force|forced|diagnos|medical|injury|sham'))),
      );
    });

    test('domain has no Flutter Drift backend cloud or account imports', () {
      final domainDir = Directory('lib/src/features/recommendations/domain');
      final forbidden = RegExp(
        'package:flutter|package:drift|sqlite|GeneratedDatabase|Firebase|Firestore|OpenAI|LLM|backend|account',
      );

      for (final file
          in domainDir.listSync(recursive: true).whereType<File>()) {
        expect(file.readAsStringSync(), isNot(matches(forbidden)));
      }
    });
  });
}

const _suggester = DeterministicAdaptiveSetSuggester();

CurrentSetPerformance _current({required num load, required int reps}) {
  return CurrentSetPerformance(
    exerciseRef: _ref('bench', 'Bench Press'),
    load: LoadKg(load),
    repetitions: Repetitions(reps),
  );
}

SetPerformanceBaseline _baseline({required num load, required int reps}) {
  return SetPerformanceBaseline(
    exerciseRef: _ref('bench', 'Bench Press'),
    load: LoadKg(load),
    repetitions: Repetitions(reps),
  );
}

EquipmentInventory _equipment(
  AvailableEquipment equipment, {
  required num maxLoadKg,
  required num incrementKg,
}) {
  return EquipmentInventory(
    <AvailableEquipment>[equipment],
    loadConstraints: <AvailableEquipment, EquipmentLoadConstraint>{
      equipment: EquipmentLoadConstraint(
        maxLoadKg: MaxLoadKg(maxLoadKg.toDouble()),
        incrementKg: LoadIncrementKg(incrementKg.toDouble()),
      ),
    },
  );
}

RecommendationAlternative _alternative(String id, String name) {
  return RecommendationAlternative(
    replacesExerciseRef: _ref('bench', 'Bench Press'),
    exercise: RecommendationCandidate(
      exerciseRef: _ref(id, name),
      equipment: <EquipmentTag>[EquipmentTag('cable')],
      movementPatterns: <MovementPattern>[MovementPattern('horizontal_pull')],
      primaryMuscles: <MuscleId>[MuscleId('lats')],
    ),
    score: RecommendationScore(10),
    reasons: const <RecommendationReasonCode>[
      RecommendationReasonCode.alternativeAvailable,
    ],
  );
}

ExerciseRef _ref(String id, String name) {
  return ExerciseRef.official(
    id: OfficialExerciseId(id),
    displayNameSnapshot: name,
    catalogVersionSnapshot: '2026.06.0',
  );
}

ReadinessReadModel _readiness(ReadinessLevel level, {required int soreness}) {
  return ReadinessReadModel(
    status: ReadinessReadModelStatus.available,
    forDate: DateTime.utc(2026, 6, 4),
    confidence: ReadinessConfidence.reported,
    latestCheckIn: ReadinessCheckIn(
      id: ReadinessCheckInId('check-in'),
      checkedInAt: DateTime.utc(2026, 6, 4, 8),
      soreness: SorenessRating(soreness),
      sleepQuality: SleepQualityRating(4),
      energy: EnergyRating(4),
      stress: StressRating(2),
      motivation: MotivationRating(4),
    ),
    score: ReadinessScore(switch (level) {
      ReadinessLevel.high => 86,
      ReadinessLevel.medium => 72,
      ReadinessLevel.low => 48,
      ReadinessLevel.veryLow => 25,
    }),
    level: level,
    reasons: soreness >= 3
        ? const <ReadinessReason>[ReadinessReason.highSoreness]
        : const <ReadinessReason>[],
  );
}
