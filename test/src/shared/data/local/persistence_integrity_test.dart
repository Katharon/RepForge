import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/shared/data/local/persistence_integrity.dart';
import 'package:repforge/src/shared/data/local/repforge_database.dart';

void main() {
  late RepForgeDatabase database;
  late RepForgeIntegrityChecker checker;

  setUp(() {
    database = RepForgeDatabase(NativeDatabase.memory());
    checker = RepForgeIntegrityChecker(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('returns no findings for valid seeded local data', () async {
    await _seedValidDatabase(database);

    expect(await checker.inspect(), isEmpty);
  });

  test('detects invalid workout set values deterministically', () async {
    await _withIgnoredChecks(database, () async {
      await _insertWorkoutSet(
        database,
        id: 'set-invalid',
        exerciseSource: 'remote',
        exerciseId: '',
        exerciseDisplayNameSnapshot: '',
        catalogVersionSnapshot: null,
        repetitions: 0,
        loadKg: double.infinity,
        setLabel: 'tempo',
      );
    });

    final findings = await checker.inspect();

    expect(_codes(findings), <String>[
      'workoutSets.invalidExerciseSource',
      'workoutSets.invalidLoad',
      'workoutSets.invalidRepetitions',
      'workoutSets.invalidSetLabel',
      'workoutSets.missingExerciseSnapshot',
    ]);
    expect(
      findings.every((finding) => finding.entityId == 'set-invalid'),
      isTrue,
    );
  });

  test('detects orphaned and invalid workout group assignments', () async {
    await _withIgnoredChecks(database, () async {
      await database.customInsert(
        '''
INSERT INTO workout_group_exercise_assignments (
  assignment_id,
  workout_group_id,
  exercise_source,
  exercise_id,
  exercise_display_name_snapshot,
  catalog_version_snapshot,
  position
)
VALUES (?, ?, ?, ?, ?, ?, ?)
''',
        variables: <Variable<Object>>[
          const Variable<String>('assignment-invalid'),
          const Variable<String>('missing-group'),
          const Variable<String>('remote'),
          const Variable<String>(''),
          const Variable<String>(''),
          const Variable<String>('2026.05.0'),
          const Variable<int>(-1),
        ],
      );
    });

    expect(_codes(await checker.inspect()), <String>[
      'workoutGroupAssignments.invalidExerciseSource',
      'workoutGroupAssignments.invalidPosition',
      'workoutGroupAssignments.missingExerciseSnapshot',
      'workoutGroupAssignments.orphanedWorkoutGroup',
    ]);
  });

  test('detects invalid settings onboarding and catalog metadata', () async {
    await _withIgnoredChecks(database, () async {
      await database.customInsert(
        '''
INSERT INTO settings_profiles (
  profile_id,
  language_override,
  unit_preference,
  theme_preference,
  default_rest_seconds,
  display_name,
  focus_profile,
  training_days_per_week,
  session_duration_minutes
)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
''',
        variables: <Variable<Object>>[
          const Variable<String>('local'),
          const Variable<String>('fr'),
          const Variable<String>('metric'),
          const Variable<String>('system'),
          const Variable<int>(0),
          const Variable<String>(''),
          const Variable<String>('balanced'),
          const Variable<int>(8),
          const Variable<int>(10),
        ],
      );
      await database.customInsert(
        '''
INSERT INTO equipment_inventory_items (profile_id, equipment)
VALUES (?, ?)
''',
        variables: <Variable<Object>>[
          const Variable<String>('local'),
          const Variable<String>('kettlebell'),
        ],
      );
      await database.customInsert(
        '''
INSERT INTO onboarding_statuses (status_id, completion, updated_at)
VALUES (?, ?, ?)
''',
        variables: <Variable<Object>>[
          const Variable<String>('local'),
          const Variable<String>('maybe'),
          Variable<DateTime>(DateTime.utc(2026, 5, 28)),
        ],
      );
      await database.customInsert(
        '''
INSERT INTO catalog_imports (catalog_version, schema_version, imported_at)
VALUES (?, ?, ?)
''',
        variables: <Variable<Object>>[
          const Variable<String>(''),
          const Variable<int>(0),
          Variable<DateTime>(DateTime.utc(2026, 5, 28)),
        ],
      );
    });

    expect(_codes(await checker.inspect()), <String>[
      'catalogImports.invalidMetadata',
      'equipmentInventoryItems.invalidEquipment',
      'onboardingStatuses.invalidStatus',
      'settingsProfiles.invalidProfile',
    ]);
  });

  test('repair utility is report-only by default', () async {
    await _insertWorkoutSet(database, id: 'set-blank-label', setLabel: '');

    final result = await RepForgeIntegrityRepairer(database).repairSafe();
    final row = await database.select(database.workoutSets).getSingle();

    expect(result.applied, isFalse);
    expect(result.safeRepairCount, 1);
    expect(result.findings.single.safeRepairAvailable, isTrue);
    expect(row.setLabel, '');
  });

  test('safe repair normalizes blank labels without destroying data', () async {
    await _seedValidDatabase(database);
    await _insertWorkoutSet(database, id: 'set-blank-label', setLabel: '');

    final result = await RepForgeIntegrityRepairer(
      database,
    ).repairSafe(apply: true);

    final repairedSet =
        await (database.select(database.workoutSets)
              ..where(($WorkoutSetsTable table) {
                return table.workoutSetId.equals('set-blank-label');
              }))
            .getSingle();

    expect(result.applied, isTrue);
    expect(result.safeRepairCount, 1);
    expect(repairedSet.setLabel, isNull);
    expect(await database.select(database.workoutGroups).get(), hasLength(1));
    expect(
      await database.select(database.officialExercises).get(),
      hasLength(1),
    );
  });
}

List<String> _codes(List<PersistenceIntegrityFinding> findings) {
  return findings.map((finding) => finding.code).toList(growable: false);
}

Future<void> _withIgnoredChecks(
  RepForgeDatabase database,
  Future<void> Function() action,
) async {
  await database.customStatement('PRAGMA ignore_check_constraints = ON');
  try {
    await action();
  } finally {
    await database.customStatement('PRAGMA ignore_check_constraints = OFF');
  }
}

Future<void> _seedValidDatabase(RepForgeDatabase database) async {
  await database
      .into(database.officialExercises)
      .insert(
        OfficialExercisesCompanion.insert(
          catalogId: 'barbell-bench-press',
          catalogVersion: '2026.05.0',
          schemaVersion: 1,
          englishName: 'Barbell Bench Press',
          germanName: 'Bankdruecken',
        ),
      );
  await database
      .into(database.catalogImports)
      .insert(
        CatalogImportsCompanion.insert(
          catalogVersion: '2026.05.0',
          schemaVersion: 1,
          importedAt: DateTime.utc(2026, 5, 28),
        ),
      );
  await database
      .into(database.workoutGroups)
      .insert(
        WorkoutGroupsCompanion.insert(
          workoutGroupId: 'group-1',
          name: 'Push Day',
          sortOrder: 0,
        ),
      );
  await database
      .into(database.workoutGroupExerciseAssignments)
      .insert(
        WorkoutGroupExerciseAssignmentsCompanion.insert(
          assignmentId: 'assignment-1',
          workoutGroupId: 'group-1',
          exerciseSource: 'official',
          exerciseId: 'barbell-bench-press',
          exerciseDisplayNameSnapshot: 'Barbell Bench Press',
          catalogVersionSnapshot: const Value<String?>('2026.05.0'),
          position: 0,
        ),
      );
  await _insertWorkoutSet(database, id: 'set-1');
  await database
      .into(database.settingsProfiles)
      .insert(
        SettingsProfilesCompanion.insert(
          profileId: 'local',
          languageOverride: 'system',
          unitPreference: 'metric',
          themePreference: 'system',
          defaultRestSeconds: 90,
          focusProfile: 'balanced',
          trainingDaysPerWeek: 3,
          sessionDurationMinutes: 45,
        ),
      );
  await database
      .into(database.equipmentInventoryItems)
      .insert(
        EquipmentInventoryItemsCompanion.insert(
          profileId: 'local',
          equipment: 'bodyweight',
        ),
      );
  await database
      .into(database.onboardingStatuses)
      .insert(
        OnboardingStatusesCompanion.insert(
          statusId: 'local',
          completion: 'completed',
          updatedAt: DateTime.utc(2026, 5, 28),
        ),
      );
}

Future<void> _insertWorkoutSet(
  RepForgeDatabase database, {
  required String id,
  String exerciseSource = 'official',
  String exerciseId = 'barbell-bench-press',
  String exerciseDisplayNameSnapshot = 'Barbell Bench Press',
  String? catalogVersionSnapshot = '2026.05.0',
  int repetitions = 5,
  double loadKg = 80,
  String? setLabel,
}) async {
  await database.customInsert(
    '''
INSERT INTO workout_sets (
  workout_set_id,
  exercise_source,
  exercise_id,
  exercise_display_name_snapshot,
  catalog_version_snapshot,
  repetitions,
  load_kg,
  performed_at,
  set_label
)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
''',
    variables: <Variable<Object>>[
      Variable<String>(id),
      Variable<String>(exerciseSource),
      Variable<String>(exerciseId),
      Variable<String>(exerciseDisplayNameSnapshot),
      Variable<String>(catalogVersionSnapshot),
      Variable<int>(repetitions),
      Variable<double>(loadKg),
      Variable<DateTime>(DateTime.utc(2026, 5, 28, 12)),
      Variable<String>(setLabel),
    ],
  );
}
