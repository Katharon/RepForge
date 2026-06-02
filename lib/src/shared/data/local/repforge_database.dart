import 'package:drift/drift.dart';

part 'repforge_database.g.dart';

@DataClassName('WorkoutSetRow')
@TableIndex(
  name: 'workout_sets_exercise_timeline_idx',
  columns: {
    #exerciseSource,
    #exerciseId,
    IndexedColumn(#performedAt, orderBy: OrderingMode.desc),
    IndexedColumn(#workoutSetId, orderBy: OrderingMode.desc),
  },
)
@TableIndex(
  name: 'workout_sets_history_order_idx',
  columns: {
    IndexedColumn(#performedAt, orderBy: OrderingMode.desc),
    IndexedColumn(#workoutSetId, orderBy: OrderingMode.desc),
  },
)
@TableIndex(
  name: 'workout_sets_session_order_idx',
  columns: {#workoutSessionId, #performedAt, #workoutSetId},
)
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

  TextColumn get setLabel => text().nullable().customConstraint(
    "NULL CHECK (set_label IS NULL OR set_label = '' OR set_label IN ("
    "'none', "
    "'warmup', "
    "'failure', "
    "'personalRecord', "
    "'dropSet', "
    "'pain'"
    '))',
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

@DataClassName('WorkoutGroupRow')
class WorkoutGroups extends Table {
  TextColumn get workoutGroupId => text().customConstraint(
    'NOT NULL CHECK (length(workout_group_id) > 0)',
  )();

  TextColumn get name =>
      text().customConstraint('NOT NULL CHECK (length(name) > 0)')();

  IntColumn get sortOrder =>
      integer().customConstraint('NOT NULL CHECK (sort_order >= 0)')();

  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{workoutGroupId};
}

@DataClassName('WorkoutGroupExerciseAssignmentRow')
class WorkoutGroupExerciseAssignments extends Table {
  TextColumn get assignmentId =>
      text().customConstraint('NOT NULL CHECK (length(assignment_id) > 0)')();

  TextColumn get workoutGroupId => text().customConstraint(
    'NOT NULL CHECK (length(workout_group_id) > 0)',
  )();

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

  IntColumn get position =>
      integer().customConstraint('NOT NULL CHECK (position >= 0)')();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{assignmentId};
}

@DataClassName('SettingsProfileRow')
class SettingsProfiles extends Table {
  TextColumn get profileId =>
      text().customConstraint('NOT NULL CHECK (length(profile_id) > 0)')();

  TextColumn get languageOverride => text().customConstraint(
    "NOT NULL CHECK (language_override IN ('system', 'en', 'de'))",
  )();

  TextColumn get unitPreference => text().customConstraint(
    "NOT NULL CHECK (unit_preference IN ('metric', 'imperial'))",
  )();

  TextColumn get themePreference => text().customConstraint(
    "NOT NULL CHECK (theme_preference IN ('system', 'dark', 'light'))",
  )();

  IntColumn get defaultRestSeconds => integer().customConstraint(
    'NOT NULL CHECK (default_rest_seconds > 0 AND default_rest_seconds <= 1800)',
  )();

  TextColumn get displayName => text().nullable().customConstraint(
    'NULL CHECK ('
    'display_name IS NULL OR '
    '(length(display_name) > 0 AND length(display_name) <= 80)'
    ')',
  )();

  TextColumn get sexGender => text().nullable().customConstraint(
    'NULL CHECK (sex_gender IS NULL OR sex_gender IN ('
    "'unspecified', "
    "'male', "
    "'female', "
    "'other', "
    "'preferNotToSay'"
    '))',
  )();

  IntColumn get birthYear => integer().nullable().customConstraint(
    'NULL CHECK (birth_year IS NULL OR birth_year BETWEEN 1900 AND 2100)',
  )();

  RealColumn get bodyWeightKg => real().nullable().customConstraint(
    'NULL CHECK ('
    'body_weight_kg IS NULL OR '
    '(body_weight_kg > 0 AND body_weight_kg <= 500)'
    ')',
  )();

  RealColumn get heightCm => real().nullable().customConstraint(
    'NULL CHECK (height_cm IS NULL OR (height_cm > 0 AND height_cm <= 300))',
  )();

  TextColumn get trainingGoal => text().customConstraint(
    'NOT NULL DEFAULT '
    "'generalFitness' "
    'CHECK (training_goal IN ('
    "'hypertrophy', "
    "'strength', "
    "'generalFitness', "
    "'recomposition', "
    "'maintenance'"
    '))',
  )();

  TextColumn get focusProfile => text().customConstraint(
    'NOT NULL CHECK (focus_profile IN ('
    "'balanced', "
    "'upperBodyFocus', "
    "'lowerBodyGluteFocus', "
    "'armsChestFocus', "
    "'strengthBasics', "
    "'timeEfficient', "
    "'beginnerFoundation', "
    "'custom'"
    '))',
  )();

  IntColumn get trainingDaysPerWeek => integer().customConstraint(
    'NOT NULL CHECK (training_days_per_week BETWEEN 1 AND 7)',
  )();

  IntColumn get sessionDurationMinutes => integer().customConstraint(
    'NOT NULL CHECK (session_duration_minutes IN (15, 25, 35, 45, 60, 75))',
  )();

  TextColumn get recoverySensitivity => text().customConstraint(
    'NOT NULL DEFAULT '
    "'normal' "
    "CHECK (recovery_sensitivity IN ('low', 'normal', 'high'))",
  )();

  TextColumn get coachingStrictness => text().customConstraint(
    'NOT NULL DEFAULT '
    "'balanced' "
    "CHECK (coaching_strictness IN ('gentle', 'balanced', 'direct'))",
  )();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{profileId};
}

@DataClassName('EquipmentInventoryItemRow')
class EquipmentInventoryItems extends Table {
  TextColumn get profileId =>
      text().customConstraint('NOT NULL CHECK (length(profile_id) > 0)')();

  TextColumn get equipment => text().customConstraint(
    'NOT NULL CHECK (equipment IN ('
    "'bodyweight', "
    "'barbell', "
    "'dumbbell', "
    "'cable', "
    "'machine', "
    "'smithMachine', "
    "'pullUpBar', "
    "'bench', "
    "'rack', "
    "'legPress'"
    '))',
  )();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{profileId, equipment};
}

@DataClassName('EquipmentLoadConstraintRow')
class EquipmentLoadConstraints extends Table {
  TextColumn get profileId =>
      text().customConstraint('NOT NULL CHECK (length(profile_id) > 0)')();

  TextColumn get equipment => text().customConstraint(
    'NOT NULL CHECK (equipment IN ('
    "'bodyweight', "
    "'barbell', "
    "'dumbbell', "
    "'cable', "
    "'machine', "
    "'smithMachine', "
    "'pullUpBar', "
    "'bench', "
    "'rack', "
    "'legPress'"
    '))',
  )();

  RealColumn get maxLoadKg => real().nullable().customConstraint(
    'NULL CHECK (max_load_kg IS NULL OR '
    '(max_load_kg > 0 AND max_load_kg <= 1000))',
  )();

  RealColumn get incrementKg => real().nullable().customConstraint(
    'NULL CHECK (increment_kg IS NULL OR '
    '(increment_kg > 0 AND increment_kg <= 100))',
  )();

  @override
  List<String> get customConstraints => <String>[
    'CHECK (max_load_kg IS NOT NULL OR increment_kg IS NOT NULL)',
    'CHECK ('
        'max_load_kg IS NULL OR '
        'increment_kg IS NULL OR '
        'increment_kg <= max_load_kg'
        ')',
  ];

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{profileId, equipment};
}

@DataClassName('OnboardingStatusRow')
class OnboardingStatuses extends Table {
  TextColumn get statusId =>
      text().customConstraint('NOT NULL CHECK (length(status_id) > 0)')();

  TextColumn get completion => text().customConstraint(
    "NOT NULL CHECK (completion IN ('notStarted', 'skipped', 'completed'))",
  )();

  DateTimeColumn get updatedAt => dateTime().customConstraint('NOT NULL')();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{statusId};
}

@DriftDatabase(
  tables: <Type>[
    WorkoutSets,
    OfficialExercises,
    OfficialExerciseEquipmentTags,
    OfficialExerciseMovementPatterns,
    OfficialExerciseMuscleGroups,
    CatalogImports,
    WorkoutGroups,
    WorkoutGroupExerciseAssignments,
    SettingsProfiles,
    EquipmentInventoryItems,
    EquipmentLoadConstraints,
    OnboardingStatuses,
  ],
)
class RepForgeDatabase extends _$RepForgeDatabase {
  RepForgeDatabase(super.executor);

  @override
  int get schemaVersion => 8;

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
      if (from < 3) {
        await migrator.createTable(workoutGroups);
        await migrator.createTable(workoutGroupExerciseAssignments);
      }
      if (from < 4) {
        await migrator.addColumn(workoutSets, workoutSets.setLabel);
      }
      if (from < 5) {
        await migrator.createTable(settingsProfiles);
        await migrator.createTable(equipmentInventoryItems);
      }
      if (from < 6) {
        await migrator.createTable(onboardingStatuses);
      }
      if (from < 7) {
        await _createPerformanceIndexes();
      }
      if (from >= 5 && from < 8) {
        await migrator.addColumn(settingsProfiles, settingsProfiles.sexGender);
        await migrator.addColumn(settingsProfiles, settingsProfiles.birthYear);
        await migrator.addColumn(
          settingsProfiles,
          settingsProfiles.bodyWeightKg,
        );
        await migrator.addColumn(settingsProfiles, settingsProfiles.heightCm);
        await migrator.addColumn(
          settingsProfiles,
          settingsProfiles.trainingGoal,
        );
        await migrator.addColumn(
          settingsProfiles,
          settingsProfiles.recoverySensitivity,
        );
        await migrator.addColumn(
          settingsProfiles,
          settingsProfiles.coachingStrictness,
        );
      }
      if (from < 8) {
        await migrator.createTable(equipmentLoadConstraints);
      }
    },
    // Future migrations must preserve logged set history and prefer additive
    // changes over destructive rewrites.
  );

  Future<void> _createPerformanceIndexes() async {
    await customStatement('''
CREATE INDEX IF NOT EXISTS workout_sets_exercise_timeline_idx
ON workout_sets (
  exercise_source,
  exercise_id,
  performed_at DESC,
  workout_set_id DESC
)
''');
    await customStatement('''
CREATE INDEX IF NOT EXISTS workout_sets_history_order_idx
ON workout_sets (
  performed_at DESC,
  workout_set_id DESC
)
''');
    await customStatement('''
CREATE INDEX IF NOT EXISTS workout_sets_session_order_idx
ON workout_sets (
  workout_session_id,
  performed_at,
  workout_set_id
)
''');
  }
}
