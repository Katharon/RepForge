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
  String get todayReadinessTitle => 'Readiness estimate';

  @override
  String get todayReadinessUnavailable => 'No check-in today';

  @override
  String get todayReadinessNoScore => '--';

  @override
  String todayReadinessScore(int score) {
    return '$score / 100';
  }

  @override
  String get todayReadinessHigh => 'High';

  @override
  String get todayReadinessMedium => 'Medium';

  @override
  String get todayReadinessLow => 'Low';

  @override
  String get todayReadinessVeryLow => 'Very low';

  @override
  String get todayReadinessEstimateNote =>
      'Estimate based on your latest local check-in.';

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
  String get todayQuickActionMessage =>
      'Choose an exercise, enter load and reps, and save the set locally.';

  @override
  String get todayAnalyticsHintTitle => 'Training signal';

  @override
  String get todayAnalyticsHintMessage =>
      'Local trends stay in Analytics while today\'s work stays here.';

  @override
  String get groupsLoading => 'Loading groups';

  @override
  String get groupsEmptyTitle => 'No groups yet';

  @override
  String get groupsEmptyMessage =>
      'Complete onboarding to create starter groups, or add groups in a later editing flow.';

  @override
  String get groupsErrorTitle => 'Groups could not load';

  @override
  String get groupsErrorMessage => 'Try again without changing local data.';

  @override
  String groupsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count groups',
      one: '1 group',
    );
    return '$_temp0';
  }

  @override
  String groupsExerciseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercises assigned',
      one: '1 exercise assigned',
      zero: 'No exercises assigned',
    );
    return '$_temp0';
  }

  @override
  String groupsSemanticsLabel(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercises',
      one: '1 exercise',
      zero: 'no exercises',
    );
    return '$name, $_temp0';
  }

  @override
  String get groupsCoachPreviewTitle => 'Coach preview';

  @override
  String get groupsCoachPreviewMessage =>
      'Recommendations can use local groups, readiness, equipment, and balance signals when enough inputs are available.';

  @override
  String get exercisesLoading => 'Loading exercises';

  @override
  String get exercisesSearchLabel => 'Search exercises';

  @override
  String get exercisesSearchTooltip => 'Search';

  @override
  String get exercisesEmptyTitle => 'No exercises found';

  @override
  String get exercisesEmptyMessage =>
      'Try a different search or import the bundled catalog again.';

  @override
  String get exercisesErrorTitle => 'Exercises could not load';

  @override
  String get exercisesErrorMessage => 'Try again without changing local data.';

  @override
  String exercisesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercises',
      one: '1 exercise',
    );
    return '$_temp0';
  }

  @override
  String get exercisesMoreTitle => 'More exercises available';

  @override
  String get exercisesMoreMessage => 'Use search to narrow the local catalog.';

  @override
  String get quickLogTitle => 'Log set';

  @override
  String get quickLogExerciseSearchLabel => 'Exercise';

  @override
  String get quickLogNoExercises => 'No exercises available.';

  @override
  String get quickLogLoadLabel => 'Load (kg)';

  @override
  String get quickLogRepetitionsLabel => 'Reps';

  @override
  String get quickLogLabelLabel => 'Label';

  @override
  String get quickLogCommentLabel => 'Comment';

  @override
  String get quickLogCancel => 'Cancel';

  @override
  String get quickLogSave => 'Save set';

  @override
  String get quickLogSaveError => 'Check the set details and try again.';

  @override
  String get quickLogLabelNone => 'None';

  @override
  String get quickLogLabelWarmup => 'Warm-up';

  @override
  String get quickLogLabelFailure => 'Failure';

  @override
  String get quickLogLabelPersonalRecord => 'Personal record';

  @override
  String get quickLogLabelDropSet => 'Drop set';

  @override
  String get quickLogLabelPain => 'Pain note';

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
