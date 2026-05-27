import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/exercise_catalog/data/importers/official_exercise_catalog_importer.dart';
import 'package:repforge/src/features/exercise_catalog/data/parsers/official_exercise_catalog_parser.dart';
import 'package:repforge/src/features/exercise_catalog/data/repositories/drift_exercise_catalog_repository.dart';
import 'package:repforge/src/features/exercise_catalog/domain/exercise_catalog_domain.dart';
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

    expect(exerciseRows, hasLength(6));
    expect(importRows, hasLength(1));
    expect(importRows.single.catalogVersion, '2026.05.0');
  });

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

  test('queries official exercises with limit and offset', () async {
    await importer.importCatalog(_bundledCatalog());

    final firstPage = await repository.findOfficialExercises(
      ExerciseCatalogQuery(limit: 2, offset: 0),
    );
    final secondPage = await repository.findOfficialExercises(
      ExerciseCatalogQuery(limit: 2, offset: 2),
    );

    expect(firstPage.items, hasLength(2));
    expect(firstPage.totalCount, 6);
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
        ExerciseCatalogQuery(limit: 10, offset: 0),
      );

      expect(page.items.map((exercise) => exercise.englishName), <String>[
        'Barbell Back Squat',
        'Barbell Bench Press',
        'Barbell Bent-Over Row',
        'Barbell Deadlift',
        'Barbell Overhead Press',
        'Pull-Up',
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
    expect(musclePage.items.single.id.value, 'barbell_bench_press');
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
}

OfficialExerciseCatalog _bundledCatalog() {
  return const OfficialExerciseCatalogParser().parseString(
    File('assets/catalog/official_exercises_v1.json').readAsStringSync(),
  );
}
