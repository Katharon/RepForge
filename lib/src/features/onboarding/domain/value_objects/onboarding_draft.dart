import '../../../settings/domain/settings_domain.dart';

final class OnboardingDraft {
  const OnboardingDraft({
    required this.displayName,
    required this.focusProfile,
    required this.trainingFrequency,
    required this.sessionDuration,
    required this.equipmentInventory,
    required this.createStarterGroups,
  });

  factory OnboardingDraft.defaults() {
    final defaults = SettingsProfile.defaults();
    return OnboardingDraft(
      displayName: defaults.userProfile.displayName,
      focusProfile: defaults.focusProfile,
      trainingFrequency: defaults.trainingFrequency,
      sessionDuration: defaults.sessionDuration,
      equipmentInventory: defaults.equipmentInventory,
      createStarterGroups: true,
    );
  }

  final String? displayName;
  final FocusProfile focusProfile;
  final TrainingFrequency trainingFrequency;
  final SessionDurationPreference sessionDuration;
  final EquipmentInventory equipmentInventory;
  final bool createStarterGroups;

  SettingsProfile applyTo(SettingsProfile profile) {
    return profile.copyWith(
      userProfile: UserProfile(displayName: displayName),
      focusProfile: focusProfile,
      trainingFrequency: trainingFrequency,
      sessionDuration: sessionDuration,
      equipmentInventory: equipmentInventory,
    );
  }

  OnboardingDraft copyWith({
    String? displayName,
    bool clearDisplayName = false,
    FocusProfile? focusProfile,
    TrainingFrequency? trainingFrequency,
    SessionDurationPreference? sessionDuration,
    EquipmentInventory? equipmentInventory,
    bool? createStarterGroups,
  }) {
    return OnboardingDraft(
      displayName: clearDisplayName ? null : displayName ?? this.displayName,
      focusProfile: focusProfile ?? this.focusProfile,
      trainingFrequency: trainingFrequency ?? this.trainingFrequency,
      sessionDuration: sessionDuration ?? this.sessionDuration,
      equipmentInventory: equipmentInventory ?? this.equipmentInventory,
      createStarterGroups: createStarterGroups ?? this.createStarterGroups,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is OnboardingDraft &&
        other.displayName == displayName &&
        other.focusProfile == focusProfile &&
        other.trainingFrequency == trainingFrequency &&
        other.sessionDuration == sessionDuration &&
        other.equipmentInventory == equipmentInventory &&
        other.createStarterGroups == createStarterGroups;
  }

  @override
  int get hashCode => Object.hash(
    displayName,
    focusProfile,
    trainingFrequency,
    sessionDuration,
    equipmentInventory,
    createStarterGroups,
  );
}
