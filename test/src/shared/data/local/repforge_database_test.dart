import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/shared/data/local/repforge_database.dart';

void main() {
  late RepForgeDatabase database;

  setUp(() {
    database = RepForgeDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('creates the schema in memory', () async {
    final tables = await database.customSelect('''
          SELECT name
          FROM sqlite_master
          WHERE type = 'table'
          AND name NOT LIKE 'sqlite_%'
          ORDER BY name
          ''').get();

    expect(tables.map((row) => row.read<String>('name')), _expectedTableNames);
  });

  test('uses schema version 8', () {
    expect(database.schemaVersion, 8);
  });

  test('current schema validates against Drift metadata', () async {
    await expectLater(database.validateDatabaseSchema(), completes);
  });

  test('creates workout-set performance indexes', () async {
    final indexes = await database.customSelect('''
          SELECT name
          FROM sqlite_master
          WHERE type = 'index'
          AND tbl_name = 'workout_sets'
          ORDER BY name
          ''').get();

    expect(
      indexes.map((row) => row.read<String>('name')),
      containsAll(<String>[
        'workout_sets_exercise_timeline_idx',
        'workout_sets_history_order_idx',
        'workout_sets_session_order_idx',
      ]),
    );
  });

  test('migrates a non-empty schema version 1 database additively', () async {
    await database.close();
    database = RepForgeDatabase(
      NativeDatabase.memory(setup: _createLegacyVersionOneDatabase),
    );

    final migratedSet = await database.select(database.workoutSets).getSingle();
    final tables = await database.customSelect('''
            SELECT name
            FROM sqlite_master
            WHERE type = 'table'
            AND name NOT LIKE 'sqlite_%'
            ORDER BY name
            ''').get();
    final userVersion = await database
        .customSelect('PRAGMA user_version')
        .getSingle();

    expect(migratedSet.workoutSetId, 'legacy-set-1');
    expect(migratedSet.exerciseDisplayNameSnapshot, 'Legacy Bench');
    expect(migratedSet.setLabel, isNull);
    expect(tables.map((row) => row.read<String>('name')), _expectedTableNames);
    expect(userVersion.read<int>('user_version'), 8);
    await expectLater(database.validateDatabaseSchema(), completes);
  });

  test('accepts an official exercise workout set with snapshots', () async {
    final performedAt = DateTime.utc(2026, 5, 27, 10, 30);

    await database
        .into(database.workoutSets)
        .insert(
          WorkoutSetsCompanion.insert(
            workoutSetId: 'set-official-1',
            exerciseSource: 'official',
            exerciseId: 'barbell-bench-press',
            exerciseDisplayNameSnapshot: 'Barbell Bench Press',
            catalogVersionSnapshot: const Value<String?>('2026.05.0'),
            workoutSessionId: const Value<String?>('session-1'),
            repetitions: 5,
            loadKg: 100,
            performedAt: performedAt,
            comment: const Value<String?>('Top set'),
            setLabel: const Value<String?>('personalRecord'),
          ),
        );

    final row = await database.select(database.workoutSets).getSingle();

    expect(row.workoutSetId, 'set-official-1');
    expect(row.exerciseSource, 'official');
    expect(row.exerciseId, 'barbell-bench-press');
    expect(row.exerciseDisplayNameSnapshot, 'Barbell Bench Press');
    expect(row.catalogVersionSnapshot, '2026.05.0');
    expect(row.workoutSessionId, 'session-1');
    expect(row.repetitions, 5);
    expect(row.loadKg, 100);
    expect(row.performedAt.toUtc(), performedAt);
    expect(row.comment, 'Top set');
    expect(row.setLabel, 'personalRecord');
  });

  test('accepts a custom exercise workout set without catalog data', () async {
    await database
        .into(database.workoutSets)
        .insert(
          WorkoutSetsCompanion.insert(
            workoutSetId: 'set-custom-1',
            exerciseSource: 'custom',
            exerciseId: 'custom-row-1',
            exerciseDisplayNameSnapshot: 'Cable Row Variant',
            repetitions: 8,
            loadKg: 42.5,
            performedAt: DateTime.utc(2026, 5, 27, 11),
          ),
        );

    final row = await database.select(database.workoutSets).getSingle();

    expect(row.exerciseSource, 'custom');
    expect(row.exerciseId, 'custom-row-1');
    expect(row.exerciseDisplayNameSnapshot, 'Cable Row Variant');
    expect(row.catalogVersionSnapshot, isNull);
  });

  test('accepts absent optional session, comment, and label fields', () async {
    await database
        .into(database.workoutSets)
        .insert(
          WorkoutSetsCompanion.insert(
            workoutSetId: 'set-without-optionals',
            exerciseSource: 'official',
            exerciseId: 'deadlift',
            exerciseDisplayNameSnapshot: 'Deadlift',
            catalogVersionSnapshot: const Value<String?>('2026.05.0'),
            repetitions: 3,
            loadKg: 140,
            performedAt: DateTime.utc(2026, 5, 27, 12),
          ),
        );

    final row = await database.select(database.workoutSets).getSingle();

    expect(row.workoutSessionId, isNull);
    expect(row.comment, isNull);
    expect(row.setLabel, isNull);
  });

  group('constraints', () {
    test('reject invalid exercise source', () async {
      await expectLater(
        _insertSet(database, exerciseSource: 'remote'),
        throwsA(isA<Exception>()),
      );
    });

    test('reject zero repetitions', () async {
      await expectLater(
        _insertSet(database, repetitions: 0),
        throwsA(isA<Exception>()),
      );
    });

    test('reject negative load', () async {
      await expectLater(
        _insertSet(database, loadKg: -1),
        throwsA(isA<Exception>()),
      );
    });

    test('reject empty required snapshot values', () async {
      await expectLater(
        _insertSet(database, exerciseDisplayNameSnapshot: ''),
        throwsA(isA<Exception>()),
      );
    });

    test('reject empty optional text when present', () async {
      await expectLater(
        _insertSet(database, comment: const Value<String?>('')),
        throwsA(isA<Exception>()),
      );
    });

    test('reject unsupported set labels', () async {
      await expectLater(
        _insertSet(database, setLabel: const Value<String?>('tempo')),
        throwsA(isA<Exception>()),
      );
    });

    test('reject duplicate workout set ids', () async {
      await _insertSet(database);

      await expectLater(_insertSet(database), throwsA(isA<Exception>()));
    });

    test('reject invalid catalog metadata', () async {
      await expectLater(
        database
            .into(database.catalogImports)
            .insert(
              CatalogImportsCompanion.insert(
                catalogVersion: '',
                schemaVersion: 0,
                importedAt: DateTime.utc(2026, 5, 28),
              ),
            ),
        throwsA(isA<Exception>()),
      );
    });

    test('reject invalid workout group rows', () async {
      await expectLater(
        database
            .into(database.workoutGroups)
            .insert(
              WorkoutGroupsCompanion.insert(
                workoutGroupId: '',
                name: '',
                sortOrder: -1,
              ),
            ),
        throwsA(isA<Exception>()),
      );
    });

    test('reject invalid workout group assignments', () async {
      await expectLater(
        database
            .into(database.workoutGroupExerciseAssignments)
            .insert(
              WorkoutGroupExerciseAssignmentsCompanion.insert(
                assignmentId: '',
                workoutGroupId: '',
                exerciseSource: 'remote',
                exerciseId: '',
                exerciseDisplayNameSnapshot: '',
                position: -1,
              ),
            ),
        throwsA(isA<Exception>()),
      );
    });

    test('reject invalid settings values', () async {
      await expectLater(
        database
            .into(database.settingsProfiles)
            .insert(
              SettingsProfilesCompanion.insert(
                profileId: '',
                languageOverride: 'fr',
                unitPreference: 'metric',
                themePreference: 'system',
                defaultRestSeconds: 0,
                focusProfile: 'balanced',
                trainingDaysPerWeek: 8,
                sessionDurationMinutes: 10,
              ),
            ),
        throwsA(isA<Exception>()),
      );
    });

    test('reject invalid equipment load constraints', () async {
      await expectLater(
        database
            .into(database.equipmentLoadConstraints)
            .insert(
              EquipmentLoadConstraintsCompanion.insert(
                profileId: '',
                equipment: 'kettlebell',
                maxLoadKg: const Value<double?>(-1),
                incrementKg: const Value<double?>(0),
              ),
            ),
        throwsA(isA<Exception>()),
      );
    });

    test('reject invalid onboarding status', () async {
      await expectLater(
        database
            .into(database.onboardingStatuses)
            .insert(
              OnboardingStatusesCompanion.insert(
                statusId: '',
                completion: 'maybe',
                updatedAt: DateTime.utc(2026, 5, 28),
              ),
            ),
        throwsA(isA<Exception>()),
      );
    });
  });
}

const List<String> _expectedTableNames = <String>[
  'catalog_imports',
  'equipment_inventory_items',
  'equipment_load_constraints',
  'official_exercise_equipment_tags',
  'official_exercise_movement_patterns',
  'official_exercise_muscle_groups',
  'official_exercises',
  'onboarding_statuses',
  'settings_profiles',
  'workout_group_exercise_assignments',
  'workout_groups',
  'workout_sets',
];

void _createLegacyVersionOneDatabase(Object rawDatabase) {
  final database = rawDatabase as dynamic;
  // ignore: avoid_dynamic_calls
  database
    ..execute('''
CREATE TABLE workout_sets (
  workout_set_id TEXT NOT NULL CHECK (length(workout_set_id) > 0),
  exercise_source TEXT NOT NULL CHECK (
    exercise_source IN ('official', 'custom')
  ),
  exercise_id TEXT NOT NULL CHECK (length(exercise_id) > 0),
  exercise_display_name_snapshot TEXT NOT NULL CHECK (
    length(exercise_display_name_snapshot) > 0
  ),
  catalog_version_snapshot TEXT NULL CHECK (
    catalog_version_snapshot IS NULL OR length(catalog_version_snapshot) > 0
  ),
  workout_session_id TEXT NULL CHECK (
    workout_session_id IS NULL OR length(workout_session_id) > 0
  ),
  repetitions INTEGER NOT NULL CHECK (repetitions > 0),
  load_kg REAL NOT NULL CHECK (load_kg >= 0),
  performed_at INTEGER NOT NULL,
  comment TEXT NULL CHECK (comment IS NULL OR length(comment) > 0),
  PRIMARY KEY (workout_set_id)
)
''')
    ..execute('''
INSERT INTO workout_sets (
  workout_set_id,
  exercise_source,
  exercise_id,
  exercise_display_name_snapshot,
  catalog_version_snapshot,
  workout_session_id,
  repetitions,
  load_kg,
  performed_at,
  comment
)
VALUES (
  'legacy-set-1',
  'official',
  'barbell-bench-press',
  'Legacy Bench',
  '2026.05.0',
  'legacy-session',
  5,
  80,
  1780056000000,
  'Preserve me'
)
''')
    ..execute('PRAGMA user_version = 1');
}

Future<int> _insertSet(
  RepForgeDatabase database, {
  String workoutSetId = 'set-constraint',
  String exerciseSource = 'official',
  String exerciseId = 'squat',
  String exerciseDisplayNameSnapshot = 'Squat',
  Value<String?> catalogVersionSnapshot = const Value<String?>('2026.05.0'),
  int repetitions = 5,
  double loadKg = 100,
  Value<String?> comment = const Value<String?>.absent(),
  Value<String?> setLabel = const Value<String?>.absent(),
}) {
  return database
      .into(database.workoutSets)
      .insert(
        WorkoutSetsCompanion.insert(
          workoutSetId: workoutSetId,
          exerciseSource: exerciseSource,
          exerciseId: exerciseId,
          exerciseDisplayNameSnapshot: exerciseDisplayNameSnapshot,
          catalogVersionSnapshot: catalogVersionSnapshot,
          repetitions: repetitions,
          loadKg: loadKg,
          performedAt: DateTime.utc(2026, 5, 27, 12),
          comment: comment,
          setLabel: setLabel,
        ),
      );
}
