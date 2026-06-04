import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/analytics/domain/analytics_domain.dart';
import 'package:repforge/src/features/exercise_catalog/domain/exercise_catalog_domain.dart';
import 'package:repforge/src/features/recommendations/domain/recommendations_domain.dart';
import 'package:repforge/src/features/recovery/domain/recovery_domain.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

void main() {
  group('DeterministicQuickSessionGenerator', () {
    test('15 minute quick sessions select a concise two exercise plan', () {
      final plan = _generator.generate(
        QuickSessionRequest(
          duration: QuickSessionDuration.fifteen,
          recommendationRequest: _request(candidates: _fullBodyCandidates()),
        ),
      );

      expect(plan.status, QuickSessionPlanStatus.available);
      expect(plan.duration.minutes, 15);
      expect(plan.exercises, hasLength(2));
      expect(_ids(plan), <String>['push-up', 'row']);
      expect(plan.allowsWorkoutLogging, isTrue);
      expect(plan.replacesNormalGroupSession, isFalse);
      expect(
        plan.reasons,
        contains(QuickSessionReasonCode.normalSessionPreserved),
      );
    });

    test('25 minute quick sessions select three exercises', () {
      final plan = _generator.generate(
        QuickSessionRequest(
          duration: QuickSessionDuration.twentyFive,
          recommendationRequest: _request(candidates: _fullBodyCandidates()),
        ),
      );

      expect(plan.exercises, hasLength(3));
      expect(_ids(plan), <String>['push-up', 'row', 'squat']);
      expect(plan.duration.targetExerciseCount, 3);
    });

    test('35 minute quick sessions select up to five exercises', () {
      final plan = _generator.generate(
        QuickSessionRequest(
          duration: QuickSessionDuration.thirtyFive,
          recommendationRequest: _request(candidates: _fullBodyCandidates()),
        ),
      );

      expect(plan.exercises, hasLength(5));
      expect(_ids(plan), <String>[
        'push-up',
        'row',
        'squat',
        'hinge',
        'pressdown',
      ]);
      expect(plan.duration.maxExerciseCount, 5);
    });

    test('empty candidates return unavailable non-blocking plan', () {
      final plan = _generator.generate(
        QuickSessionRequest(
          duration: QuickSessionDuration.twentyFive,
          recommendationRequest: _request(
            candidates: const <RecommendationCandidate>[],
          ),
        ),
      );

      expect(plan.status, QuickSessionPlanStatus.unavailable);
      expect(plan.inputQuality, QuickSessionInputQuality.unavailable);
      expect(plan.exercises, isEmpty);
      expect(plan.coverage.coveredMuscles, isEmpty);
      expect(plan.allowsWorkoutLogging, isTrue);
      expect(plan.replacesNormalGroupSession, isFalse);
      expect(plan.reasons, contains(QuickSessionReasonCode.candidateListEmpty));
    });

    test(
      'limited equipment filters unavailable candidates and reports skips',
      () {
        final plan = _generator.generate(
          QuickSessionRequest(
            duration: QuickSessionDuration.fifteen,
            recommendationRequest: _request(
              candidates: <RecommendationCandidate>[
                _candidate(
                  id: 'barbell-bench',
                  name: 'Barbell Bench Press',
                  equipment: const <String>['barbell', 'bench'],
                ),
                _candidate(id: 'push-up', name: 'Push-up'),
                _candidate(
                  id: 'row',
                  name: 'Bodyweight Row',
                  patterns: const <String>['horizontal_pull'],
                  primaryMuscles: const <String>['lats'],
                ),
              ],
            ),
          ),
        );

        expect(_ids(plan), <String>['push-up', 'row']);
        expect(
          plan.skippedItems
              .where(
                (item) =>
                    item.code == QuickSessionSkippedCode.unavailableEquipment,
              )
              .single
              .exerciseRef!
              .id,
          'barbell-bench',
        );
        expect(plan.reasons, contains(QuickSessionReasonCode.equipmentLimited));
      },
    );

    test('max-load constraints carry adjusted suggestions into quick plan', () {
      final plan = _generator.generate(
        QuickSessionRequest(
          duration: QuickSessionDuration.fifteen,
          recommendationRequest: _request(
            candidates: <RecommendationCandidate>[
              _candidate(
                id: 'bench',
                name: 'Bench Press',
                equipment: const <String>['barbell', 'bench'],
                estimatedWorkingLoadKg: 120,
              ),
              _candidate(
                id: 'row',
                name: 'Bodyweight Row',
                patterns: const <String>['horizontal_pull'],
                primaryMuscles: const <String>['lats'],
              ),
            ],
            equipment: const <AvailableEquipment>[
              AvailableEquipment.barbell,
              AvailableEquipment.bench,
              AvailableEquipment.bodyweight,
            ],
            loadConstraints: <AvailableEquipment, EquipmentLoadConstraint>{
              AvailableEquipment.barbell: EquipmentLoadConstraint(
                maxLoadKg: MaxLoadKg(80),
              ),
            },
          ),
        ),
      );

      final bench = plan.exercises.singleWhere(
        (exercise) =>
            exercise.recommendation.exercise.exerciseRef.id == 'bench',
      );
      expect(bench.suggestedLoadKg, 80);
      expect(bench.reasons, contains(QuickSessionReasonCode.loadAdjusted));
    });

    test('high soreness keeps plan available and deprioritizes heavy work', () {
      final plan = _generator.generate(
        QuickSessionRequest(
          duration: QuickSessionDuration.fifteen,
          recommendationRequest: _request(
            readiness: _readiness(ReadinessLevel.low, soreness: 3),
            candidates: <RecommendationCandidate>[
              _candidate(
                id: 'heavy-deadlift',
                name: 'Heavy Deadlift',
                equipment: const <String>['barbell'],
                patterns: const <String>['hinge'],
                primaryMuscles: const <String>['hamstrings', 'glutes'],
                estimatedWorkingLoadKg: 140,
              ),
              _candidate(
                id: 'row',
                name: 'Bodyweight Row',
                patterns: const <String>['horizontal_pull'],
                primaryMuscles: const <String>['lats'],
              ),
              _candidate(id: 'push-up', name: 'Push-up'),
            ],
            equipment: const <AvailableEquipment>[
              AvailableEquipment.barbell,
              AvailableEquipment.bodyweight,
            ],
          ),
        ),
      );

      expect(_ids(plan), <String>['push-up', 'row']);
      expect(plan.allowsWorkoutLogging, isTrue);
      expect(
        plan.skippedItems
            .where(
              (item) => item.code == QuickSessionSkippedCode.readinessReduced,
            )
            .single
            .exerciseRef!
            .id,
        'heavy-deadlift',
      );
      expect(plan.reasons, contains(QuickSessionReasonCode.readinessAdjusted));
    });

    test('muscle-balance gaps prioritize the neglected area', () {
      final plan = _generator.generate(
        QuickSessionRequest(
          duration: QuickSessionDuration.fifteen,
          recommendationRequest: _request(
            balanceAssessment: _balance(
              MuscleBalanceSignalType.legNeglect,
              affectedMuscles: <MuscleId>[MuscleId('quadriceps')],
            ),
            candidates: <RecommendationCandidate>[
              _candidate(id: 'push-up', name: 'Push-up', groupPosition: 1),
              _candidate(
                id: 'squat',
                name: 'Goblet Squat',
                equipment: const <String>['dumbbell'],
                patterns: const <String>['squat'],
                primaryMuscles: const <String>['quadriceps'],
                groupPosition: 2,
              ),
              _candidate(
                id: 'row',
                name: 'Row',
                equipment: const <String>['dumbbell'],
                patterns: const <String>['horizontal_pull'],
                primaryMuscles: const <String>['lats'],
                groupPosition: 3,
              ),
            ],
          ),
        ),
      );

      expect(
        plan.exercises.first.recommendation.exercise.exerciseRef.id,
        'squat',
      );
      expect(
        plan.reasons,
        contains(QuickSessionReasonCode.muscleBalancePriority),
      );
    });

    test(
      'balanced fallback covers push pull and lower body when signals are weak',
      () {
        final plan = _generator.generate(
          QuickSessionRequest(
            duration: QuickSessionDuration.twentyFive,
            recommendationRequest: _request(
              candidates: <RecommendationCandidate>[
                _candidate(id: 'push-up', name: 'Push-up', groupPosition: 1),
                _candidate(
                  id: 'chest-press',
                  name: 'Chest Press',
                  equipment: const <String>['machine'],
                  groupPosition: 2,
                ),
                _candidate(
                  id: 'row',
                  name: 'Row',
                  equipment: const <String>['dumbbell'],
                  patterns: const <String>['horizontal_pull'],
                  primaryMuscles: const <String>['lats'],
                ),
                _candidate(
                  id: 'squat',
                  name: 'Goblet Squat',
                  equipment: const <String>['dumbbell'],
                  patterns: const <String>['squat'],
                  primaryMuscles: const <String>['quadriceps'],
                ),
              ],
              equipment: const <AvailableEquipment>[
                AvailableEquipment.bodyweight,
                AvailableEquipment.dumbbell,
                AvailableEquipment.machine,
              ],
            ),
          ),
        );

        expect(_ids(plan), <String>['push-up', 'row', 'squat']);
        expect(plan.reasons, contains(QuickSessionReasonCode.balancedFallback));
      },
    );

    test('coverage lists covered and skipped muscles and patterns', () {
      final plan = _generator.generate(
        QuickSessionRequest(
          duration: QuickSessionDuration.fifteen,
          recommendationRequest: _request(
            candidates: <RecommendationCandidate>[
              _candidate(id: 'push-up', name: 'Push-up'),
              _candidate(
                id: 'row',
                name: 'Row',
                equipment: const <String>['dumbbell'],
                patterns: const <String>['horizontal_pull'],
                primaryMuscles: const <String>['lats'],
              ),
              _candidate(
                id: 'squat',
                name: 'Goblet Squat',
                equipment: const <String>['dumbbell'],
                patterns: const <String>['squat'],
                primaryMuscles: const <String>['quadriceps'],
              ),
            ],
          ),
        ),
      );

      expect(
        plan.coverage.coveredMuscles.map((muscle) => muscle.value),
        <String>['chest', 'lats'],
      );
      expect(
        plan.coverage.skippedMuscles.map((muscle) => muscle.value),
        <String>['quadriceps'],
      );
      expect(
        plan.coverage.coveredMovementPatterns.map((pattern) => pattern.value),
        <String>['horizontal_pull', 'horizontal_push'],
      );
      expect(
        plan.coverage.skippedMovementPatterns.map((pattern) => pattern.value),
        <String>['squat'],
      );
    });

    test('stable tie-breaking is deterministic across input order', () {
      final first = _generator.generate(
        QuickSessionRequest(
          duration: QuickSessionDuration.fifteen,
          recommendationRequest: _request(
            candidates: <RecommendationCandidate>[
              _candidate(id: 'b', name: 'B'),
              _candidate(id: 'a', name: 'A'),
            ],
          ),
        ),
      );
      final second = _generator.generate(
        QuickSessionRequest(
          duration: QuickSessionDuration.fifteen,
          recommendationRequest: _request(
            candidates: <RecommendationCandidate>[
              _candidate(id: 'a', name: 'A'),
              _candidate(id: 'b', name: 'B'),
            ],
          ),
        ),
      );

      expect(_ids(first), <String>['a', 'b']);
      expect(_ids(second), <String>['a', 'b']);
      expect(first.reasons, contains(QuickSessionReasonCode.stableTieBreak));
    });

    test('domain has no UI persistence backend cloud or account imports', () {
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

const _generator = DeterministicQuickSessionGenerator();

List<RecommendationCandidate> _fullBodyCandidates() {
  return <RecommendationCandidate>[
    _candidate(id: 'push-up', name: 'Push-up', groupPosition: 1),
    _candidate(
      id: 'row',
      name: 'Bodyweight Row',
      patterns: const <String>['horizontal_pull'],
      primaryMuscles: const <String>['lats'],
      groupPosition: 2,
    ),
    _candidate(
      id: 'squat',
      name: 'Goblet Squat',
      equipment: const <String>['dumbbell'],
      patterns: const <String>['squat'],
      primaryMuscles: const <String>['quadriceps'],
      groupPosition: 3,
    ),
    _candidate(
      id: 'hinge',
      name: 'Dumbbell RDL',
      equipment: const <String>['dumbbell'],
      patterns: const <String>['hinge'],
      primaryMuscles: const <String>['hamstrings', 'glutes'],
      groupPosition: 4,
    ),
    _candidate(
      id: 'pressdown',
      name: 'Band Pressdown',
      patterns: const <String>['elbow_extension'],
      primaryMuscles: const <String>['triceps'],
      groupPosition: 5,
    ),
  ];
}

RecommendationRequest _request({
  required Iterable<RecommendationCandidate> candidates,
  Iterable<AvailableEquipment> equipment = const <AvailableEquipment>[
    AvailableEquipment.bodyweight,
    AvailableEquipment.dumbbell,
  ],
  Map<AvailableEquipment, EquipmentLoadConstraint> loadConstraints =
      const <AvailableEquipment, EquipmentLoadConstraint>{},
  MuscleBalanceAssessment? balanceAssessment,
  ReadinessReadModel? readiness,
}) {
  return RecommendationRequest(
    candidates: candidates,
    settingsProfile: SettingsProfile.defaults().copyWith(
      focusProfile: FocusProfile.balanced,
      sessionDuration: SessionDurationPreference.twentyFive,
      equipmentInventory: EquipmentInventory(
        equipment,
        loadConstraints: loadConstraints,
      ),
    ),
    muscleBalanceAssessment: balanceAssessment,
    readiness: readiness,
    maxRecommendations: 8,
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

List<String> _ids(QuickSessionPlan plan) {
  return plan.exercises
      .map((exercise) => exercise.recommendation.exercise.exerciseRef.id)
      .toList(growable: false);
}
