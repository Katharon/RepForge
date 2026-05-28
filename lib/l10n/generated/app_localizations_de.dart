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
  String get analyticsMetricSets => 'Saetze';

  @override
  String get analyticsMetricRepetitions => 'Wdh.';

  @override
  String get analyticsMetricVolume => 'Volumen';

  @override
  String get analyticsMetricKgPerRep => 'kg/Wdh.';

  @override
  String get analyticsMetricEstimatedOneRepMax => 'Geschaetztes 1RM';

  @override
  String get analyticsEstimatedOneRepMaxTitle => 'Geschaetztes 1RM';

  @override
  String get analyticsEstimatedOneRepMaxCurrentLabel => 'Bester Schaetzwert';

  @override
  String get analyticsEstimatedOneRepMaxPreviousLabel => 'Vorheriger Zeitraum';

  @override
  String get analyticsEstimatedOneRepMaxUnavailableTitle =>
      'Noch kein geschaetztes 1RM';

  @override
  String get analyticsEstimatedOneRepMaxUnavailableMessage =>
      'Protokolliere einen Satz in diesem Zeitraum, um die Epley-Schaetzung zu berechnen.';

  @override
  String get analyticsFormulaLabel => 'Formel';

  @override
  String analyticsFormulaEpley(int version) {
    return 'Epley v$version';
  }

  @override
  String get analyticsUnitKilograms => 'kg';

  @override
  String get analyticsUnitKilogramsPerRep => 'kg/Wdh.';

  @override
  String get analyticsRangeSevenDays => '7T';

  @override
  String get analyticsRangeThirtyDays => '30T';

  @override
  String get analyticsRangeNinetyDays => '90T';

  @override
  String get analyticsLoading => 'Analysen werden geladen';

  @override
  String get analyticsEmptyTitle => 'Keine Saetze in diesem Zeitraum';

  @override
  String get analyticsEmptyMessage =>
      'Protokolliere Saetze fuer diese Uebung, um lokale Trends zu sehen.';

  @override
  String get analyticsErrorTitle => 'Analyse konnte nicht geladen werden';

  @override
  String get analyticsErrorMessage =>
      'Versuche es erneut, ohne lokale Daten zu aendern.';

  @override
  String get analyticsRetry => 'Erneut versuchen';

  @override
  String get analyticsSummaryTitle => 'Zusammenfassung';

  @override
  String analyticsChartTitle(String metric) {
    return '$metric-Trend';
  }

  @override
  String get analyticsCurrentPeriod => 'Aktuell';

  @override
  String get analyticsPreviousPeriod => 'Vorher';

  @override
  String get settingsPlaceholderMessage =>
      'Einstellungen bleiben bei der Umsetzung lokal-first.';
}
