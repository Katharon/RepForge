import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/backup/application/backup_application.dart';
import 'package:repforge/src/features/backup/domain/backup_domain.dart';

void main() {
  test('export use case returns repository JSON', () async {
    final repository = _FakeBackupRepository(
      RepForgeBackup.create(exportedAt: DateTime.utc(2026, 5, 28, 12)),
    );

    final json = await ExportLocalBackup(repository)();

    expect(json, contains('"exportVersion":1'));
    expect(json, contains('"appId":"repforge"'));
  });

  test('export use case exposes local backup privacy warning', () {
    expect(
      ExportLocalBackup.privacyWarning.title,
      'Backup contains sensitive local data',
    );
    expect(ExportLocalBackup.privacyWarning.message, contains('training'));
    expect(ExportLocalBackup.privacyWarning.message, contains('profile'));
    expect(ExportLocalBackup.privacyWarning.message, isNot(contains('cloud')));
  });

  test('validate use case reports malformed JSON without writing', () {
    final result = const ValidateLocalBackup()('{nope');

    expect(result.isValid, isFalse);
    expect(result.errors.single.field, 'json');
  });

  test('import use case validates before repository write', () async {
    final repository = _FakeBackupRepository(
      RepForgeBackup.create(exportedAt: DateTime.utc(2026, 5, 28, 12)),
    );

    expect(
      () => ImportLocalBackup(repository)('{"exportVersion":99}'),
      throwsA(isA<BackupValidationException>()),
    );
    expect(repository.importedBackups, isEmpty);
  });

  test(
    'validation exception log message lists fields without payload values',
    () {
      final sensitiveJson = RepForgeBackup.create(
        exportedAt: DateTime.utc(2026, 5, 28, 12),
        workoutSets: <BackupWorkoutSet>[
          BackupWorkoutSet(
            id: 'sensitive-set-id',
            exerciseRef: const BackupExerciseRef(
              source: 'official',
              id: 'barbell_bench_press',
              displayNameSnapshot: 'Private Bench Name',
              catalogVersionSnapshot: '2026.05.0',
            ),
            repetitions: 5,
            loadKg: 100,
            performedAt: DateTime.utc(2026, 5, 28, 10),
            comment: 'Private top set note',
          ),
          BackupWorkoutSet(
            id: 'sensitive-set-id',
            exerciseRef: const BackupExerciseRef(
              source: 'official',
              id: 'barbell_bench_press',
              displayNameSnapshot: 'Private Bench Name',
              catalogVersionSnapshot: '2026.05.0',
            ),
            repetitions: 5,
            loadKg: 100,
            performedAt: DateTime.utc(2026, 5, 28, 11),
          ),
        ],
      ).toJsonString();

      final error = _validationErrorFor(sensitiveJson);
      final loggable = error.toString();

      expect(loggable, contains('workoutSets.id'));
      expect(loggable, isNot(contains('sensitive-set-id')));
      expect(loggable, isNot(contains('Private top set note')));
      expect(loggable, isNot(contains('Private Bench Name')));
    },
  );

  test('backup log redactor removes sensitive sections from JSON', () {
    final backup = RepForgeBackup.create(
      exportedAt: DateTime.utc(2026, 5, 28, 12),
      workoutSets: <BackupWorkoutSet>[
        BackupWorkoutSet(
          id: 'set-private',
          exerciseRef: const BackupExerciseRef(
            source: 'official',
            id: 'bench',
            displayNameSnapshot: 'Private Bench Name',
            catalogVersionSnapshot: '2026.05.0',
          ),
          repetitions: 5,
          loadKg: 100,
          performedAt: DateTime.utc(2026, 5, 28, 10),
          comment: 'Private comment',
        ),
      ],
      settingsProfile: const BackupSettingsProfile(
        languageOverride: 'system',
        unitPreference: 'metric',
        themePreference: 'system',
        defaultRestSeconds: 90,
        displayName: 'Private Name',
        focusProfile: 'balanced',
        trainingDaysPerWeek: 3,
        sessionDurationMinutes: 45,
        equipmentInventory: <String>['bodyweight'],
      ),
    );

    final redacted = const BackupLogRedactor().redactJsonString(
      backup.toJsonString(),
    );

    expect(redacted, contains('"workoutSets":"[redacted]"'));
    expect(redacted, contains('"settingsProfile":"[redacted]"'));
    expect(redacted, isNot(contains('Private comment')));
    expect(redacted, isNot(contains('Private Name')));
    expect(redacted, isNot(contains('set-private')));
  });
}

BackupValidationException _validationErrorFor(String json) {
  try {
    RepForgeBackup.parseJsonString(json);
  } on BackupValidationException catch (error) {
    return error;
  }
  throw StateError('Expected backup validation to fail.');
}

final class _FakeBackupRepository implements LocalBackupRepository {
  _FakeBackupRepository(this.backup);

  final RepForgeBackup backup;
  final List<RepForgeBackup> importedBackups = <RepForgeBackup>[];

  @override
  Future<RepForgeBackup> exportBackup() async => backup;

  @override
  Future<void> importBackup(RepForgeBackup backup) async {
    importedBackups.add(backup);
  }
}
