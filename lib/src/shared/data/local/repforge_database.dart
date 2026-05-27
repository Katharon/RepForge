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

@DriftDatabase(tables: <Type>[WorkoutSets])
class RepForgeDatabase extends _$RepForgeDatabase {
  RepForgeDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator migrator) => migrator.createAll(),
    // Future migrations must preserve logged set history and prefer additive
    // changes over destructive rewrites.
  );
}
