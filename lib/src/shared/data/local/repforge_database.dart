import 'package:drift/drift.dart';

part 'repforge_database.g.dart';

@DataClassName('WorkoutSetRow')
class WorkoutSets extends Table {
  TextColumn get workoutSetId =>
      text().customConstraint('NOT NULL CHECK (length(workout_set_id) > 0)')();

  TextColumn get exerciseSource => text().customConstraint(
    "NOT NULL CHECK (exercise_source IN ('official', 'custom'))",
  )();

  TextColumn get exerciseId =>
      text().customConstraint('NOT NULL CHECK (length(exercise_id) > 0)')();

  TextColumn get exerciseDisplayNameSnapshot => text().customConstraint(
    'NOT NULL CHECK (length(exercise_display_name_snapshot) > 0)',
  )();

  TextColumn get catalogVersionSnapshot => text().nullable().customConstraint(
    'NULL CHECK ('
    'catalog_version_snapshot IS NULL OR '
    'length(catalog_version_snapshot) > 0'
    ')',
  )();

  TextColumn get workoutSessionId => text().nullable().customConstraint(
    'NULL CHECK ('
    'workout_session_id IS NULL OR '
    'length(workout_session_id) > 0'
    ')',
  )();

  IntColumn get repetitions =>
      integer().customConstraint('NOT NULL CHECK (repetitions > 0)')();

  RealColumn get loadKg =>
      real().customConstraint('NOT NULL CHECK (load_kg >= 0)')();

  DateTimeColumn get performedAt => dateTime().customConstraint('NOT NULL')();

  TextColumn get comment => text().nullable().customConstraint(
    'NULL CHECK (comment IS NULL OR length(comment) > 0)',
  )();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{workoutSetId};
}

@DataClassName('OfficialExerciseRow')
class OfficialExercises extends Table {
  TextColumn get catalogId =>
      text().customConstraint('NOT NULL CHECK (length(catalog_id) > 0)')();

  TextColumn get catalogVersion =>
      text().customConstraint('NOT NULL CHECK (length(catalog_version) > 0)')();

  IntColumn get schemaVersion =>
      integer().customConstraint('NOT NULL CHECK (schema_version > 0)')();

  TextColumn get englishName =>
      text().customConstraint('NOT NULL CHECK (length(english_name) > 0)')();

  TextColumn get germanName =>
      text().customConstraint('NOT NULL CHECK (length(german_name) > 0)')();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{catalogId};
}

@DataClassName('OfficialExerciseEquipmentTagRow')
class OfficialExerciseEquipmentTags extends Table {
  TextColumn get catalogId =>
      text().customConstraint('NOT NULL CHECK (length(catalog_id) > 0)')();

  TextColumn get equipmentTag =>
      text().customConstraint('NOT NULL CHECK (length(equipment_tag) > 0)')();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{
    catalogId,
    equipmentTag,
  };
}

@DataClassName('OfficialExerciseMovementPatternRow')
class OfficialExerciseMovementPatterns extends Table {
  TextColumn get catalogId =>
      text().customConstraint('NOT NULL CHECK (length(catalog_id) > 0)')();

  TextColumn get movementPattern => text().customConstraint(
    'NOT NULL CHECK (length(movement_pattern) > 0)',
  )();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{
    catalogId,
    movementPattern,
  };
}

@DataClassName('OfficialExerciseMuscleGroupRow')
class OfficialExerciseMuscleGroups extends Table {
  TextColumn get catalogId =>
      text().customConstraint('NOT NULL CHECK (length(catalog_id) > 0)')();

  TextColumn get muscleGroup =>
      text().customConstraint('NOT NULL CHECK (length(muscle_group) > 0)')();

  TextColumn get role => text().customConstraint(
    "NOT NULL CHECK (role IN ('primary', 'secondary'))",
  )();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{
    catalogId,
    muscleGroup,
    role,
  };
}

@DataClassName('CatalogImportRow')
class CatalogImports extends Table {
  TextColumn get catalogVersion =>
      text().customConstraint('NOT NULL CHECK (length(catalog_version) > 0)')();

  IntColumn get schemaVersion =>
      integer().customConstraint('NOT NULL CHECK (schema_version > 0)')();

  DateTimeColumn get importedAt => dateTime().customConstraint('NOT NULL')();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{catalogVersion};
}

@DriftDatabase(
  tables: <Type>[
    WorkoutSets,
    OfficialExercises,
    OfficialExerciseEquipmentTags,
    OfficialExerciseMovementPatterns,
    OfficialExerciseMuscleGroups,
    CatalogImports,
  ],
)
class RepForgeDatabase extends _$RepForgeDatabase {
  RepForgeDatabase(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator migrator) => migrator.createAll(),
    onUpgrade: (Migrator migrator, int from, int to) async {
      if (from < 2) {
        await migrator.createTable(officialExercises);
        await migrator.createTable(officialExerciseEquipmentTags);
        await migrator.createTable(officialExerciseMovementPatterns);
        await migrator.createTable(officialExerciseMuscleGroups);
        await migrator.createTable(catalogImports);
      }
    },
    // Future migrations must preserve logged set history and prefer additive
    // changes over destructive rewrites.
  );
}
