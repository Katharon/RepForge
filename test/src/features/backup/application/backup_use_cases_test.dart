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
