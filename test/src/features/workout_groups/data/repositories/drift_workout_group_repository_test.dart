import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/exercise_catalog/data/importers/official_exercise_catalog_importer.dart';
import 'package:repforge/src/features/exercise_catalog/data/parsers/official_exercise_catalog_parser.dart';
import 'package:repforge/src/features/exercise_catalog/domain/exercise_catalog_domain.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';
import 'package:repforge/src/features/workout_groups/data/repositories/drift_workout_group_repository.dart';
import 'package:repforge/src/features/workout_groups/domain/workout_groups_domain.dart';
import 'package:repforge/src/shared/data/local/repforge_database.dart';

void main() {
  late RepForgeDatabase database;
  late DriftWorkoutGroupRepository repository;

  setUp(() {
    database = RepForgeDatabase(NativeDatabase.memory());
    repository = DriftWorkoutGroupRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('saves and finds a workout group with archivedAt', () async {
    final group = _group(
      id: 'push-day',
      name: 'Push Day',
      sortOrder: 1,
      archivedAt: DateTime.utc(2026, 5, 27, 18),
    );

    await repository.saveGroup(group);

    expect(await repository.findGroupById(WorkoutGroupId('push-day')), group);
  });

  test('returns null for missing workout group id', () async {
    expect(await repository.findGroupById(WorkoutGroupId('missing')), isNull);
  });

  test(
    'lists workout groups by sort order, name, then id with paging',
    () async {
      await repository.saveGroup(
        _group(id: 'pull-b', name: 'Pull Day', sortOrder: 1),
      );
      await repository.saveGroup(_group(id: 'legs', name: 'Leg Day'));
      await repository.saveGroup(
        _group(id: 'pull-a', name: 'Pull Day', sortOrder: 1),
      );
      await repository.saveGroup(
        _group(id: 'push', name: 'Push Day', sortOrder: 1),
      );

      final firstPage = await repository.listGroups(
        WorkoutGroupQuery(limit: 2, offset: 0),
      );
      final secondPage = await repository.listGroups(
        WorkoutGroupQuery(limit: 2, offset: 2),
      );

      expect(firstPage.totalCount, 4);
      expect(firstPage.hasMore, isTrue);
      expect(firstPage.items.map((group) => group.id.value), <String>[
        'legs',
        'pull-a',
      ]);
      expect(secondPage.items.map((group) => group.id.value), <String>[
        'pull-b',
        'push',
      ]);
    },
  );

  test('lists groups by search text and name sort', () async {
    await repository.saveGroup(
      _group(id: 'lower-a', name: 'Lower Strength', sortOrder: 2),
    );
    await repository.saveGroup(
      _group(id: 'push-a', name: 'Push Strength', sortOrder: 1),
    );
    await repository.saveGroup(_group(id: 'pull-a', name: 'Pull Hypertrophy'));

    final page = await repository.listGroups(
      WorkoutGroupQuery(
        limit: 10,
        offset: 0,
        searchText: 'strength',
        sort: WorkoutGroupListSort.name,
      ),
    );

    expect(page.totalCount, 2);
    expect(page.items.map((group) => group.id.value), <String>[
      'lower-a',
      'push-a',
    ]);
  });

  test(
    'excludes archived groups by default and includes them when requested',
    () async {
      await repository.saveGroup(_group(id: 'active', name: 'Active'));
      await repository.saveGroup(
        _group(
          id: 'archived',
          name: 'Archived',
          archivedAt: DateTime.utc(2026, 5, 28, 12),
        ),
      );

      final defaultPage = await repository.listGroups(
        WorkoutGroupQuery(limit: 10, offset: 0),
      );
      final includeArchivedPage = await repository.listGroups(
        WorkoutGroupQuery(limit: 10, offset: 0, includeArchived: true),
      );

      expect(defaultPage.items.map((group) => group.id.value), <String>[
        'active',
      ]);
      expect(defaultPage.totalCount, 1);
      expect(
        includeArchivedPage.items.map((group) => group.id.value),
        containsAll(<String>['active', 'archived']),
      );
      expect(includeArchivedPage.totalCount, 2);
    },
  );

  test(
    'archiveGroup does not mutate workout sets or official catalog',
    () async {
      await OfficialExerciseCatalogImporter(
        database,
      ).importCatalog(_bundledCatalog());
      await repository.saveGroup(_group(id: 'push-day', name: 'Push Day'));
      await repository.saveAssignment(
        _officialAssignment(id: 'assignment-1', position: 0),
      );
      await database
          .into(database.workoutSets)
          .insert(
            WorkoutSetsCompanion.insert(
              workoutSetId: 'set-1',
              exerciseSource: 'official',
              exerciseId: 'barbell_bench_press',
              exerciseDisplayNameSnapshot: 'Bench Press',
              catalogVersionSnapshot: const Value<String?>('2026.05.0'),
              repetitions: 5,
              loadKg: 100,
              performedAt: DateTime.utc(2026, 5, 27, 12),
            ),
          );

      await repository.archiveGroup(
        WorkoutGroupId('push-day'),
        DateTime.utc(2026, 5, 28, 12),
      );

      final archivedGroup = await repository.findGroupById(
        WorkoutGroupId('push-day'),
      );
      final defaultPage = await repository.listGroups(
        WorkoutGroupQuery(limit: 10, offset: 0),
      );

      expect(archivedGroup?.archivedAt, DateTime.utc(2026, 5, 28, 12));
      expect(defaultPage.items, isEmpty);
      expect(await database.select(database.workoutSets).get(), hasLength(1));
      expect(
        await database.select(database.officialExercises).get(),
        hasLength(15),
      );
      expect(
        await database.select(database.workoutGroupExerciseAssignments).get(),
        hasLength(1),
      );
    },
  );

  test(
    'saves official assignment and preserves stable snapshot data',
    () async {
      await repository.saveGroup(_group(id: 'push-day', name: 'Push Day'));

      final assignment = _officialAssignment(id: 'assignment-1', position: 0);

      await repository.saveAssignment(assignment);

      final page = await repository.listAssignments(
        WorkoutGroupId('push-day'),
        WorkoutGroupAssignmentQuery(limit: 10, offset: 0),
      );

      expect(page.items.single, assignment);
      expect(page.items.single.exerciseRef.id, 'barbell_bench_press');
      expect(page.items.single.exerciseRef.displayNameSnapshot, 'Bench Press');
      expect(page.items.single.exerciseRef.catalogVersionSnapshot, '2026.05.0');
    },
  );

  test('saves future custom assignment without catalog version', () async {
    await repository.saveGroup(_group(id: 'pull-day', name: 'Pull Day'));

    final assignment = WorkoutGroupExerciseAssignment(
      id: WorkoutGroupExerciseAssignmentId('custom-assignment-1'),
      workoutGroupId: WorkoutGroupId('pull-day'),
      exerciseRef: ExerciseRef.custom(
        id: CustomExerciseId('custom-row-1'),
        displayNameSnapshot: 'Home Row',
      ),
      position: AssignmentPosition(1),
    );

    await repository.saveAssignment(assignment);

    final page = await repository.listAssignments(
      WorkoutGroupId('pull-day'),
      WorkoutGroupAssignmentQuery(limit: 10, offset: 0),
    );

    expect(page.items.single, assignment);
    expect(page.items.single.exerciseRef.catalogVersionSnapshot, isNull);
  });

  test('rejects persisted custom assignments with catalog snapshots', () async {
    await database
        .into(database.workoutGroupExerciseAssignments)
        .insert(
          WorkoutGroupExerciseAssignmentsCompanion.insert(
            assignmentId: 'invalid-custom-assignment',
            workoutGroupId: 'pull-day',
            exerciseSource: 'custom',
            exerciseId: 'custom-row-1',
            exerciseDisplayNameSnapshot: 'Home Row',
            catalogVersionSnapshot: const Value<String?>('2026.05.0'),
            position: 0,
          ),
        );

    await expectLater(
      repository.listAssignments(
        WorkoutGroupId('pull-day'),
        WorkoutGroupAssignmentQuery(limit: 10, offset: 0),
      ),
      throwsA(
        isA<WorkoutGroupValidationException>().having(
          (error) => error.field,
          'field',
          'exerciseRef.catalogVersionSnapshot',
        ),
      ),
    );
  });

  test('lists assignments by position then assignment id', () async {
    await repository.saveGroup(_group(id: 'push-day', name: 'Push Day'));
    await repository.saveAssignment(
      _officialAssignment(id: 'assignment-c', position: 1),
    );
    await repository.saveAssignment(
      _officialAssignment(id: 'assignment-a', position: 0),
    );
    await repository.saveAssignment(
      _officialAssignment(id: 'assignment-b', position: 1),
    );

    final page = await repository.listAssignments(
      WorkoutGroupId('push-day'),
      WorkoutGroupAssignmentQuery(limit: 10, offset: 0),
    );

    expect(page.items.map((assignment) => assignment.id.value), <String>[
      'assignment-a',
      'assignment-b',
      'assignment-c',
    ]);
  });

  test(
    'removing assignment does not touch workout sets or official catalog',
    () async {
      await OfficialExerciseCatalogImporter(
        database,
      ).importCatalog(_bundledCatalog());
      await repository.saveGroup(_group(id: 'push-day', name: 'Push Day'));
      await repository.saveAssignment(
        _officialAssignment(id: 'assignment-1', position: 0),
      );
      await database
          .into(database.workoutSets)
          .insert(
            WorkoutSetsCompanion.insert(
              workoutSetId: 'set-1',
              exerciseSource: 'official',
              exerciseId: 'barbell_bench_press',
              exerciseDisplayNameSnapshot: 'Bench Press',
              catalogVersionSnapshot: const Value<String?>('2026.05.0'),
              repetitions: 5,
              loadKg: 100,
              performedAt: DateTime.utc(2026, 5, 27, 12),
            ),
          );

      await repository.removeAssignment(
        WorkoutGroupExerciseAssignmentId('assignment-1'),
      );

      final assignments = await database
          .select(database.workoutGroupExerciseAssignments)
          .get();
      final workoutSets = await database.select(database.workoutSets).get();
      final officialExercises = await database
          .select(database.officialExercises)
          .get();

      expect(assignments, isEmpty);
      expect(workoutSets, hasLength(1));
      expect(officialExercises, hasLength(15));
    },
  );

  test(
    'official catalog re-import does not overwrite group assignments',
    () async {
      final importer = OfficialExerciseCatalogImporter(database);
      await importer.importCatalog(_bundledCatalog());
      await repository.saveGroup(_group(id: 'push-day', name: 'Push Day'));
      await repository.saveAssignment(
        _officialAssignment(id: 'assignment-1', position: 0),
      );

      await importer.importCatalog(_bundledCatalog());

      final page = await repository.listAssignments(
        WorkoutGroupId('push-day'),
        WorkoutGroupAssignmentQuery(limit: 10, offset: 0),
      );

      expect(page.items.single.id.value, 'assignment-1');
      expect(page.items.single.exerciseRef.id, 'barbell_bench_press');
      expect(page.items.single.exerciseRef.displayNameSnapshot, 'Bench Press');
      expect(page.items.single.exerciseRef.catalogVersionSnapshot, '2026.05.0');
    },
  );
}

WorkoutGroup _group({
  required String id,
  required String name,
  int sortOrder = 0,
  DateTime? archivedAt,
}) {
  return WorkoutGroup(
    id: WorkoutGroupId(id),
    name: WorkoutGroupName(name),
    sortOrder: WorkoutGroupSortOrder(sortOrder),
    archivedAt: archivedAt,
  );
}

WorkoutGroupExerciseAssignment _officialAssignment({
  required String id,
  required int position,
}) {
  return WorkoutGroupExerciseAssignment(
    id: WorkoutGroupExerciseAssignmentId(id),
    workoutGroupId: WorkoutGroupId('push-day'),
    exerciseRef: ExerciseRef.official(
      id: OfficialExerciseId('barbell_bench_press'),
      displayNameSnapshot: 'Bench Press',
      catalogVersionSnapshot: '2026.05.0',
    ),
    position: AssignmentPosition(position),
  );
}

OfficialExerciseCatalog _bundledCatalog() {
  return const OfficialExerciseCatalogParser().parseString(
    File('assets/catalog/official_exercises_v1.json').readAsStringSync(),
  );
}
