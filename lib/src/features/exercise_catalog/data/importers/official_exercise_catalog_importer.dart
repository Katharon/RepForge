import 'package:repforge/src/features/exercise_catalog/data/mappers/official_exercise_mapper.dart';
import 'package:repforge/src/features/exercise_catalog/domain/exercise_catalog_domain.dart';
import 'package:repforge/src/shared/data/local/repforge_database.dart';

final class OfficialExerciseCatalogImporter {
  const OfficialExerciseCatalogImporter(this._database);

  final RepForgeDatabase _database;

  Future<void> importCatalog(OfficialExerciseCatalog catalog) async {
    await _database.transaction(() async {
      final alreadyImported =
          await (_database.select(_database.catalogImports)
                ..where(($CatalogImportsTable table) {
                  return table.catalogVersion.equals(
                    catalog.catalogVersion.value,
                  );
                }))
              .getSingleOrNull();

      if (alreadyImported != null) {
        return;
      }

      for (final exercise in catalog.exercises) {
        await _database
            .into(_database.officialExercises)
            .insertOnConflictUpdate(
              OfficialExerciseMapper.toExerciseCompanion(
                exercise,
                catalog.schemaVersion,
              ),
            );

        await _replaceExerciseTags(exercise);
      }

      await _database
          .into(_database.catalogImports)
          .insert(
            CatalogImportsCompanion.insert(
              catalogVersion: catalog.catalogVersion.value,
              schemaVersion: catalog.schemaVersion,
              importedAt: DateTime.now().toUtc(),
            ),
          );
    });
  }

  Future<void> _replaceExerciseTags(OfficialExercise exercise) async {
    final catalogId = exercise.id.value;

    await (_database.delete(_database.officialExerciseEquipmentTags)
          ..where(($OfficialExerciseEquipmentTagsTable table) {
            return table.catalogId.equals(catalogId);
          }))
        .go();
    await (_database.delete(_database.officialExerciseMovementPatterns)
          ..where(($OfficialExerciseMovementPatternsTable table) {
            return table.catalogId.equals(catalogId);
          }))
        .go();
    await (_database.delete(_database.officialExerciseMuscleGroups)
          ..where(($OfficialExerciseMuscleGroupsTable table) {
            return table.catalogId.equals(catalogId);
          }))
        .go();

    for (final tag in exercise.equipment) {
      await _database
          .into(_database.officialExerciseEquipmentTags)
          .insert(
            OfficialExerciseEquipmentTagsCompanion.insert(
              catalogId: catalogId,
              equipmentTag: tag.value,
            ),
          );
    }

    for (final pattern in exercise.movementPatterns) {
      await _database
          .into(_database.officialExerciseMovementPatterns)
          .insert(
            OfficialExerciseMovementPatternsCompanion.insert(
              catalogId: catalogId,
              movementPattern: pattern.value,
            ),
          );
    }

    await _insertMuscles(
      catalogId: catalogId,
      role: OfficialExerciseMapper.primaryMuscleRole,
      muscles: exercise.primaryMuscles,
    );
    await _insertMuscles(
      catalogId: catalogId,
      role: OfficialExerciseMapper.secondaryMuscleRole,
      muscles: exercise.secondaryMuscles,
    );
  }

  Future<void> _insertMuscles({
    required String catalogId,
    required String role,
    required Iterable<MuscleGroup> muscles,
  }) async {
    for (final muscle in muscles) {
      await _database
          .into(_database.officialExerciseMuscleGroups)
          .insert(
            OfficialExerciseMuscleGroupsCompanion.insert(
              catalogId: catalogId,
              muscleGroup: muscle.value,
              role: role,
            ),
          );
    }
  }
}
