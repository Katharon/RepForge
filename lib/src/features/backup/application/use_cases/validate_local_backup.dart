import '../../domain/backup_domain.dart';

final class ValidateLocalBackup {
  const ValidateLocalBackup();

  BackupValidationResult call(String json) {
    return RepForgeBackup.validateJsonString(json);
  }
}
