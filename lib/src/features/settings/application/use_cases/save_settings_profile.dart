import '../../domain/settings_domain.dart';

final class SaveSettingsProfile {
  const SaveSettingsProfile(this._repository);

  final SettingsProfileRepository _repository;

  Future<void> call(SettingsProfile profile) => _repository.save(profile);
}
