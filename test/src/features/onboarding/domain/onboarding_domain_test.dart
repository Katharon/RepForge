import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/onboarding/domain/onboarding_domain.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';

void main() {
  test('default draft keeps onboarding skippable and usable', () {
    final draft = OnboardingDraft.defaults();

    expect(draft.displayName, isNull);
    expect(draft.focusProfile, FocusProfile.balanced);
    expect(draft.trainingFrequency.daysPerWeek, 3);
    expect(draft.sessionDuration, SessionDurationPreference.fortyFive);
    expect(
      draft.equipmentInventory.contains(AvailableEquipment.bodyweight),
      isTrue,
    );
    expect(draft.createStarterGroups, isTrue);
  });

  test('status defaults to not started and should show onboarding', () {
    final status = OnboardingStatus.notStarted();

    expect(status.completion, OnboardingCompletion.notStarted);
    expect(status.shouldShowOnboarding, isTrue);
  });

  test('draft applies answers to settings profile', () {
    final profile = OnboardingDraft.defaults()
        .copyWith(
          displayName: 'Mira',
          focusProfile: FocusProfile.timeEfficient,
          trainingFrequency: TrainingFrequency(4),
          sessionDuration: SessionDurationPreference.sixty,
          equipmentInventory: EquipmentInventory(const <AvailableEquipment>[
            AvailableEquipment.dumbbell,
            AvailableEquipment.bench,
          ]),
        )
        .applyTo(SettingsProfile.defaults());

    expect(profile.userProfile.displayName, 'Mira');
    expect(profile.focusProfile, FocusProfile.timeEfficient);
    expect(profile.trainingFrequency.daysPerWeek, 4);
    expect(profile.sessionDuration, SessionDurationPreference.sixty);
    expect(
      profile.equipmentInventory.contains(AvailableEquipment.bench),
      isTrue,
    );
  });
}
