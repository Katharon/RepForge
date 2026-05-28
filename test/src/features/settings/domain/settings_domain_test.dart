import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';

void main() {
  test('defaults are deterministic and local-first', () {
    final defaults = SettingsProfile.defaults();

    expect(defaults.languageOverride, LanguageOverride.system);
    expect(defaults.unitPreference, UnitPreference.metric);
    expect(defaults.themePreference, ThemePreference.system);
    expect(defaults.defaultRestTime.inSeconds, 90);
    expect(defaults.userProfile.displayName, isNull);
    expect(defaults.focusProfile, FocusProfile.balanced);
    expect(defaults.trainingFrequency.daysPerWeek, 3);
    expect(defaults.sessionDuration, SessionDurationPreference.fortyFive);
    expect(
      defaults.equipmentInventory.items,
      contains(AvailableEquipment.bodyweight),
    );
  });

  test('validates rest time and frequency ranges', () {
    expect(
      () => DefaultRestTime(Duration.zero),
      throwsA(isA<SettingsValidationException>()),
    );
    expect(
      () => DefaultRestTime(const Duration(minutes: 31)),
      throwsA(isA<SettingsValidationException>()),
    );
    expect(
      () => TrainingFrequency(0),
      throwsA(isA<SettingsValidationException>()),
    );
    expect(
      () => TrainingFrequency(8),
      throwsA(isA<SettingsValidationException>()),
    );
  });

  test('normalizes optional profile display name', () {
    expect(UserProfile(displayName: '  Luki  ').displayName, 'Luki');
    expect(UserProfile(displayName: '   ').displayName, isNull);
    expect(
      () => UserProfile(displayName: 'x' * 81),
      throwsA(
        isA<SettingsValidationException>().having(
          (error) => error.field,
          'field',
          'displayName',
        ),
      ),
    );
  });

  test('equipment inventory is structured and non-empty', () {
    final inventory = EquipmentInventory(const <AvailableEquipment>[
      AvailableEquipment.dumbbell,
      AvailableEquipment.bench,
      AvailableEquipment.dumbbell,
    ]);

    expect(inventory.items, hasLength(2));
    expect(inventory.contains(AvailableEquipment.dumbbell), isTrue);
    expect(inventory.contains(AvailableEquipment.barbell), isFalse);
    expect(
      () => EquipmentInventory(const <AvailableEquipment>[]),
      throwsA(isA<SettingsValidationException>()),
    );
  });

  test('session duration only accepts MVP buckets', () {
    expect(
      SessionDurationPreference.fromMinutes(45),
      SessionDurationPreference.fortyFive,
    );
    expect(
      () => SessionDurationPreference.fromMinutes(50),
      throwsA(isA<SettingsValidationException>()),
    );
  });
}
