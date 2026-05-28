import '../../domain/settings_domain.dart';

final class LoadSettingsProfile {
  const LoadSettingsProfile(this._repository);

  final SettingsProfileRepository _repository;

  Future<SettingsProfile> call() => _repository.load();
}
