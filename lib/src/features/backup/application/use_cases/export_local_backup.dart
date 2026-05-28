import '../../domain/backup_domain.dart';

final class ExportLocalBackup {
  const ExportLocalBackup(this._repository);

  final LocalBackupRepository _repository;

  Future<String> call() async {
    final backup = await _repository.exportBackup();
    return backup.toJsonString();
  }
}
