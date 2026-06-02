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
      sexGender: Value<String?>(_sexGenderToStorage(profile.userProfile)),
      birthYear: Value<int?>(profile.userProfile.birthYear?.value),
      bodyWeightKg: Value<double?>(profile.userProfile.bodyWeightKg?.value),
      heightCm: Value<double?>(profile.userProfile.heightCm?.value),
      trainingGoal: Value<String>(_trainingGoalToStorage(profile.trainingGoal)),
      focusProfile: _focusToStorage(profile.focusProfile),
      trainingDaysPerWeek: profile.trainingFrequency.daysPerWeek,
      sessionDurationMinutes: profile.sessionDuration.minutes,
      recoverySensitivity: Value<String>(
        _recoverySensitivityToStorage(profile.recoverySensitivity),
      ),
      coachingStrictness: Value<String>(
        _coachingStrictnessToStorage(profile.coachingStrictness),
      ),
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

  static EquipmentLoadConstraintsCompanion toLoadConstraintCompanion(
    AvailableEquipment equipment,
    EquipmentLoadConstraint constraint,
  ) {
    return EquipmentLoadConstraintsCompanion.insert(
      profileId: settingsProfileStorageId,
      equipment: _equipmentToStorage(equipment),
      maxLoadKg: Value<double?>(constraint.maxLoadKg?.value),
      incrementKg: Value<double?>(constraint.incrementKg?.value),
    );
  }

  static SettingsProfile toDomain({
    required SettingsProfileRow row,
    required List<EquipmentInventoryItemRow> equipmentRows,
    List<EquipmentLoadConstraintRow> loadConstraintRows =
        const <EquipmentLoadConstraintRow>[],
  }) {
    return SettingsProfile(
      languageOverride: _languageFromStorage(row.languageOverride),
      unitPreference: _unitFromStorage(row.unitPreference),
      themePreference: _themeFromStorage(row.themePreference),
      defaultRestTime: DefaultRestTime.seconds(row.defaultRestSeconds),
      userProfile: UserProfile(
        displayName: row.displayName,
        sexGender: _sexGenderFromStorage(row.sexGender),
        birthYear: row.birthYear == null ? null : BirthYear(row.birthYear!),
        bodyWeightKg: row.bodyWeightKg == null
            ? null
            : BodyWeightKg(row.bodyWeightKg!),
        heightCm: row.heightCm == null ? null : HeightCm(row.heightCm!),
      ),
      trainingGoal: _trainingGoalFromStorage(row.trainingGoal),
      focusProfile: _focusFromStorage(row.focusProfile),
      trainingFrequency: TrainingFrequency(row.trainingDaysPerWeek),
      sessionDuration: SessionDurationPreference.fromMinutes(
        row.sessionDurationMinutes,
      ),
      recoverySensitivity: _recoverySensitivityFromStorage(
        row.recoverySensitivity,
      ),
      coachingStrictness: _coachingStrictnessFromStorage(
        row.coachingStrictness,
      ),
      equipmentInventory: EquipmentInventory(
        equipmentRows.map((row) => _equipmentFromStorage(row.equipment)),
        loadConstraints: _loadConstraintsFromStorage(loadConstraintRows),
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

String? _sexGenderToStorage(UserProfile profile) {
  return profile.sexGender == SexGenderPreference.unspecified
      ? null
      : profile.sexGender.name;
}

SexGenderPreference _sexGenderFromStorage(String? value) {
  if (value == null) {
    return SexGenderPreference.unspecified;
  }
  for (final sexGender in SexGenderPreference.values) {
    if (sexGender.name == value) {
      return sexGender;
    }
  }

  throw SettingsValidationException(
    'sexGender',
    'Unsupported stored sex/gender preference.',
  );
}

String _trainingGoalToStorage(TrainingGoal value) => value.name;

TrainingGoal _trainingGoalFromStorage(String value) {
  for (final goal in TrainingGoal.values) {
    if (goal.name == value) {
      return goal;
    }
  }

  throw SettingsValidationException(
    'trainingGoal',
    'Unsupported stored training goal.',
  );
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

String _recoverySensitivityToStorage(RecoverySensitivity value) => value.name;

RecoverySensitivity _recoverySensitivityFromStorage(String value) {
  for (final sensitivity in RecoverySensitivity.values) {
    if (sensitivity.name == value) {
      return sensitivity;
    }
  }

  throw SettingsValidationException(
    'recoverySensitivity',
    'Unsupported stored recovery sensitivity.',
  );
}

String _coachingStrictnessToStorage(CoachingStrictness value) => value.name;

CoachingStrictness _coachingStrictnessFromStorage(String value) {
  for (final strictness in CoachingStrictness.values) {
    if (strictness.name == value) {
      return strictness;
    }
  }

  throw SettingsValidationException(
    'coachingStrictness',
    'Unsupported stored coaching strictness.',
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

Map<AvailableEquipment, EquipmentLoadConstraint> _loadConstraintsFromStorage(
  List<EquipmentLoadConstraintRow> rows,
) {
  return <AvailableEquipment, EquipmentLoadConstraint>{
    for (final row in rows)
      _equipmentFromStorage(row.equipment): EquipmentLoadConstraint(
        maxLoadKg: row.maxLoadKg == null ? null : MaxLoadKg(row.maxLoadKg!),
        incrementKg: row.incrementKg == null
            ? null
            : LoadIncrementKg(row.incrementKg!),
      ),
  };
}
