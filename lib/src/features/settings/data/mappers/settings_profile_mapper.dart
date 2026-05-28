import 'package:drift/drift.dart';

import '../../../../shared/data/local/repforge_database.dart';
import '../../domain/settings_domain.dart';

const settingsProfileStorageId = 'local';

final class SettingsProfileMapper {
  const SettingsProfileMapper._();

  static SettingsProfilesCompanion toProfileCompanion(SettingsProfile profile) {
    return SettingsProfilesCompanion.insert(
      profileId: settingsProfileStorageId,
      languageOverride: _languageToStorage(profile.languageOverride),
      unitPreference: _unitToStorage(profile.unitPreference),
      themePreference: _themeToStorage(profile.themePreference),
      defaultRestSeconds: profile.defaultRestTime.inSeconds,
      displayName: Value<String?>(profile.userProfile.displayName),
      focusProfile: _focusToStorage(profile.focusProfile),
      trainingDaysPerWeek: profile.trainingFrequency.daysPerWeek,
      sessionDurationMinutes: profile.sessionDuration.minutes,
    );
  }

  static EquipmentInventoryItemsCompanion toEquipmentCompanion(
    AvailableEquipment equipment,
  ) {
    return EquipmentInventoryItemsCompanion.insert(
      profileId: settingsProfileStorageId,
      equipment: _equipmentToStorage(equipment),
    );
  }

  static SettingsProfile toDomain({
    required SettingsProfileRow row,
    required List<EquipmentInventoryItemRow> equipmentRows,
  }) {
    return SettingsProfile(
      languageOverride: _languageFromStorage(row.languageOverride),
      unitPreference: _unitFromStorage(row.unitPreference),
      themePreference: _themeFromStorage(row.themePreference),
      defaultRestTime: DefaultRestTime.seconds(row.defaultRestSeconds),
      userProfile: UserProfile(displayName: row.displayName),
      focusProfile: _focusFromStorage(row.focusProfile),
      trainingFrequency: TrainingFrequency(row.trainingDaysPerWeek),
      sessionDuration: SessionDurationPreference.fromMinutes(
        row.sessionDurationMinutes,
      ),
      equipmentInventory: EquipmentInventory(
        equipmentRows.map((row) => _equipmentFromStorage(row.equipment)),
      ),
    );
  }
}

String _languageToStorage(LanguageOverride value) {
  return switch (value) {
    LanguageOverride.system => 'system',
    LanguageOverride.english => 'en',
    LanguageOverride.german => 'de',
  };
}

LanguageOverride _languageFromStorage(String value) {
  return switch (value) {
    'system' => LanguageOverride.system,
    'en' => LanguageOverride.english,
    'de' => LanguageOverride.german,
    _ => throw SettingsValidationException(
      'languageOverride',
      'Unsupported stored language override.',
    ),
  };
}

String _unitToStorage(UnitPreference value) {
  return switch (value) {
    UnitPreference.metric => 'metric',
    UnitPreference.imperial => 'imperial',
  };
}

UnitPreference _unitFromStorage(String value) {
  return switch (value) {
    'metric' => UnitPreference.metric,
    'imperial' => UnitPreference.imperial,
    _ => throw SettingsValidationException(
      'unitPreference',
      'Unsupported stored unit preference.',
    ),
  };
}

String _themeToStorage(ThemePreference value) => value.name;

ThemePreference _themeFromStorage(String value) {
  return switch (value) {
    'system' => ThemePreference.system,
    'dark' => ThemePreference.dark,
    'light' => ThemePreference.light,
    _ => throw SettingsValidationException(
      'themePreference',
      'Unsupported stored theme preference.',
    ),
  };
}

String _focusToStorage(FocusProfile value) => value.name;

FocusProfile _focusFromStorage(String value) {
  for (final focus in FocusProfile.values) {
    if (focus.name == value) {
      return focus;
    }
  }

  throw SettingsValidationException(
    'focusProfile',
    'Unsupported stored focus profile.',
  );
}

String _equipmentToStorage(AvailableEquipment value) => value.name;

AvailableEquipment _equipmentFromStorage(String value) {
  for (final equipment in AvailableEquipment.values) {
    if (equipment.name == value) {
      return equipment;
    }
  }

  throw SettingsValidationException(
    'equipmentInventory',
    'Unsupported stored equipment option.',
  );
}
