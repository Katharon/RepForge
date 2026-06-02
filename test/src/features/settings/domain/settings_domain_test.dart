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
    expect(defaults.userProfile.sexGender, SexGenderPreference.unspecified);
    expect(defaults.userProfile.birthYear, isNull);
    expect(defaults.userProfile.bodyWeightKg, isNull);
    expect(defaults.userProfile.heightCm, isNull);
    expect(defaults.trainingGoal, TrainingGoal.generalFitness);
    expect(defaults.focusProfile, FocusProfile.balanced);
    expect(defaults.trainingFrequency.daysPerWeek, 3);
    expect(defaults.sessionDuration, SessionDurationPreference.fortyFive);
    expect(defaults.recoverySensitivity, RecoverySensitivity.normal);
    expect(defaults.coachingStrictness, CoachingStrictness.balanced);
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

  test('supports a minimal profile with explicit unknown optional fields', () {
    final profile = UserProfile(
      displayName: '  Mira  ',
      sexGender: SexGenderPreference.preferNotToSay,
    );

    expect(profile.displayName, 'Mira');
    expect(profile.sexGender, SexGenderPreference.preferNotToSay);
    expect(profile.birthYear, isNull);
    expect(profile.bodyWeightKg, isNull);
    expect(profile.heightCm, isNull);
  });

  test('validates birth year, body weight, and height bounds', () {
    final currentYear = DateTime.now().toUtc().year;

    expect(BirthYear(1992).value, 1992);
    expect(BodyWeightKg(82.5).value, 82.5);
    expect(HeightCm(181).value, 181);
    expect(
      () => BirthYear(1899),
      throwsA(
        isA<SettingsValidationException>().having(
          (error) => error.field,
          'field',
          'birthYear',
        ),
      ),
    );
    expect(
      () => BirthYear(currentYear + 1),
      throwsA(isA<SettingsValidationException>()),
    );
    expect(
      () => BodyWeightKg(0),
      throwsA(
        isA<SettingsValidationException>().having(
          (error) => error.field,
          'field',
          'bodyWeightKg',
        ),
      ),
    );
    expect(
      () => BodyWeightKg(double.infinity),
      throwsA(isA<SettingsValidationException>()),
    );
    expect(
      () => HeightCm(0),
      throwsA(
        isA<SettingsValidationException>().having(
          (error) => error.field,
          'field',
          'heightCm',
        ),
      ),
    );
    expect(() => HeightCm(301), throwsA(isA<SettingsValidationException>()));
  });

  test('represents goals focus recovery and coaching explicitly', () {
    final profile = SettingsProfile.defaults().copyWith(
      userProfile: UserProfile(sexGender: SexGenderPreference.male),
      trainingGoal: TrainingGoal.hypertrophy,
      focusProfile: FocusProfile.lowerBodyGluteFocus,
      recoverySensitivity: RecoverySensitivity.high,
      coachingStrictness: CoachingStrictness.gentle,
    );

    expect(profile.userProfile.sexGender, SexGenderPreference.male);
    expect(profile.trainingGoal, TrainingGoal.hypertrophy);
    expect(profile.focusProfile, FocusProfile.lowerBodyGluteFocus);
    expect(profile.recoverySensitivity, RecoverySensitivity.high);
    expect(profile.coachingStrictness, CoachingStrictness.gentle);
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

  test('equipment load constraints validate max loads and increments', () {
    final inventory = EquipmentInventory(
      const <AvailableEquipment>[
        AvailableEquipment.barbell,
        AvailableEquipment.dumbbell,
      ],
      loadConstraints: <AvailableEquipment, EquipmentLoadConstraint>{
        AvailableEquipment.barbell: EquipmentLoadConstraint(
          maxLoadKg: MaxLoadKg(180),
          incrementKg: LoadIncrementKg(2.5),
        ),
        AvailableEquipment.dumbbell: EquipmentLoadConstraint(
          incrementKg: LoadIncrementKg(2),
        ),
      },
    );

    expect(
      inventory.loadConstraintFor(AvailableEquipment.barbell)?.maxLoadKg?.value,
      180,
    );
    expect(
      inventory
          .loadConstraintFor(AvailableEquipment.dumbbell)
          ?.incrementKg
          ?.value,
      2,
    );
    expect(
      () => MaxLoadKg(-1),
      throwsA(
        isA<SettingsValidationException>().having(
          (error) => error.field,
          'field',
          'maxLoadKg',
        ),
      ),
    );
    expect(
      () => LoadIncrementKg(0),
      throwsA(
        isA<SettingsValidationException>().having(
          (error) => error.field,
          'field',
          'incrementKg',
        ),
      ),
    );
    expect(
      () => EquipmentLoadConstraint(
        maxLoadKg: MaxLoadKg(20),
        incrementKg: LoadIncrementKg(25),
      ),
      throwsA(isA<SettingsValidationException>()),
    );
    expect(
      () => EquipmentInventory(
        const <AvailableEquipment>[AvailableEquipment.barbell],
        loadConstraints: <AvailableEquipment, EquipmentLoadConstraint>{
          AvailableEquipment.dumbbell: EquipmentLoadConstraint(
            maxLoadKg: MaxLoadKg(40),
          ),
        },
      ),
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
