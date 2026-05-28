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
  String get analyticsMetricSets => 'Sets';

  @override
  String get analyticsMetricRepetitions => 'Reps';

  @override
  String get analyticsMetricVolume => 'Volume';

  @override
  String get analyticsMetricKgPerRep => 'kg/rep';

  @override
  String get analyticsMetricEstimatedOneRepMax => 'Est. 1RM';

  @override
  String get analyticsEstimatedOneRepMaxTitle => 'Estimated 1RM';

  @override
  String get analyticsEstimatedOneRepMaxCurrentLabel => 'Best estimate';

  @override
  String get analyticsEstimatedOneRepMaxPreviousLabel => 'Previous window';

  @override
  String get analyticsEstimatedOneRepMaxUnavailableTitle =>
      'No estimated 1RM yet';

  @override
  String get analyticsEstimatedOneRepMaxUnavailableMessage =>
      'Log a set in this range to calculate the Epley estimate.';

  @override
  String get analyticsFormulaLabel => 'Formula';

  @override
  String analyticsFormulaEpley(int version) {
    return 'Epley v$version';
  }

  @override
  String get analyticsUnitKilograms => 'kg';

  @override
  String get analyticsUnitKilogramsPerRep => 'kg/rep';

  @override
  String get analyticsRangeSevenDays => '7D';

  @override
  String get analyticsRangeThirtyDays => '30D';

  @override
  String get analyticsRangeNinetyDays => '90D';

  @override
  String get analyticsLoading => 'Loading analytics';

  @override
  String get analyticsEmptyTitle => 'No sets in this range';

  @override
  String get analyticsEmptyMessage =>
      'Log sets for this exercise to see local trends.';

  @override
  String get analyticsErrorTitle => 'Analytics could not load';

  @override
  String get analyticsErrorMessage =>
      'Try again without changing your local data.';

  @override
  String get analyticsRetry => 'Retry';

  @override
  String get analyticsSummaryTitle => 'Summary';

  @override
  String analyticsChartTitle(String metric) {
    return '$metric trend';
  }

  @override
  String get analyticsCurrentPeriod => 'Current';

  @override
  String get analyticsPreviousPeriod => 'Previous';

  @override
  String get settingsPlaceholderMessage =>
      'Settings will stay local-first when implemented.';
}
