import 'package:repforge/src/features/exercise_catalog/domain/exercise_catalog_domain.dart';
import 'package:repforge/src/features/training_log/domain/value_objects/stable_ids.dart';
import 'package:repforge/src/shared/data/local/repforge_database.dart';

final class OfficialExerciseMapper {
  const OfficialExerciseMapper._();

  static const String primaryMuscleRole = 'primary';
  static const String secondaryMuscleRole = 'secondary';

  static OfficialExercisesCompanion toExerciseCompanion(
    OfficialExercise exercise,
    int schemaVersion,
  ) {
    return OfficialExercisesCompanion.insert(
      catalogId: exercise.id.value,
      catalogVersion: exercise.catalogVersion.value,
      schemaVersion: schemaVersion,
      englishName: exercise.englishName,
      germanName: exercise.germanName,
    );
  }

  static OfficialExercise toDomain({
    required OfficialExerciseRow row,
    required Iterable<OfficialExerciseEquipmentTagRow> equipment,
    required Iterable<OfficialExerciseMovementPatternRow> movementPatterns,
    required Iterable<OfficialExerciseMuscleGroupRow> muscleGroups,
  }) {
    return OfficialExercise(
      id: OfficialExerciseId(row.catalogId),
      catalogVersion: CatalogVersion(row.catalogVersion),
      englishName: row.englishName,
      germanName: row.germanName,
      equipment: equipment.map((row) => EquipmentTag(row.equipmentTag)),
      movementPatterns: movementPatterns.map(
        (row) => MovementPattern(row.movementPattern),
      ),
      primaryMuscles: muscleGroups
          .where((row) => row.role == primaryMuscleRole)
          .map((row) => MuscleGroup(row.muscleGroup)),
      secondaryMuscles: muscleGroups
          .where((row) => row.role == secondaryMuscleRole)
          .map((row) => MuscleGroup(row.muscleGroup)),
    );
  }
}
