import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
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
    final tables = await database
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'table' AND name = ?",
          variables: <Variable<String>>[const Variable<String>('workout_sets')],
        )
        .get();

    expect(tables, hasLength(1));
  });

  test('uses schema version 1', () {
    expect(database.schemaVersion, 1);
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

  test('accepts absent optional session and comment fields', () async {
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

    test('reject duplicate workout set ids', () async {
      await _insertSet(database);

      await expectLater(_insertSet(database), throwsA(isA<Exception>()));
    });
  });
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
        ),
      );
}
