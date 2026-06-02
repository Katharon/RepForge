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
  String get todayDashboardTitle => 'Today';

  @override
  String get todayLoading => 'Loading today';

  @override
  String get todayEmptyTitle => 'No sets logged today';

  @override
  String get todayEmptyMessage =>
      'Your daily summary will fill in as soon as sets are logged.';

  @override
  String get todayErrorTitle => 'Today could not load';

  @override
  String get todayErrorMessage => 'Try again without changing local data.';

  @override
  String get todayRetry => 'Retry';

  @override
  String get todaySetCount => 'Sets today';

  @override
  String get todayVolume => 'Volume today';

  @override
  String get todayLastLoggedTitle => 'Last logged';

  @override
  String get todayNoLastLoggedSet => 'No set yet';

  @override
  String todayLastLoggedSetSummary(
    String exercise,
    int repetitions,
    String load,
  ) {
    return '$exercise: $repetitions reps at $load';
  }

  @override
  String get todayRestTimerTitle => 'Rest timer';

  @override
  String get todayRestTimerIdle => 'No active rest timer';

  @override
  String get todayRestTimerRunning => 'Resting';

  @override
  String get todayRestTimerFinished => 'Rest complete';

  @override
  String get todayQuickActionTitle => 'Quick action';

  @override
  String get todayQuickActionLogSet => 'Log set';

  @override
  String get todayQuickActionPlaceholder =>
      'Quick logging will connect here in a later tracking slice.';

  @override
  String get todayAnalyticsHintTitle => 'Training signal';

  @override
  String get todayAnalyticsHintMessage =>
      'Local trends stay in Analytics while today\'s work stays here.';

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
  String get settingsLoading => 'Loading settings';

  @override
  String get settingsErrorTitle => 'Settings could not load';

  @override
  String get settingsErrorMessage => 'Try again without changing local data.';

  @override
  String get settingsRetry => 'Retry';

  @override
  String get settingsUsingDefaults => 'Using local defaults';

  @override
  String get settingsSaved => 'Saved locally';

  @override
  String get settingsSave => 'Save settings';

  @override
  String get settingsSaving => 'Saving';

  @override
  String get settingsReset => 'Reset to defaults';

  @override
  String get settingsAppPreferencesTitle => 'App preferences';

  @override
  String get settingsProfileTitle => 'Profile basics';

  @override
  String get settingsTrainingTitle => 'Training preferences';

  @override
  String get settingsEquipmentTitle => 'Available equipment';

  @override
  String get settingsLanguageLabel => 'Language';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageGerman => 'German';

  @override
  String get settingsUnitsLabel => 'Units';

  @override
  String get settingsUnitsMetric => 'Metric';

  @override
  String get settingsUnitsImperial => 'Imperial';

  @override
  String get settingsThemeLabel => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsDisplayNameLabel => 'Profile name';

  @override
  String get settingsDefaultRestLabel => 'Default rest';

  @override
  String settingsSeconds(int seconds) {
    return '$seconds sec';
  }

  @override
  String get settingsFocusLabel => 'Focus profile';

  @override
  String get settingsFocusBalanced => 'Balanced';

  @override
  String get settingsFocusUpperBody => 'Upper-body focus';

  @override
  String get settingsFocusLowerBody => 'Lower-body/glute focus';

  @override
  String get settingsFocusArmsChest => 'Arms/chest focus';

  @override
  String get settingsFocusStrengthBasics => 'Strength basics';

  @override
  String get settingsFocusTimeEfficient => 'Time-efficient';

  @override
  String get settingsFocusBeginnerFoundation => 'Beginner foundation';

  @override
  String get settingsFocusCustom => 'Custom';

  @override
  String get settingsTrainingFrequencyLabel => 'Training frequency';

  @override
  String settingsDaysPerWeek(int days) {
    return '$days days/week';
  }

  @override
  String get settingsSessionDurationLabel => 'Session duration';

  @override
  String settingsMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get settingsEquipmentBodyweight => 'Bodyweight';

  @override
  String get settingsEquipmentBarbell => 'Barbell';

  @override
  String get settingsEquipmentDumbbell => 'Dumbbell';

  @override
  String get settingsEquipmentCable => 'Cable';

  @override
  String get settingsEquipmentMachine => 'Machine';

  @override
  String get settingsEquipmentSmithMachine => 'Smith machine';

  @override
  String get settingsEquipmentPullUpBar => 'Pull-up bar';

  @override
  String get settingsEquipmentBench => 'Bench';

  @override
  String get settingsEquipmentRack => 'Rack';

  @override
  String get settingsEquipmentLegPress => 'Leg press';

  @override
  String get onboardingTitle => 'Setup';

  @override
  String get onboardingLoading => 'Preparing setup';

  @override
  String get onboardingWelcomeTitle => 'Set up RepForge';

  @override
  String get onboardingWelcomeMessage =>
      'Choose a few local preferences now or skip and start tracking.';

  @override
  String get onboardingStart => 'Start setup';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingProfileTitle => 'Profile and focus';

  @override
  String get onboardingTrainingTitle => 'Training rhythm';

  @override
  String get onboardingEquipmentTitle => 'Equipment';

  @override
  String get onboardingStarterGroupsTitle => 'Create starter groups';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingComplete => 'Save setup';

  @override
  String get onboardingSavedTitle => 'Setup saved';

  @override
  String get onboardingSavedMessage =>
      'Your choices are stored locally and can be changed in Settings.';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingErrorTitle => 'Setup could not save';

  @override
  String get onboardingErrorMessage => 'Try again without changing local data.';

  @override
  String get settingsPlaceholderMessage =>
      'Settings will stay local-first when implemented.';
}
