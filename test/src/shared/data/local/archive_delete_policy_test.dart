import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/backup/data/backup_data.dart';
import 'package:repforge/src/features/backup/domain/backup_domain.dart';
import 'package:repforge/src/features/onboarding/data/repositories/drift_onboarding_status_repository.dart';
import 'package:repforge/src/features/onboarding/domain/onboarding_domain.dart';
import 'package:repforge/src/features/recovery/data/recovery_data.dart';
import 'package:repforge/src/features/recovery/domain/recovery_domain.dart';
import 'package:repforge/src/features/settings/data/repositories/drift_settings_profile_repository.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';
import 'package:repforge/src/features/training_log/data/repositories/drift_workout_set_repository.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';
import 'package:repforge/src/features/workout_groups/data/repositories/drift_workout_group_repository.dart';
import 'package:repforge/src/features/workout_groups/domain/workout_groups_domain.dart';
import 'package:repforge/src/shared/data/local/repforge_database.dart';

void main() {
  late RepForgeDatabase database;

  setUp(() {
    database = RepForgeDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('deleting a WorkoutSet deletes only that set', () async {
    final setRepository = DriftWorkoutSetRepository(database);
    await _seedOfficialCatalog(database);
    await _seedGroupAndAssignment(database);
    await setRepository.save(_set(id: 'set-delete'));
    await setRepository.save(_set(id: 'set-keep'));

    await setRepository.deleteById(WorkoutSetId('set-delete'));

    expect(await setRepository.findById(WorkoutSetId('set-delete')), isNull);
    expect(await setRepository.findById(WorkoutSetId('set-keep')), isNotNull);
    expect(
      await database.select(database.officialExercises).get(),
      hasLength(1),
    );
    expect(await database.select(database.workoutGroups).get(), hasLength(1));
    expect(
      await database.select(database.workoutGroupExerciseAssignments).get(),
      hasLength(1),
    );
  });

  test('workout history snapshots remain self-contained', () async {
    final setRepository = DriftWorkoutSetRepository(database);
    await _seedOfficialCatalog(database);
    await setRepository.save(
      _set(id: 'set-snapshot', snapshot: 'Bench Press Snapshot'),
    );

    await (database.update(database.officialExercises)
          ..where(($OfficialExercisesTable table) {
            return table.catalogId.equals('barbell-bench-press');
          }))
        .write(
          const OfficialExercisesCompanion(
            englishName: Value<String>('Updated Bench Name'),
            germanName: Value<String>('Aktualisiertes Bankdruecken'),
          ),
        );

    final row = await database.select(database.workoutSets).getSingle();

    expect(row.exerciseDisplayNameSnapshot, 'Bench Press Snapshot');
  });

  test('assignment removal does not mutate logged WorkoutSets', () async {
    final groupRepository = DriftWorkoutGroupRepository(database);
    final setRepository = DriftWorkoutSetRepository(database);
    await _seedOfficialCatalog(database);
    await _seedGroupAndAssignment(database);
    await setRepository.save(_set(id: 'set-1', snapshot: 'Logged Snapshot'));

    await groupRepository.removeAssignment(
      WorkoutGroupExerciseAssignmentId('assignment-1'),
    );

    final set = await setRepository.findById(WorkoutSetId('set-1'));
    expect(set?.exerciseRef.displayNameSnapshot, 'Logged Snapshot');
    expect(
      await database.select(database.officialExercises).get(),
      hasLength(1),
    );
    expect(
      await database.select(database.workoutGroupExerciseAssignments).get(),
      isEmpty,
    );
  });

  test(
    'settings and onboarding changes do not alter training or catalog data',
    () async {
      await _seedOfficialCatalog(database);
      await _seedGroupAndAssignment(database);
      await DriftWorkoutSetRepository(database).save(_set(id: 'set-1'));

      await DriftSettingsProfileRepository(database).save(
        SettingsProfile.defaults().copyWith(
          languageOverride: LanguageOverride.german,
          defaultRestTime: DefaultRestTime.seconds(120),
        ),
      );
      await DriftOnboardingStatusRepository(database).save(
        OnboardingStatus(
          completion: OnboardingCompletion.completed,
          updatedAt: DateTime.utc(2026, 5, 28),
        ),
      );

      expect(await database.select(database.workoutSets).get(), hasLength(1));
      expect(
        await database.select(database.officialExercises).get(),
        hasLength(1),
      );
      expect(await database.select(database.workoutGroups).get(), hasLength(1));
      expect(
        await database.select(database.workoutGroupExerciseAssignments).get(),
        hasLength(1),
      );
    },
  );

  test('backup import upsert does not wipe unrelated local data', () async {
    await _seedOfficialCatalog(database);
    await _seedGroupAndAssignment(database);
    await DriftWorkoutSetRepository(database).save(_set(id: 'local-set'));

    await DriftLocalBackupRepository(database).importBackup(
      RepForgeBackup.create(
        exportedAt: DateTime.utc(2026, 5, 28, 12),
        workoutSets: <BackupWorkoutSet>[
          BackupWorkoutSet(
            id: 'imported-set',
            exerciseRef: const BackupExerciseRef(
              source: 'official',
              id: 'barbell-bench-press',
              displayNameSnapshot: 'Imported Snapshot',
              catalogVersionSnapshot: '2026.05.0',
            ),
            repetitions: 8,
            loadKg: 70,
            performedAt: DateTime.utc(2026, 5, 28, 13),
          ),
        ],
      ),
    );

    final sets = await database.select(database.workoutSets).get();

    expect(
      sets.map((row) => row.workoutSetId),
      containsAll(<String>['local-set', 'imported-set']),
    );
    expect(
      await database.select(database.officialExercises).get(),
      hasLength(1),
    );
    expect(await database.select(database.workoutGroups).get(), hasLength(1));
    expect(
      await database.select(database.workoutGroupExerciseAssignments).get(),
      hasLength(1),
    );
  });

  test(
    'readiness check-ins export and import without mutating other data',
    () async {
      await _seedOfficialCatalog(database);
      await _seedGroupAndAssignment(database);
      await DriftWorkoutSetRepository(database).save(_set(id: 'local-set'));
      await DriftReadinessCheckInRepository(database).save(
        ReadinessCheckIn(
          id: ReadinessCheckInId('readiness-1'),
          checkedInAt: DateTime.utc(2026, 6, 2, 8),
          soreness: SorenessRating.moderate(),
          sleepQuality: SleepQualityRating(4),
          energy: EnergyRating(4),
          stress: StressRating(2),
          motivation: MotivationRating(4),
        ),
      );

      final backup = await DriftLocalBackupRepository(database).exportBackup();
      await database.close();
      database = RepForgeDatabase(NativeDatabase.memory());
      await DriftLocalBackupRepository(database).importBackup(backup);

      final latest = await DriftReadinessCheckInRepository(database).latest();

      expect(latest?.id, ReadinessCheckInId('readiness-1'));
      expect(await database.select(database.workoutSets).get(), hasLength(1));
      expect(
        await database.select(database.officialExercises).get(),
        hasLength(1),
      );
      expect(await database.select(database.workoutGroups).get(), hasLength(1));
    },
  );
}

Future<void> _seedOfficialCatalog(RepForgeDatabase database) async {
  await database
      .into(database.officialExercises)
      .insert(
        OfficialExercisesCompanion.insert(
          catalogId: 'barbell-bench-press',
          catalogVersion: '2026.05.0',
          schemaVersion: 1,
          englishName: 'Barbell Bench Press',
          germanName: 'Bankdruecken',
        ),
      );
}

Future<void> _seedGroupAndAssignment(RepForgeDatabase database) async {
  await database
      .into(database.workoutGroups)
      .insert(
        WorkoutGroupsCompanion.insert(
          workoutGroupId: 'group-1',
          name: 'Push Day',
          sortOrder: 0,
        ),
      );
  await database
      .into(database.workoutGroupExerciseAssignments)
      .insert(
        WorkoutGroupExerciseAssignmentsCompanion.insert(
          assignmentId: 'assignment-1',
          workoutGroupId: 'group-1',
          exerciseSource: 'official',
          exerciseId: 'barbell-bench-press',
          exerciseDisplayNameSnapshot: 'Bench Press Assignment',
          catalogVersionSnapshot: const Value<String?>('2026.05.0'),
          position: 0,
        ),
      );
}

WorkoutSet _set({required String id, String snapshot = 'Barbell Bench Press'}) {
  return WorkoutSet(
    id: WorkoutSetId(id),
    exerciseRef: ExerciseRef.official(
      id: OfficialExerciseId('barbell-bench-press'),
      displayNameSnapshot: snapshot,
      catalogVersionSnapshot: '2026.05.0',
    ),
    repetitions: Repetitions(5),
    load: LoadKg(80),
    performedAt: PerformedAt(DateTime.utc(2026, 5, 28, 12)),
  );
}
