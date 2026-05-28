import '../../domain/backup_domain.dart';

final class ImportLocalBackup {
  const ImportLocalBackup(this._repository);

  final LocalBackupRepository _repository;

  Future<void> call(String json) async {
    final backup = RepForgeBackup.parseJsonString(json);
    await _repository.importBackup(backup);
  }
}
