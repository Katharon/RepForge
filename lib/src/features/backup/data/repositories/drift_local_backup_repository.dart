import 'package:drift/drift.dart';

import '../../../../shared/data/local/repforge_database.dart';
import '../../domain/backup_domain.dart';

typedef BackupClock = DateTime Function();

final class DriftLocalBackupRepository implements LocalBackupRepository {
  const DriftLocalBackupRepository(this._database, {BackupClock? clock})
    : _clock = clock ?? DateTime.now;

  final RepForgeDatabase _database;
  final BackupClock _clock;

  @override
  Future<RepForgeBackup> exportBackup() async {
    final workoutSetRows =
        await (_database.select(_database.workoutSets)..orderBy([
              ($WorkoutSetsTable table) {
                return OrderingTerm.asc(table.performedAt);
              },
              ($WorkoutSetsTable table) {
                return OrderingTerm.asc(table.workoutSetId);
              },
            ]))
            .get();
    final groupRows =
        await (_database.select(_database.workoutGroups)..orderBy([
              ($WorkoutGroupsTable table) {
                return OrderingTerm.asc(table.sortOrder);
              },
              ($WorkoutGroupsTable table) {
                return OrderingTerm.asc(table.workoutGroupId);
              },
            ]))
            .get();
    final assignmentRows =
        await (_database.select(_database.workoutGroupExerciseAssignments)
              ..orderBy([
                ($WorkoutGroupExerciseAssignmentsTable table) {
                  return OrderingTerm.asc(table.workoutGroupId);
                },
                ($WorkoutGroupExerciseAssignmentsTable table) {
                  return OrderingTerm.asc(table.position);
                },
                ($WorkoutGroupExerciseAssignmentsTable table) {
                  return OrderingTerm.asc(table.assignmentId);
                },
              ]))
            .get();
    final settingsRow =
        await (_database.select(_database.settingsProfiles)
              ..where(($SettingsProfilesTable table) {
                return table.profileId.equals('local');
              }))
            .getSingleOrNull();
    final equipmentRows =
        await (_database.select(_database.equipmentInventoryItems)
              ..where(($EquipmentInventoryItemsTable table) {
                return table.profileId.equals('local');
              })
              ..orderBy([
                ($EquipmentInventoryItemsTable table) {
                  return OrderingTerm.asc(table.equipment);
                },
              ]))
            .get();
    final onboardingRow =
        await (_database.select(_database.onboardingStatuses)
              ..where(($OnboardingStatusesTable table) {
                return table.statusId.equals('local');
              }))
            .getSingleOrNull();
    final catalogRows =
        await (_database.select(_database.catalogImports)..orderBy([
              ($CatalogImportsTable table) {
                return OrderingTerm.asc(table.catalogVersion);
              },
            ]))
            .get();

    return RepForgeBackup.create(
      exportedAt: _clock().toUtc(),
      workoutSets: workoutSetRows
          .map(_workoutSetFromRow)
          .toList(growable: false),
      workoutGroups: groupRows.map(_groupFromRow).toList(growable: false),
      workoutGroupAssignments: assignmentRows
          .map(_assignmentFromRow)
          .toList(growable: false),
      settingsProfile: settingsRow == null
          ? null
          : _settingsFromRows(settingsRow, equipmentRows),
      onboardingStatus: onboardingRow == null
          ? null
          : _onboardingFromRow(onboardingRow),
      catalogImports: catalogRows
          .map(_catalogImportFromRow)
          .toList(growable: false),
    );
  }

  @override
  Future<void> importBackup(RepForgeBackup backup) async {
    await _database.transaction(() async {
      for (final group in backup.workoutGroups) {
        await _database
            .into(_database.workoutGroups)
            .insertOnConflictUpdate(_groupToCompanion(group));
      }

      for (final assignment in backup.workoutGroupAssignments) {
        await _database
            .into(_database.workoutGroupExerciseAssignments)
            .insertOnConflictUpdate(_assignmentToCompanion(assignment));
      }

      for (final set in backup.workoutSets) {
        await _database
            .into(_database.workoutSets)
            .insertOnConflictUpdate(_workoutSetToCompanion(set));
      }

      final settings = backup.settingsProfile;
      if (settings != null) {
        await _database
            .into(_database.settingsProfiles)
            .insertOnConflictUpdate(_settingsToCompanion(settings));
        await (_database.delete(_database.equipmentInventoryItems)
              ..where(($EquipmentInventoryItemsTable table) {
                return table.profileId.equals('local');
              }))
            .go();
        for (final equipment in settings.equipmentInventory) {
          await _database
              .into(_database.equipmentInventoryItems)
              .insert(
                EquipmentInventoryItemsCompanion.insert(
                  profileId: 'local',
                  equipment: equipment,
                ),
              );
        }
      }

      final onboardingStatus = backup.onboardingStatus;
      if (onboardingStatus != null) {
        await _database
            .into(_database.onboardingStatuses)
            .insertOnConflictUpdate(_onboardingToCompanion(onboardingStatus));
      }

      for (final row in backup.catalogImports) {
        await _database
            .into(_database.catalogImports)
            .insertOnConflictUpdate(_catalogImportToCompanion(row));
      }
    });
  }
}

BackupWorkoutSet _workoutSetFromRow(WorkoutSetRow row) {
  return BackupWorkoutSet(
    id: row.workoutSetId,
    exerciseRef: BackupExerciseRef(
      source: row.exerciseSource,
      id: row.exerciseId,
      displayNameSnapshot: row.exerciseDisplayNameSnapshot,
      catalogVersionSnapshot: row.catalogVersionSnapshot,
    ),
    workoutSessionId: row.workoutSessionId,
    repetitions: row.repetitions,
    loadKg: row.loadKg,
    performedAt: row.performedAt.toUtc(),
    comment: row.comment,
    label: row.setLabel,
  );
}

WorkoutSetsCompanion _workoutSetToCompanion(BackupWorkoutSet set) {
  return WorkoutSetsCompanion.insert(
    workoutSetId: set.id,
    exerciseSource: set.exerciseRef.source,
    exerciseId: set.exerciseRef.id,
    exerciseDisplayNameSnapshot: set.exerciseRef.displayNameSnapshot,
    catalogVersionSnapshot: Value<String?>(
      set.exerciseRef.catalogVersionSnapshot,
    ),
    workoutSessionId: Value<String?>(set.workoutSessionId),
    repetitions: set.repetitions,
    loadKg: set.loadKg,
    performedAt: set.performedAt.toUtc(),
    comment: Value<String?>(set.comment),
    setLabel: Value<String?>(set.label),
  );
}

BackupWorkoutGroup _groupFromRow(WorkoutGroupRow row) {
  return BackupWorkoutGroup(
    id: row.workoutGroupId,
    name: row.name,
    sortOrder: row.sortOrder,
    archivedAt: row.archivedAt?.toUtc(),
  );
}

WorkoutGroupsCompanion _groupToCompanion(BackupWorkoutGroup group) {
  return WorkoutGroupsCompanion.insert(
    workoutGroupId: group.id,
    name: group.name,
    sortOrder: group.sortOrder,
    archivedAt: Value<DateTime?>(group.archivedAt?.toUtc()),
  );
}

BackupWorkoutGroupAssignment _assignmentFromRow(
  WorkoutGroupExerciseAssignmentRow row,
) {
  return BackupWorkoutGroupAssignment(
    id: row.assignmentId,
    workoutGroupId: row.workoutGroupId,
    exerciseRef: BackupExerciseRef(
      source: row.exerciseSource,
      id: row.exerciseId,
      displayNameSnapshot: row.exerciseDisplayNameSnapshot,
      catalogVersionSnapshot: row.catalogVersionSnapshot,
    ),
    position: row.position,
  );
}

WorkoutGroupExerciseAssignmentsCompanion _assignmentToCompanion(
  BackupWorkoutGroupAssignment assignment,
) {
  return WorkoutGroupExerciseAssignmentsCompanion.insert(
    assignmentId: assignment.id,
    workoutGroupId: assignment.workoutGroupId,
    exerciseSource: assignment.exerciseRef.source,
    exerciseId: assignment.exerciseRef.id,
    exerciseDisplayNameSnapshot: assignment.exerciseRef.displayNameSnapshot,
    catalogVersionSnapshot: Value<String?>(
      assignment.exerciseRef.catalogVersionSnapshot,
    ),
    position: assignment.position,
  );
}

BackupSettingsProfile _settingsFromRows(
  SettingsProfileRow row,
  List<EquipmentInventoryItemRow> equipmentRows,
) {
  return BackupSettingsProfile(
    languageOverride: row.languageOverride,
    unitPreference: row.unitPreference,
    themePreference: row.themePreference,
    defaultRestSeconds: row.defaultRestSeconds,
    displayName: row.displayName,
    focusProfile: row.focusProfile,
    trainingDaysPerWeek: row.trainingDaysPerWeek,
    sessionDurationMinutes: row.sessionDurationMinutes,
    equipmentInventory: equipmentRows
        .map((row) => row.equipment)
        .toList(growable: false),
  );
}

SettingsProfilesCompanion _settingsToCompanion(BackupSettingsProfile profile) {
  return SettingsProfilesCompanion.insert(
    profileId: 'local',
    languageOverride: profile.languageOverride,
    unitPreference: profile.unitPreference,
    themePreference: profile.themePreference,
    defaultRestSeconds: profile.defaultRestSeconds,
    displayName: Value<String?>(profile.displayName),
    focusProfile: profile.focusProfile,
    trainingDaysPerWeek: profile.trainingDaysPerWeek,
    sessionDurationMinutes: profile.sessionDurationMinutes,
  );
}

BackupOnboardingStatus _onboardingFromRow(OnboardingStatusRow row) {
  return BackupOnboardingStatus(
    completion: row.completion,
    updatedAt: row.updatedAt.toUtc(),
  );
}

OnboardingStatusesCompanion _onboardingToCompanion(
  BackupOnboardingStatus status,
) {
  return OnboardingStatusesCompanion.insert(
    statusId: 'local',
    completion: status.completion,
    updatedAt: status.updatedAt?.toUtc() ?? DateTime.now().toUtc(),
  );
}

BackupCatalogImport _catalogImportFromRow(CatalogImportRow row) {
  return BackupCatalogImport(
    catalogVersion: row.catalogVersion,
    schemaVersion: row.schemaVersion,
    importedAt: row.importedAt.toUtc(),
  );
}

CatalogImportsCompanion _catalogImportToCompanion(BackupCatalogImport row) {
  return CatalogImportsCompanion.insert(
    catalogVersion: row.catalogVersion,
    schemaVersion: row.schemaVersion,
    importedAt: row.importedAt.toUtc(),
  );
}
