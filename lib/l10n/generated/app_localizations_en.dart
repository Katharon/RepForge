// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'RepForge';

  @override
  String get homePlaceholderTitle => 'RepForge';

  @override
  String get homePlaceholderMessage =>
      'Local-first workout tracking is being forged.';

  @override
  String get navToday => 'Today';

  @override
  String get navGroups => 'Groups';

  @override
  String get navExercises => 'Exercises';

  @override
  String get navAnalytics => 'Analytics';

  @override
  String get navSettings => 'Settings';

  @override
  String get todayPlaceholderMessage =>
      'Today is ready for the next tracking slice.';

  @override
  String get groupsPlaceholderMessage =>
      'Workout groups will be connected in a later slice.';

  @override
  String get exercisesPlaceholderMessage =>
      'Exercises will use the bundled catalog and custom entries.';

  @override
  String get analyticsPlaceholderMessage =>
      'Analytics will show local training trends later.';

  @override
  String get settingsPlaceholderMessage =>
      'Settings will stay local-first when implemented.';
}
