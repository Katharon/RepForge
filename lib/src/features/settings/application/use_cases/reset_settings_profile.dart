import '../../domain/settings_domain.dart';

final class ResetSettingsProfile {
  const ResetSettingsProfile(this._repository);

  final SettingsProfileRepository _repository;

  Future<SettingsProfile> call() async {
    final defaults = SettingsProfile.defaults();
    await _repository.save(defaults);
    return defaults;
  }
}
