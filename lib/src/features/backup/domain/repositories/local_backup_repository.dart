import '../entities/repforge_backup.dart';

abstract interface class LocalBackupRepository {
  Future<RepForgeBackup> exportBackup();

  Future<void> importBackup(RepForgeBackup backup);
}
