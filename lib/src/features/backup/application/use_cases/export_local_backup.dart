import '../../domain/backup_domain.dart';

final class ExportLocalBackup {
  const ExportLocalBackup(this._repository);

  static const BackupPrivacyWarning privacyWarning =
      BackupPrivacyWarning.localJsonExport;

  final LocalBackupRepository _repository;

  Future<String> call() async {
    final backup = await _repository.exportBackup();
    return backup.toJsonString();
  }
}
