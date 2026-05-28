import '../entities/settings_profile.dart';

abstract interface class SettingsProfileRepository {
  Future<SettingsProfile> load();

  Future<void> save(SettingsProfile profile);
}
