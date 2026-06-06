import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/exercise_catalog/data/importers/official_exercise_catalog_importer.dart';
import 'package:repforge/src/features/exercise_catalog/data/parsers/official_exercise_catalog_parser.dart';
import 'package:repforge/src/features/exercise_catalog/data/repositories/drift_exercise_catalog_repository.dart';
import 'package:repforge/src/features/exercise_catalog/domain/exercise_catalog_domain.dart';
import 'package:repforge/src/features/training_log/domain/value_objects/stable_ids.dart';
import 'package:repforge/src/shared/data/local/repforge_database.dart';

void main() {
  late RepForgeDatabase database;
  late OfficialExerciseCatalogImporter importer;
  late DriftExerciseCatalogRepository repository;

  setUp(() {
    database = RepForgeDatabase(NativeDatabase.memory());
    importer = OfficialExerciseCatalogImporter(database);
    repository = DriftExerciseCatalogRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('imports the official catalog idempotently', () async {
    final catalog = _bundledCatalog();

    await importer.importCatalog(catalog);
    await importer.importCatalog(catalog);

    final exerciseRows = await database
        .select(database.officialExercises)
        .get();
    final importRows = await database.select(database.catalogImports).get();

    expect(exerciseRows, hasLength(15));
    expect(importRows, hasLength(1));
    expect(importRows.single.catalogVersion, '2026.06.0');
  });

  test(
    'imports a newer official catalog version when the version changes',
    () async {
      await importer.importCatalog(
        _singleExerciseCatalog(version: '2026.05.0'),
      );

      await importer.importCatalog(_bundledCatalog());

      final exerciseRows = await database
          .select(database.officialExercises)
          .get();
      final importRows = await database.select(database.catalogImports).get();

      expect(exerciseRows, hasLength(15));
      expect(
        importRows.map((row) => row.catalogVersion),
        containsAll(<String>['2026.05.0', '2026.06.0']),
      );
    },
  );

  test('official catalog import does not touch workout sets', () async {
    await database
        .into(database.workoutSets)
        .insert(
          WorkoutSetsCompanion.insert(
            workoutSetId: 'set-before-catalog-import',
            exerciseSource: 'official',
            exerciseId: 'barbell_bench_press',
            exerciseDisplayNameSnapshot: 'Barbell Bench Press',
            catalogVersionSnapshot: const Value<String?>('2026.05.0'),
            repetitions: 5,
            loadKg: 100,
            performedAt: DateTime.utc(2026, 5, 27, 10),
          ),
        );

    await importer.importCatalog(_bundledCatalog());

    final workoutSets = await database.select(database.workoutSets).get();

    expect(workoutSets, hasLength(1));
    expect(workoutSets.single.workoutSetId, 'set-before-catalog-import');
    expect(
      workoutSets.single.exerciseDisplayNameSnapshot,
      'Barbell Bench Press',
    );
  });

  test(
    'official catalog import does not touch group assignment snapshots',
    () async {
      await database
          .into(database.workoutGroups)
          .insert(
            WorkoutGroupsCompanion.insert(
              workoutGroupId: 'push-day',
              name: 'Push Day',
              sortOrder: 0,
            ),
          );
      await database
          .into(database.workoutGroupExerciseAssignments)
          .insert(
            WorkoutGroupExerciseAssignmentsCompanion.insert(
              assignmentId: 'bench-assignment',
              workoutGroupId: 'push-day',
              exerciseSource: 'official',
              exerciseId: 'barbell_bench_press',
              exerciseDisplayNameSnapshot: 'Bench Press Snapshot',
              catalogVersionSnapshot: const Value<String?>('2026.05.0'),
              position: 0,
            ),
          );

      await importer.importCatalog(_bundledCatalog());

      final assignments = await database
          .select(database.workoutGroupExerciseAssignments)
          .get();

      expect(assignments, hasLength(1));
      expect(assignments.single.assignmentId, 'bench-assignment');
      expect(
        assignments.single.exerciseDisplayNameSnapshot,
        'Bench Press Snapshot',
      );
      expect(assignments.single.catalogVersionSnapshot, '2026.05.0');
    },
  );

  test('queries official exercises with limit and offset', () async {
    await importer.importCatalog(_bundledCatalog());

    final firstPage = await repository.findOfficialExercises(
      ExerciseCatalogQuery(limit: 2, offset: 0),
    );
    final secondPage = await repository.findOfficialExercises(
      ExerciseCatalogQuery(limit: 2, offset: 2),
    );

    expect(firstPage.items, hasLength(2));
    expect(firstPage.totalCount, 15);
    expect(firstPage.hasMore, isTrue);
    expect(secondPage.items, hasLength(2));
    expect(
      secondPage.items.map((exercise) => exercise.id.value),
      isNot(contains(firstPage.items.first.id.value)),
    );
  });

  test(
    'orders catalog queries deterministically by English name and id',
    () async {
      await importer.importCatalog(_bundledCatalog());

      final page = await repository.findOfficialExercises(
        ExerciseCatalogQuery(limit: 20, offset: 0),
      );

      expect(page.items.map((exercise) => exercise.englishName), <String>[
        'Barbell Back Squat',
        'Barbell Bench Press',
        'Barbell Bent-Over Row',
        'Barbell Deadlift',
        'Barbell Overhead Press',
        'Cable Triceps Pushdown',
        'Dumbbell Bench Press',
        'Dumbbell Biceps Curl',
        'Dumbbell Goblet Squat',
        'Dumbbell Lunge',
        'Dumbbell Shoulder Press',
        'Lat Pulldown',
        'Pull-Up',
        'Romanian Deadlift',
        'Seated Cable Row',
      ]);
    },
  );

  test('filters by search text, equipment, and muscle group', () async {
    await importer.importCatalog(_bundledCatalog());

    final searchPage = await repository.findOfficialExercises(
      ExerciseCatalogQuery(limit: 10, offset: 0, searchText: 'Klimmzug'),
    );
    final equipmentPage = await repository.findOfficialExercises(
      ExerciseCatalogQuery(
        limit: 10,
        offset: 0,
        equipment: <EquipmentTag>[EquipmentTag('pull_up_bar')],
      ),
    );
    final musclePage = await repository.findOfficialExercises(
      ExerciseCatalogQuery(
        limit: 10,
        offset: 0,
        muscles: <MuscleGroup>[MuscleGroup('chest')],
      ),
    );

    expect(searchPage.items.single.id.value, 'bodyweight_pull_up');
    expect(equipmentPage.items.single.id.value, 'bodyweight_pull_up');
    expect(
      musclePage.items.map((exercise) => exercise.id.value),
      containsAll(<String>['barbell_bench_press', 'dumbbell_bench_press']),
    );
  });

  test('rejects invalid catalog pagination inputs', () {
    expect(
      () => ExerciseCatalogQuery(limit: 0, offset: 0),
      throwsA(isA<CatalogValidationException>()),
    );
    expect(
      () => ExerciseCatalogQuery(limit: 1, offset: -1),
      throwsA(isA<CatalogValidationException>()),
    );
  });

  test('custom exercise can be created locally and queried', () async {
    final exercise = _customExercise(id: 'custom-cable-fly');

    await repository.saveCustomExercise(exercise);

    final found = await repository.findCustomExerciseById(
      CustomExerciseId('custom-cable-fly'),
    );
    final page = await repository.listCustomExercises(
      CustomExerciseQuery(limit: 10, offset: 0),
    );

    expect(found, exercise);
    expect(page.items.single.name, 'Cable Fly');
    expect(page.items.single.primaryMuscles.single.value, 'chest');
  });

  test('custom exercise can be edited without changing stable id', () async {
    await repository.saveCustomExercise(_customExercise(id: 'custom-row'));

    await repository.saveCustomExercise(
      _customExercise(
        id: 'custom-row',
        name: 'Cable Fly Updated',
        notes: 'Lower cable angle',
        updatedAt: DateTime.utc(2026, 6, 6, 12),
      ),
    );

    final found = await repository.findCustomExerciseById(
      CustomExerciseId('custom-row'),
    );

    expect(found?.id, CustomExerciseId('custom-row'));
    expect(found?.name, 'Cable Fly Updated');
    expect(found?.notes, 'Lower cable angle');
  });

  test(
    'custom exercise can be archived without deleting workout snapshots',
    () async {
      await repository.saveCustomExercise(_customExercise(id: 'custom-row'));
      await database
          .into(database.workoutSets)
          .insert(
            WorkoutSetsCompanion.insert(
              workoutSetId: 'set-custom',
              exerciseSource: 'custom',
              exerciseId: 'custom-row',
              exerciseDisplayNameSnapshot: 'Cable Fly Snapshot',
              repetitions: 12,
              loadKg: 25,
              performedAt: DateTime.utc(2026, 6, 6, 9),
            ),
          );

      await repository.archiveCustomExercise(
        CustomExerciseId('custom-row'),
        DateTime.utc(2026, 6, 6, 13),
      );

      final activePage = await repository.listCustomExercises(
        CustomExerciseQuery(limit: 10, offset: 0),
      );
      final archivedPage = await repository.listCustomExercises(
        CustomExerciseQuery(limit: 10, offset: 0, includeArchived: true),
      );
      final workoutSets = await database.select(database.workoutSets).get();

      expect(activePage.items, isEmpty);
      expect(
        archivedPage.items.single.archivedAt,
        DateTime.utc(2026, 6, 6, 13),
      );
      expect(
        workoutSets.single.exerciseDisplayNameSnapshot,
        'Cable Fly Snapshot',
      );
    },
  );

  test('custom exercise search includes metadata tags', () async {
    await repository.saveCustomExercise(
      _customExercise(
        id: 'custom-hinge',
        name: 'Banded Good Morning',
        primaryMuscles: <MuscleGroup>[MuscleGroup('hamstrings')],
        movementPatterns: <MovementPattern>[MovementPattern('hinge')],
      ),
    );

    final page = await repository.listCustomExercises(
      CustomExerciseQuery(limit: 10, offset: 0, searchText: 'hinge'),
    );

    expect(page.items.single.id, CustomExerciseId('custom-hinge'));
  });

  test('saving custom exercises does not edit official catalog rows', () async {
    await importer.importCatalog(_singleExerciseCatalog(version: '2026.06.0'));
    final before = await repository.findOfficialExerciseById(
      OfficialExerciseId('barbell_bench_press'),
    );

    await repository.saveCustomExercise(
      _customExercise(id: 'barbell_bench_press', name: 'My Bench Variant'),
    );

    final after = await repository.findOfficialExerciseById(
      OfficialExerciseId('barbell_bench_press'),
    );
    final custom = await repository.findCustomExerciseById(
      CustomExerciseId('barbell_bench_press'),
    );

    expect(after, before);
    expect(custom?.name, 'My Bench Variant');
  });
}

OfficialExerciseCatalog _bundledCatalog() {
  return const OfficialExerciseCatalogParser().parseString(
    File('assets/catalog/official_exercises_v1.json').readAsStringSync(),
  );
}

CustomExercise _customExercise({
  required String id,
  String name = 'Cable Fly',
  String? notes = 'Slow tempo',
  List<MuscleGroup>? primaryMuscles,
  List<MuscleGroup>? secondaryMuscles,
  List<EquipmentTag>? equipment,
  List<MovementPattern>? movementPatterns,
  DateTime? updatedAt,
}) {
  return CustomExercise(
    id: CustomExerciseId(id),
    name: name,
    notes: notes,
    primaryMuscles: primaryMuscles ?? <MuscleGroup>[MuscleGroup('chest')],
    secondaryMuscles:
        secondaryMuscles ?? <MuscleGroup>[MuscleGroup('front_deltoids')],
    equipment: equipment ?? <EquipmentTag>[EquipmentTag('cable')],
    movementPatterns:
        movementPatterns ??
        <MovementPattern>[MovementPattern('horizontal_push')],
    createdAt: DateTime.utc(2026, 6, 6, 10),
    updatedAt: updatedAt ?? DateTime.utc(2026, 6, 6, 10),
  );
}

OfficialExerciseCatalog _singleExerciseCatalog({required String version}) {
  return OfficialExerciseCatalog(
    catalogVersion: CatalogVersion(version),
    schemaVersion: 1,
    exercises: <OfficialExercise>[
      OfficialExercise(
        id: OfficialExerciseId('barbell_bench_press'),
        catalogVersion: CatalogVersion(version),
        englishName: 'Barbell Bench Press',
        germanName: 'Bankdruecken mit Langhantel',
        equipment: <EquipmentTag>[
          EquipmentTag('barbell'),
          EquipmentTag('bench'),
        ],
        movementPatterns: <MovementPattern>[MovementPattern('horizontal_push')],
        primaryMuscles: <MuscleGroup>[MuscleGroup('chest')],
        secondaryMuscles: <MuscleGroup>[MuscleGroup('triceps')],
      ),
    ],
  );
}
