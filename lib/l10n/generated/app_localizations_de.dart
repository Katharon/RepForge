// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'RepForge';

  @override
  String get homePlaceholderTitle => 'RepForge';

  @override
  String get homePlaceholderMessage =>
      'Lokales Workout-Tracking entsteht Schritt fuer Schritt.';

  @override
  String get navToday => 'Heute';

  @override
  String get navGroups => 'Gruppen';

  @override
  String get navExercises => 'Uebungen';

  @override
  String get navAnalytics => 'Analyse';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get todayPlaceholderMessage =>
      'Heute wartet auf den naechsten Tracking-Slice.';

  @override
  String get groupsPlaceholderMessage =>
      'Workout-Gruppen werden in einem spaeteren Slice verbunden.';

  @override
  String get exercisesPlaceholderMessage =>
      'Uebungen nutzen spaeter den gebuendelten Katalog und eigene Eintraege.';

  @override
  String get analyticsPlaceholderMessage =>
      'Analysen zeigen spaeter lokale Trainingstrends.';

  @override
  String get settingsPlaceholderMessage =>
      'Einstellungen bleiben bei der Umsetzung lokal-first.';
}
