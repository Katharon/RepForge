import '../exceptions/settings_validation_exception.dart';

enum LanguageOverride { system, english, german }

enum UnitPreference { metric, imperial }

enum ThemePreference { system, dark, light }

enum FocusProfile {
  balanced,
  upperBodyFocus,
  lowerBodyGluteFocus,
  armsChestFocus,
  strengthBasics,
  timeEfficient,
  beginnerFoundation,
  custom,
}

enum SessionDurationPreference {
  fifteen(minutes: 15),
  twentyFive(minutes: 25),
  thirtyFive(minutes: 35),
  fortyFive(minutes: 45),
  sixty(minutes: 60),
  seventyFivePlus(minutes: 75);

  const SessionDurationPreference({required this.minutes});

  final int minutes;

  static SessionDurationPreference fromMinutes(int minutes) {
    for (final value in SessionDurationPreference.values) {
      if (value.minutes == minutes) {
        return value;
      }
    }

    throw SettingsValidationException(
      'sessionDurationMinutes',
      'Unsupported session duration.',
    );
  }
}

enum AvailableEquipment {
  bodyweight,
  barbell,
  dumbbell,
  cable,
  machine,
  smithMachine,
  pullUpBar,
  bench,
  legPress,
}
