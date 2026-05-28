import 'package:drift/drift.dart';

import 'repforge_database.dart';

enum PersistenceIntegritySeverity { warning, error }

final class PersistenceIntegrityFinding {
  const PersistenceIntegrityFinding({
    required this.severity,
    required this.code,
    required this.message,
    required this.table,
    this.entityId,
    this.safeRepairAvailable = false,
  });

  final PersistenceIntegritySeverity severity;
  final String code;
  final String message;
  final String table;
  final String? entityId;
  final bool safeRepairAvailable;

  @override
  bool operator ==(Object other) {
    return other is PersistenceIntegrityFinding &&
        severity == other.severity &&
        code == other.code &&
        message == other.message &&
        table == other.table &&
        entityId == other.entityId &&
        safeRepairAvailable == other.safeRepairAvailable;
  }

  @override
  int get hashCode {
    return Object.hash(
      severity,
      code,
      message,
      table,
      entityId,
      safeRepairAvailable,
    );
  }

  @override
  String toString() {
    return 'PersistenceIntegrityFinding('
        'severity: $severity, '
        'code: $code, '
        'table: $table, '
        'entityId: $entityId, '
        'safeRepairAvailable: $safeRepairAvailable'
        ')';
  }
}

final class RepForgeIntegrityChecker {
  const RepForgeIntegrityChecker(this._database);

  final RepForgeDatabase _database;

  Future<List<PersistenceIntegrityFinding>> inspect() async {
    final findings = <PersistenceIntegrityFinding>[];

    await _checkWorkoutSets(findings);
    await _checkWorkoutGroupAssignments(findings);
    await _checkSettings(findings);
    await _checkOnboarding(findings);
    await _checkCatalogImports(findings);

    findings.sort(_compareFindings);
    return List<PersistenceIntegrityFinding>.unmodifiable(findings);
  }

  Future<void> _checkWorkoutSets(
    List<PersistenceIntegrityFinding> findings,
  ) async {
    final rows = await _database
        .customSelect(
          '''
SELECT
  workout_set_id,
  exercise_source,
  exercise_id,
  exercise_display_name_snapshot,
  catalog_version_snapshot,
  repetitions,
  load_kg,
  set_label
FROM workout_sets
''',
          readsFrom: <ResultSetImplementation<Table, Object?>>{
            _database.workoutSets,
          },
        )
        .get();

    for (final row in rows) {
      final id = row.read<String>('workout_set_id');
      final source = row.read<String>('exercise_source');
      final exerciseId = row.read<String>('exercise_id');
      final snapshot = row.read<String>('exercise_display_name_snapshot');
      final catalogVersion = row.readNullable<String>(
        'catalog_version_snapshot',
      );
      final repetitions = row.read<int>('repetitions');
      final load = row.read<double>('load_kg');
      final label = row.readNullable<String>('set_label');

      if (!_validExerciseSources.contains(source)) {
        findings.add(
          _error(
            code: 'workoutSets.invalidExerciseSource',
            message: 'Workout set has an unsupported exercise source.',
            table: 'workout_sets',
            entityId: id,
          ),
        );
      }
      if (exerciseId.isEmpty || snapshot.isEmpty) {
        findings.add(
          _error(
            code: 'workoutSets.missingExerciseSnapshot',
            message:
                'Workout set is missing self-contained exercise snapshot data.',
            table: 'workout_sets',
            entityId: id,
          ),
        );
      }
      if (source == 'official' &&
          (catalogVersion == null || catalogVersion.isEmpty)) {
        findings.add(
          _error(
            code: 'workoutSets.missingCatalogSnapshot',
            message:
                'Official workout set is missing a catalog version snapshot.',
            table: 'workout_sets',
            entityId: id,
          ),
        );
      }
      if (source == 'custom' && catalogVersion != null) {
        findings.add(
          _error(
            code: 'workoutSets.customCatalogSnapshot',
            message:
                'Custom workout set should not carry official catalog metadata.',
            table: 'workout_sets',
            entityId: id,
          ),
        );
      }
      if (repetitions <= 0) {
        findings.add(
          _error(
            code: 'workoutSets.invalidRepetitions',
            message: 'Workout set repetitions must be greater than zero.',
            table: 'workout_sets',
            entityId: id,
          ),
        );
      }
      if (load < 0 || !load.isFinite) {
        findings.add(
          _error(
            code: 'workoutSets.invalidLoad',
            message: 'Workout set load must be finite and non-negative.',
            table: 'workout_sets',
            entityId: id,
          ),
        );
      }
      if (label != null && label.isEmpty) {
        findings.add(
          _warning(
            code: 'workoutSets.blankSetLabel',
            message:
                'Workout set has a legacy blank label that can be normalized to null.',
            table: 'workout_sets',
            entityId: id,
            safeRepairAvailable: true,
          ),
        );
      } else if (label != null && !_validSetLabels.contains(label)) {
        findings.add(
          _error(
            code: 'workoutSets.invalidSetLabel',
            message: 'Workout set has an unsupported set label.',
            table: 'workout_sets',
            entityId: id,
          ),
        );
      }
    }
  }

  Future<void> _checkWorkoutGroupAssignments(
    List<PersistenceIntegrityFinding> findings,
  ) async {
    final rows = await _database
        .customSelect(
          '''
SELECT
  a.assignment_id,
  a.workout_group_id,
  a.exercise_source,
  a.exercise_id,
  a.exercise_display_name_snapshot,
  a.catalog_version_snapshot,
  a.position,
  g.workout_group_id AS matched_group_id
FROM workout_group_exercise_assignments a
LEFT JOIN workout_groups g
  ON g.workout_group_id = a.workout_group_id
''',
          readsFrom: <ResultSetImplementation<Table, Object?>>{
            _database.workoutGroupExerciseAssignments,
            _database.workoutGroups,
          },
        )
        .get();

    for (final row in rows) {
      final id = row.read<String>('assignment_id');
      final source = row.read<String>('exercise_source');
      final exerciseId = row.read<String>('exercise_id');
      final snapshot = row.read<String>('exercise_display_name_snapshot');
      final catalogVersion = row.readNullable<String>(
        'catalog_version_snapshot',
      );
      final position = row.read<int>('position');
      final matchedGroupId = row.readNullable<String>('matched_group_id');

      if (matchedGroupId == null) {
        findings.add(
          _error(
            code: 'workoutGroupAssignments.orphanedWorkoutGroup',
            message: 'Workout group assignment references a missing group.',
            table: 'workout_group_exercise_assignments',
            entityId: id,
          ),
        );
      }
      if (!_validExerciseSources.contains(source)) {
        findings.add(
          _error(
            code: 'workoutGroupAssignments.invalidExerciseSource',
            message:
                'Workout group assignment has an unsupported exercise source.',
            table: 'workout_group_exercise_assignments',
            entityId: id,
          ),
        );
      }
      if (exerciseId.isEmpty || snapshot.isEmpty) {
        findings.add(
          _error(
            code: 'workoutGroupAssignments.missingExerciseSnapshot',
            message:
                'Workout group assignment is missing exercise snapshot data.',
            table: 'workout_group_exercise_assignments',
            entityId: id,
          ),
        );
      }
      if (source == 'official' &&
          (catalogVersion == null || catalogVersion.isEmpty)) {
        findings.add(
          _error(
            code: 'workoutGroupAssignments.missingCatalogSnapshot',
            message:
                'Official workout group assignment is missing a catalog version snapshot.',
            table: 'workout_group_exercise_assignments',
            entityId: id,
          ),
        );
      }
      if (source == 'custom' && catalogVersion != null) {
        findings.add(
          _error(
            code: 'workoutGroupAssignments.customCatalogSnapshot',
            message:
                'Custom workout group assignment should not carry official catalog metadata.',
            table: 'workout_group_exercise_assignments',
            entityId: id,
          ),
        );
      }
      if (position < 0) {
        findings.add(
          _error(
            code: 'workoutGroupAssignments.invalidPosition',
            message: 'Workout group assignment position must be non-negative.',
            table: 'workout_group_exercise_assignments',
            entityId: id,
          ),
        );
      }
    }
  }

  Future<void> _checkSettings(
    List<PersistenceIntegrityFinding> findings,
  ) async {
    final profileRows = await _database
        .customSelect(
          '''
SELECT
  profile_id,
  language_override,
  unit_preference,
  theme_preference,
  default_rest_seconds,
  display_name,
  focus_profile,
  training_days_per_week,
  session_duration_minutes
FROM settings_profiles
''',
          readsFrom: <ResultSetImplementation<Table, Object?>>{
            _database.settingsProfiles,
          },
        )
        .get();

    for (final row in profileRows) {
      final id = row.read<String>('profile_id');
      final displayName = row.readNullable<String>('display_name');
      if (id.isEmpty ||
          !_validLanguageOverrides.contains(
            row.read<String>('language_override'),
          ) ||
          !_validUnitPreferences.contains(
            row.read<String>('unit_preference'),
          ) ||
          !_validThemePreferences.contains(
            row.read<String>('theme_preference'),
          ) ||
          row.read<int>('default_rest_seconds') <= 0 ||
          row.read<int>('default_rest_seconds') > 1800 ||
          (displayName != null &&
              (displayName.isEmpty || displayName.length > 80)) ||
          !_validFocusProfiles.contains(row.read<String>('focus_profile')) ||
          row.read<int>('training_days_per_week') < 1 ||
          row.read<int>('training_days_per_week') > 7 ||
          !_validSessionDurations.contains(
            row.read<int>('session_duration_minutes'),
          )) {
        findings.add(
          _error(
            code: 'settingsProfiles.invalidProfile',
            message:
                'Settings profile contains unsupported or out-of-range values.',
            table: 'settings_profiles',
            entityId: id,
          ),
        );
      }
    }

    final equipmentRows = await _database
        .customSelect(
          '''
SELECT profile_id, equipment
FROM equipment_inventory_items
''',
          readsFrom: <ResultSetImplementation<Table, Object?>>{
            _database.equipmentInventoryItems,
          },
        )
        .get();

    for (final row in equipmentRows) {
      final profileId = row.read<String>('profile_id');
      final equipment = row.read<String>('equipment');
      if (profileId.isEmpty || !_validEquipment.contains(equipment)) {
        findings.add(
          _error(
            code: 'equipmentInventoryItems.invalidEquipment',
            message: 'Equipment inventory item contains unsupported values.',
            table: 'equipment_inventory_items',
            entityId: '$profileId/$equipment',
          ),
        );
      }
    }
  }

  Future<void> _checkOnboarding(
    List<PersistenceIntegrityFinding> findings,
  ) async {
    final rows = await _database
        .customSelect(
          '''
SELECT status_id, completion
FROM onboarding_statuses
''',
          readsFrom: <ResultSetImplementation<Table, Object?>>{
            _database.onboardingStatuses,
          },
        )
        .get();

    for (final row in rows) {
      final id = row.read<String>('status_id');
      if (id.isEmpty ||
          !_validOnboardingCompletions.contains(
            row.read<String>('completion'),
          )) {
        findings.add(
          _error(
            code: 'onboardingStatuses.invalidStatus',
            message: 'Onboarding status contains unsupported values.',
            table: 'onboarding_statuses',
            entityId: id,
          ),
        );
      }
    }
  }

  Future<void> _checkCatalogImports(
    List<PersistenceIntegrityFinding> findings,
  ) async {
    final rows = await _database
        .customSelect(
          '''
SELECT catalog_version, schema_version
FROM catalog_imports
''',
          readsFrom: <ResultSetImplementation<Table, Object?>>{
            _database.catalogImports,
          },
        )
        .get();

    for (final row in rows) {
      final catalogVersion = row.read<String>('catalog_version');
      if (catalogVersion.isEmpty || row.read<int>('schema_version') <= 0) {
        findings.add(
          _error(
            code: 'catalogImports.invalidMetadata',
            message: 'Catalog import metadata contains unsupported values.',
            table: 'catalog_imports',
            entityId: catalogVersion,
          ),
        );
      }
    }
  }
}

final class PersistenceIntegrityRepairResult {
  const PersistenceIntegrityRepairResult({
    required this.applied,
    required this.findings,
    required this.safeRepairCount,
  });

  final bool applied;
  final List<PersistenceIntegrityFinding> findings;
  final int safeRepairCount;
}

final class RepForgeIntegrityRepairer {
  const RepForgeIntegrityRepairer(this._database);

  final RepForgeDatabase _database;

  Future<PersistenceIntegrityRepairResult> repairSafe({
    bool apply = false,
  }) async {
    final findings = await RepForgeIntegrityChecker(_database).inspect();
    final repairableCount = findings
        .where((finding) => finding.safeRepairAvailable)
        .length;

    if (apply && repairableCount > 0) {
      await (_database.update(_database.workoutSets)
            ..where(($WorkoutSetsTable table) {
              return table.setLabel.equals('');
            }))
          .write(const WorkoutSetsCompanion(setLabel: Value<String?>(null)));
    }

    return PersistenceIntegrityRepairResult(
      applied: apply,
      findings: findings,
      safeRepairCount: repairableCount,
    );
  }
}

PersistenceIntegrityFinding _error({
  required String code,
  required String message,
  required String table,
  required String entityId,
}) {
  return PersistenceIntegrityFinding(
    severity: PersistenceIntegritySeverity.error,
    code: code,
    message: message,
    table: table,
    entityId: entityId,
  );
}

PersistenceIntegrityFinding _warning({
  required String code,
  required String message,
  required String table,
  required String entityId,
  required bool safeRepairAvailable,
}) {
  return PersistenceIntegrityFinding(
    severity: PersistenceIntegritySeverity.warning,
    code: code,
    message: message,
    table: table,
    entityId: entityId,
    safeRepairAvailable: safeRepairAvailable,
  );
}

int _compareFindings(
  PersistenceIntegrityFinding left,
  PersistenceIntegrityFinding right,
) {
  final tableCompare = left.table.compareTo(right.table);
  if (tableCompare != 0) {
    return tableCompare;
  }

  final idCompare = (left.entityId ?? '').compareTo(right.entityId ?? '');
  if (idCompare != 0) {
    return idCompare;
  }

  return left.code.compareTo(right.code);
}

const Set<String> _validExerciseSources = <String>{'official', 'custom'};

const Set<String> _validSetLabels = <String>{
  'none',
  'warmup',
  'failure',
  'personalRecord',
  'dropSet',
  'pain',
};

const Set<String> _validLanguageOverrides = <String>{'system', 'en', 'de'};
const Set<String> _validUnitPreferences = <String>{'metric', 'imperial'};
const Set<String> _validThemePreferences = <String>{'system', 'dark', 'light'};

const Set<String> _validFocusProfiles = <String>{
  'balanced',
  'upperBodyFocus',
  'lowerBodyGluteFocus',
  'armsChestFocus',
  'strengthBasics',
  'timeEfficient',
  'beginnerFoundation',
  'custom',
};

const Set<int> _validSessionDurations = <int>{15, 25, 35, 45, 60, 75};

const Set<String> _validEquipment = <String>{
  'bodyweight',
  'barbell',
  'dumbbell',
  'cable',
  'machine',
  'smithMachine',
  'pullUpBar',
  'bench',
  'legPress',
};

const Set<String> _validOnboardingCompletions = <String>{
  'notStarted',
  'skipped',
  'completed',
};
