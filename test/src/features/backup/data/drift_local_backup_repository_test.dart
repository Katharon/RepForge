import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/backup/application/backup_application.dart';
import 'package:repforge/src/features/backup/data/backup_data.dart';
import 'package:repforge/src/features/backup/domain/backup_domain.dart';
import 'package:repforge/src/shared/data/local/repforge_database.dart';

void main() {
  late RepForgeDatabase database;
  late DriftLocalBackupRepository repository;

  setUp(() {
    database = RepForgeDatabase(NativeDatabase.memory());
    repository = DriftLocalBackupRepository(
      database,
      clock: () => DateTime.utc(2026, 5, 28, 12),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'exports workout sets with stable ids snapshots labels and comments',
    () async {
      await _seedWorkoutSet(database);

      final backup = await repository.exportBackup();

      expect(backup.exportVersion, currentBackupExportVersion);
      expect(backup.schemaVersion, currentBackupSchemaVersion);
      expect(backup.exportedAt, DateTime.utc(2026, 5, 28, 12));
      expect(backup.workoutSets.single.id, 'set-1');
      expect(backup.workoutSets.single.exerciseRef.id, 'barbell-bench-press');
      expect(
        backup.workoutSets.single.exerciseRef.displayNameSnapshot,
        'Bench Press Snapshot',
      );
      expect(backup.workoutSets.single.workoutSessionId, 'session-1');
      expect(backup.workoutSets.single.repetitions, 5);
      expect(backup.workoutSets.single.loadKg, 80);
      expect(backup.workoutSets.single.comment, 'Top set');
      expect(backup.workoutSets.single.label, 'personalRecord');
    },
  );

  test(
    'exports workout groups assignments settings and onboarding status',
    () async {
      await _seedGroup(database);
      await _seedSettings(database);
      await _seedOnboarding(database);

      final backup = await repository.exportBackup();

      expect(backup.workoutGroups.single.id, 'group-1');
      expect(backup.workoutGroupAssignments.single.workoutGroupId, 'group-1');
      expect(backup.workoutGroupAssignments.single.exerciseRef.id, 'squat');
      expect(backup.settingsProfile?.languageOverride, 'de');
      expect(backup.settingsProfile?.equipmentInventory, <String>[
        'bodyweight',
        'dumbbell',
        'rack',
      ]);
      expect(backup.settingsProfile?.sexGender, 'preferNotToSay');
      expect(backup.settingsProfile?.birthYear, 1991);
      expect(backup.settingsProfile?.bodyWeightKg, 82.5);
      expect(backup.settingsProfile?.heightCm, 181);
      expect(backup.settingsProfile?.trainingGoal, 'strength');
      expect(backup.settingsProfile?.recoverySensitivity, 'high');
      expect(backup.settingsProfile?.coachingStrictness, 'direct');
      expect(
        backup.settingsProfile?.equipmentLoadConstraints.single.equipment,
        'dumbbell',
      );
      expect(
        backup.settingsProfile?.equipmentLoadConstraints.single.incrementKg,
        2,
      );
      expect(backup.onboardingStatus?.completion, 'completed');
    },
  );

  test(
    'exports catalog import metadata but not official catalog rows',
    () async {
      await database
          .into(database.officialExercises)
          .insert(
            OfficialExercisesCompanion.insert(
              catalogId: 'official-1',
              catalogVersion: '2026.05.0',
              schemaVersion: 1,
              englishName: 'Bench Press',
              germanName: 'Bankdruecken',
            ),
          );
      await database
          .into(database.catalogImports)
          .insert(
            CatalogImportsCompanion.insert(
              catalogVersion: '2026.05.0',
              schemaVersion: 1,
              importedAt: DateTime.utc(2026, 5, 28, 9),
            ),
          );

      final json = (await repository.exportBackup()).toJson();

      expect(json.containsKey('officialExercises'), isFalse);
      expect(json['catalogImports'], isNotEmpty);
    },
  );

  test('exports and imports readiness check-ins deterministically', () async {
    await database
        .into(database.readinessCheckIns)
        .insert(
          ReadinessCheckInsCompanion.insert(
            readinessCheckInId: 'readiness-1',
            checkedInAt: DateTime.utc(2026, 6, 2, 8),
            soreness: 2,
            sleepQuality: 4,
            energy: 4,
            stress: 2,
            motivation: 5,
          ),
        );

    final backup = await repository.exportBackup();
    expect(backup.readinessCheckIns, hasLength(1));
    expect(backup.readinessCheckIns.single.id, 'readiness-1');
    expect(backup.readinessCheckIns.single.checkedInAt.isUtc, isTrue);

    await database.close();
    database = RepForgeDatabase(NativeDatabase.memory());
    repository = DriftLocalBackupRepository(database);

    await repository.importBackup(backup);

    final rows = await database.select(database.readinessCheckIns).get();
    expect(rows, hasLength(1));
    expect(rows.single.readinessCheckInId, 'readiness-1');
    expect(rows.single.checkedInAt.toUtc(), DateTime.utc(2026, 6, 2, 8));
    expect(rows.single.soreness, 2);
    expect(rows.single.sleepQuality, 4);
    expect(rows.single.energy, 4);
    expect(rows.single.stress, 2);
    expect(rows.single.motivation, 5);
  });

  test('import validation does not modify database', () async {
    await expectLater(
      ImportLocalBackup(repository)('{"exportVersion":99}'),
      throwsA(isA<BackupValidationException>()),
    );

    expect(await database.select(database.workoutSets).get(), isEmpty);
  });

  test('safe import adds data without destroying existing rows', () async {
    await _seedWorkoutSet(database, id: 'existing-set');
    final backup = RepForgeBackup.create(
      exportedAt: DateTime.utc(2026, 5, 28, 12),
      workoutSets: <BackupWorkoutSet>[
        BackupWorkoutSet(
          id: 'imported-set',
          exerciseRef: const BackupExerciseRef(
            source: 'official',
            id: 'deadlift',
            displayNameSnapshot: 'Deadlift Snapshot',
            catalogVersionSnapshot: '2026.05.0',
          ),
          workoutSessionId: 'session-import',
          repetitions: 3,
          loadKg: 120,
          performedAt: DateTime.utc(2026, 5, 28, 13),
          label: 'warmup',
        ),
      ],
      settingsProfile: const BackupSettingsProfile(
        languageOverride: 'en',
        unitPreference: 'metric',
        themePreference: 'dark',
        defaultRestSeconds: 90,
        sexGender: 'other',
        birthYear: 1990,
        bodyWeightKg: 91.5,
        heightCm: 188,
        trainingGoal: 'recomposition',
        focusProfile: 'balanced',
        trainingDaysPerWeek: 3,
        sessionDurationMinutes: 45,
        recoverySensitivity: 'low',
        coachingStrictness: 'gentle',
        equipmentInventory: <String>['bodyweight', 'barbell'],
        equipmentLoadConstraints: <BackupEquipmentLoadConstraint>[
          BackupEquipmentLoadConstraint(
            equipment: 'barbell',
            maxLoadKg: 160,
            incrementKg: 2.5,
          ),
        ],
      ),
      onboardingStatus: BackupOnboardingStatus(
        completion: 'skipped',
        updatedAt: DateTime.utc(2026, 5, 28, 12, 30),
      ),
    );

    await repository.importBackup(backup);

    final sets = await database.select(database.workoutSets).get();
    expect(
      sets.map((row) => row.workoutSetId),
      containsAll(<String>['existing-set', 'imported-set']),
    );
    expect(await database.select(database.officialExercises).get(), isEmpty);
    expect(
      (await database.select(database.settingsProfiles).getSingle())
          .languageOverride,
      'en',
    );
    final importedSettings = await database
        .select(database.settingsProfiles)
        .getSingle();
    expect(importedSettings.sexGender, 'other');
    expect(importedSettings.birthYear, 1990);
    expect(importedSettings.bodyWeightKg, 91.5);
    expect(importedSettings.heightCm, 188);
    expect(importedSettings.trainingGoal, 'recomposition');
    expect(importedSettings.recoverySensitivity, 'low');
    expect(importedSettings.coachingStrictness, 'gentle');
    final importedConstraints = await database
        .select(database.equipmentLoadConstraints)
        .get();
    expect(importedConstraints.single.equipment, 'barbell');
    expect(importedConstraints.single.maxLoadKg, 160);
    expect(importedConstraints.single.incrementKg, 2.5);
    expect(
      (await database.select(database.onboardingStatuses).getSingle())
          .completion,
      'skipped',
    );
  });
}

Future<void> _seedWorkoutSet(
  RepForgeDatabase database, {
  String id = 'set-1',
}) async {
  await database
      .into(database.workoutSets)
      .insert(
        WorkoutSetsCompanion.insert(
          workoutSetId: id,
          exerciseSource: 'official',
          exerciseId: 'barbell-bench-press',
          exerciseDisplayNameSnapshot: 'Bench Press Snapshot',
          catalogVersionSnapshot: const Value<String?>('2026.05.0'),
          workoutSessionId: const Value<String?>('session-1'),
          repetitions: 5,
          loadKg: 80,
          performedAt: DateTime.utc(2026, 5, 28, 10),
          comment: const Value<String?>('Top set'),
          setLabel: const Value<String?>('personalRecord'),
        ),
      );
}

Future<void> _seedGroup(RepForgeDatabase database) async {
  await database
      .into(database.workoutGroups)
      .insert(
        WorkoutGroupsCompanion.insert(
          workoutGroupId: 'group-1',
          name: 'Push',
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
          exerciseId: 'squat',
          exerciseDisplayNameSnapshot: 'Squat Snapshot',
          catalogVersionSnapshot: const Value<String?>('2026.05.0'),
          position: 0,
        ),
      );
}

Future<void> _seedSettings(RepForgeDatabase database) async {
  await database
      .into(database.settingsProfiles)
      .insert(
        SettingsProfilesCompanion.insert(
          profileId: 'local',
          languageOverride: 'de',
          unitPreference: 'metric',
          themePreference: 'system',
          defaultRestSeconds: 120,
          displayName: const Value<String?>('Luki'),
          sexGender: const Value<String?>('preferNotToSay'),
          birthYear: const Value<int?>(1991),
          bodyWeightKg: const Value<double?>(82.5),
          heightCm: const Value<double?>(181),
          trainingGoal: const Value<String>('strength'),
          focusProfile: 'strengthBasics',
          trainingDaysPerWeek: 4,
          sessionDurationMinutes: 60,
          recoverySensitivity: const Value<String>('high'),
          coachingStrictness: const Value<String>('direct'),
        ),
      );
  for (final equipment in <String>['bodyweight', 'dumbbell', 'rack']) {
    await database
        .into(database.equipmentInventoryItems)
        .insert(
          EquipmentInventoryItemsCompanion.insert(
            profileId: 'local',
            equipment: equipment,
          ),
        );
  }
  await database
      .into(database.equipmentLoadConstraints)
      .insert(
        EquipmentLoadConstraintsCompanion.insert(
          profileId: 'local',
          equipment: 'dumbbell',
          maxLoadKg: const Value<double?>(40),
          incrementKg: const Value<double?>(2),
        ),
      );
}

Future<void> _seedOnboarding(RepForgeDatabase database) async {
  await database
      .into(database.onboardingStatuses)
      .insert(
        OnboardingStatusesCompanion.insert(
          statusId: 'local',
          completion: 'completed',
          updatedAt: DateTime.utc(2026, 5, 28, 11),
        ),
      );
}
