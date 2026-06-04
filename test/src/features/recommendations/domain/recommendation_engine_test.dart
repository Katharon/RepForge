import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/analytics/domain/analytics_domain.dart';
import 'package:repforge/src/features/exercise_catalog/domain/exercise_catalog_domain.dart';
import 'package:repforge/src/features/recommendations/domain/recommendations_domain.dart';
import 'package:repforge/src/features/recovery/domain/recovery_domain.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

void main() {
  group('DeterministicRecommendationEngine', () {
    test('empty candidate list returns unavailable advisory plan', () {
      final plan = const DeterministicRecommendationEngine().generate(
        RecommendationRequest(
          candidates: const <RecommendationCandidate>[],
          settingsProfile: SettingsProfile.defaults(),
        ),
      );

      expect(plan.status, RecommendationPlanStatus.unavailable);
      expect(plan.inputQuality, RecommendationInputQuality.unavailable);
      expect(plan.recommendations, isEmpty);
      expect(plan.allowsWorkoutLogging, isTrue);
      expect(
        plan.inputReasons,
        contains(RecommendationReasonCode.candidateListEmpty),
      );
    });

    test('selected group candidates are ordered deterministically', () {
      final plan = _engine.generate(
        _request(
          candidates: <RecommendationCandidate>[
            _candidate(
              id: 'row',
              name: 'Cable Row',
              equipment: const ['cable'],
              patterns: const ['horizontal_pull'],
              primaryMuscles: const ['lats'],
              groupPosition: 2,
            ),
            _candidate(
              id: 'press',
              name: 'Dumbbell Press',
              equipment: const ['dumbbell', 'bench'],
              groupPosition: 1,
            ),
          ],
          equipment: const <AvailableEquipment>[
            AvailableEquipment.dumbbell,
            AvailableEquipment.bench,
            AvailableEquipment.cable,
          ],
        ),
      );

      expect(_ids(plan), <String>['press', 'row']);
      expect(
        plan.recommendations.first.reasons,
        contains(RecommendationReasonCode.groupAssignment),
      );
    });

    test('unavailable equipment filters exercises and offers alternatives', () {
      final plan = _engine.generate(
        _request(
          candidates: <RecommendationCandidate>[
            _candidate(
              id: 'barbell-bench',
              name: 'Barbell Bench Press',
              equipment: const ['barbell', 'bench'],
            ),
            _candidate(id: 'push-up', name: 'Push-up'),
          ],
        ),
      );

      expect(_ids(plan), <String>['push-up']);
      expect(
        plan.constraints.single.code,
        RecommendationConstraintCode.unavailableEquipment,
      );
      expect(plan.alternatives.single.replacesExerciseRef.id, 'barbell-bench');
      expect(plan.alternatives.single.exercise.exerciseRef.id, 'push-up');
    });

    test('equipment max-load constraints adjust suggestions', () {
      final plan = _engine.generate(
        _request(
          candidates: <RecommendationCandidate>[
            _candidate(
              id: 'bench',
              name: 'Bench Press',
              equipment: const ['barbell', 'bench'],
              estimatedWorkingLoadKg: 120,
            ),
          ],
          equipment: const <AvailableEquipment>[
            AvailableEquipment.barbell,
            AvailableEquipment.bench,
          ],
          loadConstraints: <AvailableEquipment, EquipmentLoadConstraint>{
            AvailableEquipment.barbell: EquipmentLoadConstraint(
              maxLoadKg: MaxLoadKg(80),
              incrementKg: LoadIncrementKg(2.5),
            ),
          },
        ),
      );

      expect(plan.recommendations.single.suggestedLoadKg, 80);
      expect(
        plan.recommendations.single.constraints.single.code,
        RecommendationConstraintCode.maxLoadExceeded,
      );
      expect(
        plan.recommendations.single.reasons,
        contains(RecommendationReasonCode.loadAdjustedForConstraint),
      );
    });

    test('focus-aware suggestions prioritize matching goals and patterns', () {
      final plan = _engine.generate(
        _request(
          focusProfile: FocusProfile.lowerBodyGluteFocus,
          candidates: <RecommendationCandidate>[
            _candidate(
              id: 'press',
              name: 'Chest Press',
              equipment: const ['machine'],
            ),
            _candidate(
              id: 'hip-thrust',
              name: 'Hip Thrust',
              equipment: const ['barbell', 'bench'],
              patterns: const ['hinge'],
              primaryMuscles: const ['glutes'],
            ),
          ],
          equipment: const <AvailableEquipment>[
            AvailableEquipment.machine,
            AvailableEquipment.barbell,
            AvailableEquipment.bench,
          ],
        ),
      );

      expect(plan.recommendations.first.exercise.exerciseRef.id, 'hip-thrust');
      expect(
        plan.recommendations.first.reasons,
        contains(RecommendationReasonCode.focusMatch),
      );
    });

    test('muscle-balance push-heavy signal down-ranks push reinforcement', () {
      final plan = _engine.generate(
        _request(
          balanceAssessment: _balance(
            MuscleBalanceSignalType.pushHeavy,
            affectedMuscles: <MuscleId>[MuscleId('chest')],
          ),
          candidates: <RecommendationCandidate>[
            _candidate(
              id: 'press',
              name: 'Press',
              equipment: const ['dumbbell'],
            ),
            _candidate(
              id: 'row',
              name: 'Row',
              equipment: const ['dumbbell'],
              patterns: const ['horizontal_pull'],
              primaryMuscles: const ['lats'],
            ),
          ],
          equipment: const <AvailableEquipment>[AvailableEquipment.dumbbell],
        ),
      );

      expect(_ids(plan), <String>['row', 'press']);
      expect(
        plan.recommendations.first.reasons,
        contains(RecommendationReasonCode.balancePullPriority),
      );
      expect(
        plan.recommendations.last.reasons,
        contains(RecommendationReasonCode.balancePushSuppressed),
      );
    });

    test('leg-neglect signal increases lower-body priority', () {
      final plan = _engine.generate(
        _request(
          balanceAssessment: _balance(
            MuscleBalanceSignalType.legNeglect,
            affectedMuscles: <MuscleId>[MuscleId('quadriceps')],
          ),
          candidates: <RecommendationCandidate>[
            _candidate(
              id: 'curl',
              name: 'Curl',
              equipment: const ['dumbbell'],
              patterns: const ['elbow_flexion'],
              primaryMuscles: const ['biceps'],
            ),
            _candidate(
              id: 'squat',
              name: 'Goblet Squat',
              equipment: const ['dumbbell'],
              patterns: const ['squat'],
              primaryMuscles: const ['quadriceps'],
            ),
          ],
          equipment: const <AvailableEquipment>[AvailableEquipment.dumbbell],
        ),
      );

      expect(plan.recommendations.first.exercise.exerciseRef.id, 'squat');
      expect(
        plan.recommendations.first.reasons,
        contains(RecommendationReasonCode.balanceLowerPriority),
      );
    });

    test(
      'high soreness suppresses heavy work without mandatory rest wording',
      () {
        final plan = _engine.generate(
          _request(
            readiness: _readiness(ReadinessLevel.low, soreness: 3),
            candidates: <RecommendationCandidate>[
              _candidate(
                id: 'heavy-deadlift',
                name: 'Heavy Deadlift',
                equipment: const ['barbell'],
                patterns: const ['hinge'],
                primaryMuscles: const ['hamstrings', 'glutes'],
                estimatedWorkingLoadKg: 140,
              ),
              _candidate(
                id: 'bodyweight-row',
                name: 'Bodyweight Row',
                patterns: const ['horizontal_pull'],
                primaryMuscles: const ['lats'],
              ),
            ],
            equipment: const <AvailableEquipment>[
              AvailableEquipment.barbell,
              AvailableEquipment.bodyweight,
            ],
          ),
        );

        expect(plan.allowsWorkoutLogging, isTrue);
        expect(_ids(plan), <String>['bodyweight-row', 'heavy-deadlift']);
        expect(
          plan.recommendations.last.reasons,
          contains(RecommendationReasonCode.readinessReducedIntensity),
        );
        expect(
          RecommendationReasonCode.values.map((code) => code.name).join(' '),
          isNot(matches(RegExp('mandatory|must|diagnos|injury|medical'))),
        );
      },
    );

    test('alternatives are generated for lower-ranked candidates', () {
      final plan = _engine.generate(
        _request(
          candidates: <RecommendationCandidate>[
            _candidate(
              id: 'bench',
              name: 'Bench',
              equipment: const ['barbell', 'bench'],
              groupPosition: 1,
            ),
            _candidate(id: 'push-up', name: 'Push-up', groupPosition: 2),
          ],
          equipment: const <AvailableEquipment>[
            AvailableEquipment.barbell,
            AvailableEquipment.bench,
            AvailableEquipment.bodyweight,
          ],
        ),
      );

      expect(
        plan.recommendations.first.alternatives.single.exercise.exerciseRef.id,
        'push-up',
      );
      expect(
        plan.recommendations.first.alternatives.single.reasons,
        contains(RecommendationReasonCode.alternativeAvailable),
      );
    });

    test(
      'substitution and exclusion recompute stable next recommendations',
      () {
        final skipped = _ref('bench', 'Bench');
        final selected = _ref('push-up', 'Push-up');
        final plan = _engine.generate(
          _request(
            excludedExerciseRefs: <ExerciseRef>[skipped],
            substitutions: <RecommendationSubstitution>[
              RecommendationSubstitution(
                skippedExerciseRef: skipped,
                selectedExerciseRef: selected,
              ),
            ],
            candidates: <RecommendationCandidate>[
              _candidate(
                id: 'bench',
                name: 'Bench',
                equipment: const ['barbell', 'bench'],
              ),
              _candidate(id: 'push-up', name: 'Push-up'),
              _candidate(
                id: 'row',
                name: 'Row',
                equipment: const ['dumbbell'],
                patterns: const ['horizontal_pull'],
                primaryMuscles: const ['lats'],
              ),
            ],
            equipment: const <AvailableEquipment>[
              AvailableEquipment.barbell,
              AvailableEquipment.bench,
              AvailableEquipment.bodyweight,
              AvailableEquipment.dumbbell,
            ],
          ),
        );

        expect(_ids(plan), <String>['row', 'push-up']);
        expect(
          plan.recommendations.first.reasons,
          contains(RecommendationReasonCode.substitutionApplied),
        );
        expect(
          plan.constraints
              .where(
                (constraint) =>
                    constraint.code ==
                    RecommendationConstraintCode.excludedExercise,
              )
              .single
              .exerciseRef
              .id,
          'bench',
        );
      },
    );

    test('tie-breaking is stable by source, id, and display name', () {
      final first = _engine.generate(
        _request(
          candidates: <RecommendationCandidate>[
            _candidate(id: 'b', name: 'B'),
            _candidate(id: 'a', name: 'A'),
          ],
        ),
      );
      final second = _engine.generate(
        _request(
          candidates: <RecommendationCandidate>[
            _candidate(id: 'a', name: 'A'),
            _candidate(id: 'b', name: 'B'),
          ],
        ),
      );

      expect(_ids(first), <String>['a', 'b']);
      expect(_ids(second), <String>['a', 'b']);
      expect(
        first.recommendations.first.reasons,
        contains(RecommendationReasonCode.stableTieBreak),
      );
    });

    test('sex and gender profile fields do not change scoring', () {
      final candidates = <RecommendationCandidate>[
        _candidate(
          id: 'squat',
          name: 'Squat',
          primaryMuscles: const ['quadriceps'],
        ),
        _candidate(id: 'press', name: 'Press'),
      ];

      final first = _engine.generate(
        _request(
          candidates: candidates,
          settingsProfile: SettingsProfile.defaults().copyWith(
            userProfile: UserProfile(sexGender: SexGenderPreference.male),
          ),
        ),
      );
      final second = _engine.generate(
        _request(
          candidates: candidates,
          settingsProfile: SettingsProfile.defaults().copyWith(
            userProfile: UserProfile(sexGender: SexGenderPreference.female),
          ),
        ),
      );

      expect(_ids(first), _ids(second));
      expect(
        first.recommendations.map((item) => item.score.value),
        second.recommendations.map((item) => item.score.value),
      );
    });

    test('domain has no Flutter Drift backend or cloud imports', () {
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

const _engine = DeterministicRecommendationEngine();

RecommendationRequest _request({
  required Iterable<RecommendationCandidate> candidates,
  SettingsProfile? settingsProfile,
  FocusProfile? focusProfile,
  Iterable<AvailableEquipment> equipment = const <AvailableEquipment>[
    AvailableEquipment.bodyweight,
  ],
  Map<AvailableEquipment, EquipmentLoadConstraint> loadConstraints =
      const <AvailableEquipment, EquipmentLoadConstraint>{},
  MuscleBalanceAssessment? balanceAssessment,
  ReadinessReadModel? readiness,
  Iterable<ExerciseRef> excludedExerciseRefs = const <ExerciseRef>[],
  Iterable<RecommendationSubstitution> substitutions =
      const <RecommendationSubstitution>[],
}) {
  final profile = settingsProfile ?? SettingsProfile.defaults();
  return RecommendationRequest(
    candidates: candidates,
    settingsProfile: profile.copyWith(
      focusProfile: focusProfile ?? profile.focusProfile,
      equipmentInventory: EquipmentInventory(
        equipment,
        loadConstraints: loadConstraints,
      ),
    ),
    muscleBalanceAssessment: balanceAssessment,
    readiness: readiness,
    excludedExerciseRefs: excludedExerciseRefs,
    substitutions: substitutions,
  );
}

RecommendationCandidate _candidate({
  required String id,
  required String name,
  Iterable<String> equipment = const <String>['bodyweight'],
  Iterable<String> patterns = const <String>['horizontal_push'],
  Iterable<String> primaryMuscles = const <String>['chest'],
  int? groupPosition,
  double? estimatedWorkingLoadKg,
}) {
  return RecommendationCandidate(
    exerciseRef: _ref(id, name),
    equipment: equipment.map(EquipmentTag.new),
    movementPatterns: patterns.map(MovementPattern.new),
    primaryMuscles: primaryMuscles.map(MuscleId.new),
    groupPosition: groupPosition,
    estimatedWorkingLoadKg: estimatedWorkingLoadKg,
  );
}

ExerciseRef _ref(String id, String name) {
  return ExerciseRef.official(
    id: OfficialExerciseId(id),
    displayNameSnapshot: name,
    catalogVersionSnapshot: '2026.06.0',
  );
}

MuscleBalanceAssessment _balance(
  MuscleBalanceSignalType type, {
  Iterable<MuscleId> affectedMuscles = const <MuscleId>[],
}) {
  return MuscleBalanceAssessment(
    status: MuscleBalanceAssessmentStatus.imbalanced,
    confidence: MuscleBalanceConfidence.high,
    targetRange: MuscleBalanceTargetRange.forFocus(FocusProfile.balanced),
    signals: <MuscleBalanceSignal>[
      MuscleBalanceSignal(
        type: type,
        severity: MuscleBalanceSeverity.attention,
        evidence: MuscleBalanceEvidence(
          code: 'test.${type.name}',
          affectedMuscles: affectedMuscles,
        ),
      ),
    ],
    totalKnownLoadKg: 1000,
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
      energy: EnergyRating(3),
      stress: StressRating(2),
      motivation: MotivationRating(4),
    ),
    score: ReadinessScore(level == ReadinessLevel.low ? 55 : 80),
    level: level,
    reasons: const <ReadinessReason>[ReadinessReason.highSoreness],
  );
}

List<String> _ids(RecommendationPlan plan) {
  return plan.recommendations
      .map((recommendation) => recommendation.exercise.exerciseRef.id)
      .toList(growable: false);
}
