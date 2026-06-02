import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/settings/application/settings_application.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';

void main() {
  test('load returns repository profile', () async {
    final repository = _FakeSettingsProfileRepository(
      SettingsProfile.defaults().copyWith(
        focusProfile: FocusProfile.timeEfficient,
      ),
    );

    final profile = await LoadSettingsProfile(repository)();

    expect(profile.focusProfile, FocusProfile.timeEfficient);
  });

  test('save delegates profile to repository', () async {
    final repository = _FakeSettingsProfileRepository(
      SettingsProfile.defaults(),
    );
    final edited = SettingsProfile.defaults().copyWith(
      trainingFrequency: TrainingFrequency(5),
    );

    await SaveSettingsProfile(repository)(edited);

    expect(repository.savedProfile, edited);
  });

  test('validate equipment inventory returns structured valid inventory', () {
    final inventory = EquipmentInventory(
      const <AvailableEquipment>[AvailableEquipment.barbell],
      loadConstraints: <AvailableEquipment, EquipmentLoadConstraint>{
        AvailableEquipment.barbell: EquipmentLoadConstraint(
          maxLoadKg: MaxLoadKg(120),
          incrementKg: LoadIncrementKg(2.5),
        ),
      },
    );

    expect(ValidateEquipmentInventory()(inventory), inventory);
  });

  test('reset saves and returns defaults', () async {
    final repository = _FakeSettingsProfileRepository(
      SettingsProfile.defaults().copyWith(
        unitPreference: UnitPreference.imperial,
      ),
    );

    final reset = await ResetSettingsProfile(repository)();

    expect(reset, SettingsProfile.defaults());
    expect(repository.savedProfile, SettingsProfile.defaults());
  });
}

final class _FakeSettingsProfileRepository
    implements SettingsProfileRepository {
  _FakeSettingsProfileRepository(this.profile);

  SettingsProfile profile;
  SettingsProfile? savedProfile;

  @override
  Future<SettingsProfile> load() async => profile;

  @override
  Future<void> save(SettingsProfile profile) async {
    savedProfile = profile;
    this.profile = profile;
  }
}
