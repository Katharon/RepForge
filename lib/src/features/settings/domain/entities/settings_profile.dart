import '../value_objects/default_rest_time.dart';
import '../value_objects/equipment_inventory.dart';
import '../value_objects/settings_enums.dart';
import '../value_objects/training_frequency.dart';
import 'user_profile.dart';

final class SettingsProfile {
  const SettingsProfile({
    required this.languageOverride,
    required this.unitPreference,
    required this.themePreference,
    required this.defaultRestTime,
    required this.userProfile,
    required this.trainingGoal,
    required this.focusProfile,
    required this.trainingFrequency,
    required this.sessionDuration,
    required this.recoverySensitivity,
    required this.coachingStrictness,
    required this.equipmentInventory,
  });

  factory SettingsProfile.defaults() {
    return SettingsProfile(
      languageOverride: LanguageOverride.system,
      unitPreference: UnitPreference.metric,
      themePreference: ThemePreference.system,
      defaultRestTime: DefaultRestTime.standard,
      userProfile: UserProfile.empty(),
      trainingGoal: TrainingGoal.generalFitness,
      focusProfile: FocusProfile.balanced,
      trainingFrequency: TrainingFrequency(3),
      sessionDuration: SessionDurationPreference.fortyFive,
      recoverySensitivity: RecoverySensitivity.normal,
      coachingStrictness: CoachingStrictness.balanced,
      equipmentInventory: EquipmentInventory.defaults(),
    );
  }

  final LanguageOverride languageOverride;
  final UnitPreference unitPreference;
  final ThemePreference themePreference;
  final DefaultRestTime defaultRestTime;
  final UserProfile userProfile;
  final TrainingGoal trainingGoal;
  final FocusProfile focusProfile;
  final TrainingFrequency trainingFrequency;
  final SessionDurationPreference sessionDuration;
  final RecoverySensitivity recoverySensitivity;
  final CoachingStrictness coachingStrictness;
  final EquipmentInventory equipmentInventory;

  SettingsProfile copyWith({
    LanguageOverride? languageOverride,
    UnitPreference? unitPreference,
    ThemePreference? themePreference,
    DefaultRestTime? defaultRestTime,
    UserProfile? userProfile,
    TrainingGoal? trainingGoal,
    FocusProfile? focusProfile,
    TrainingFrequency? trainingFrequency,
    SessionDurationPreference? sessionDuration,
    RecoverySensitivity? recoverySensitivity,
    CoachingStrictness? coachingStrictness,
    EquipmentInventory? equipmentInventory,
  }) {
    return SettingsProfile(
      languageOverride: languageOverride ?? this.languageOverride,
      unitPreference: unitPreference ?? this.unitPreference,
      themePreference: themePreference ?? this.themePreference,
      defaultRestTime: defaultRestTime ?? this.defaultRestTime,
      userProfile: userProfile ?? this.userProfile,
      trainingGoal: trainingGoal ?? this.trainingGoal,
      focusProfile: focusProfile ?? this.focusProfile,
      trainingFrequency: trainingFrequency ?? this.trainingFrequency,
      sessionDuration: sessionDuration ?? this.sessionDuration,
      recoverySensitivity: recoverySensitivity ?? this.recoverySensitivity,
      coachingStrictness: coachingStrictness ?? this.coachingStrictness,
      equipmentInventory: equipmentInventory ?? this.equipmentInventory,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SettingsProfile &&
        other.languageOverride == languageOverride &&
        other.unitPreference == unitPreference &&
        other.themePreference == themePreference &&
        other.defaultRestTime == defaultRestTime &&
        other.userProfile == userProfile &&
        other.trainingGoal == trainingGoal &&
        other.focusProfile == focusProfile &&
        other.trainingFrequency == trainingFrequency &&
        other.sessionDuration == sessionDuration &&
        other.recoverySensitivity == recoverySensitivity &&
        other.coachingStrictness == coachingStrictness &&
        other.equipmentInventory == equipmentInventory;
  }

  @override
  int get hashCode => Object.hash(
    languageOverride,
    unitPreference,
    themePreference,
    defaultRestTime,
    userProfile,
    trainingGoal,
    focusProfile,
    trainingFrequency,
    sessionDuration,
    recoverySensitivity,
    coachingStrictness,
    equipmentInventory,
  );
}
