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
  String get navGroups => 'Train';

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
  String get trainLoading => 'Loading training';

  @override
  String get trainEmptyTitle => 'No training categories ready';

  @override
  String get trainEmptyMessage => 'Complete catalog import and try again.';

  @override
  String get trainErrorTitle => 'Training could not load';

  @override
  String get trainErrorMessage => 'Try again without changing local data.';

  @override
  String get trainNewWorkout => 'New workout';

  @override
  String get trainNewWorkoutUnavailable =>
      'Full session flow lands later. For now, choose a split below or log a set from Today.';

  @override
  String get trainSplitsTitle => 'Training splits';

  @override
  String get trainStarterGroupsTitle => 'Starter groups';

  @override
  String trainExerciseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercises',
      one: '1 exercise',
    );
    return '$_temp0';
  }

  @override
  String trainCategorySemanticsLabel(String name, int count) {
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
  String trainExerciseSemanticsLabel(String name) {
    return 'Exercise $name';
  }

  @override
  String get trainBackToSplits => 'Back to splits';

  @override
  String get trainSearchLabel => 'Search this split';

  @override
  String get trainSearchTooltip => 'Search split';

  @override
  String get trainCategoryEmptyTitle => 'No exercises in this split';

  @override
  String get trainCategoryEmptyMessage =>
      'Try a different search or use My Exercises.';

  @override
  String get trainCategoryMyExercises => 'My Exercises';

  @override
  String get trainCategoryFullBody => 'Full Body';

  @override
  String get trainCategoryUpperBody => 'Upper Body';

  @override
  String get trainCategoryLowerBody => 'Lower Body';

  @override
  String get trainCategoryPush => 'Push';

  @override
  String get trainCategoryPull => 'Pull';

  @override
  String get trainCategoryLegs => 'Legs';

  @override
  String get trainCategoryCore => 'Core';

  @override
  String get trainCategoryMyExercisesDescription =>
      'All available local catalog exercises.';

  @override
  String get trainCategoryFullBodyDescription =>
      'Broad compound patterns for whole-session coverage.';

  @override
  String get trainCategoryUpperBodyDescription =>
      'Pressing, pulling, shoulders, chest, back, and arms.';

  @override
  String get trainCategoryLowerBodyDescription =>
      'Squat, hinge, glute, quad, and hamstring work.';

  @override
  String get trainCategoryPushDescription =>
      'Chest, shoulder, triceps, and push-pattern work.';

  @override
  String get trainCategoryPullDescription =>
      'Back, lats, biceps, rear delts, and pull patterns.';

  @override
  String get trainCategoryLegsDescription =>
      'Lower-body squat, lunge, and hinge exercises.';

  @override
  String get trainCategoryCoreDescription =>
      'Core-focused work when catalog metadata supports it.';

  @override
  String get exerciseDetailLoading => 'Loading exercise detail';

  @override
  String get exerciseDetailErrorTitle => 'Exercise detail could not load';

  @override
  String get exerciseDetailErrorMessage =>
      'Try again without changing local data.';

  @override
  String get exerciseDetailAnalyticsTitle => 'Analytics';

  @override
  String get exerciseDetailAnalyticsMessage =>
      'Open chart trends for this exercise.';

  @override
  String get exerciseDetailOneRepMaxTitle => '1RM';

  @override
  String get exerciseDetailOneRepMaxMessage => 'Open the estimated 1RM chart.';

  @override
  String get exerciseDetailComparedTitle => 'Compared to previous';

  @override
  String get exerciseDetailComparedAvailable =>
      'Current session compared with the previous comparable session.';

  @override
  String get exerciseDetailComparedUnavailable =>
      'Previous session unavailable';

  @override
  String get exerciseDetailUnavailable => 'Unavailable';

  @override
  String get exerciseDetailAdaptiveSuggestionTitle => 'Next set signal';

  @override
  String get exerciseDetailAdaptiveSuggestionAddWeight => 'Add weight';

  @override
  String get exerciseDetailAdaptiveSuggestionAddReps => 'Add reps';

  @override
  String get exerciseDetailAdaptiveSuggestionMaintain => 'Maintain';

  @override
  String get exerciseDetailAdaptiveSuggestionBackoff => 'Ease back';

  @override
  String get exerciseDetailAdaptiveSuggestionStop => 'Pause sets';

  @override
  String get exerciseDetailAdaptiveSuggestionAlternative =>
      'Consider another option';

  @override
  String get exerciseDetailAdaptiveSuggestionNone => 'No suggestion';

  @override
  String exerciseDetailAdaptiveSuggestionNextTarget(
    int repetitions,
    String load,
  ) {
    return 'Estimated next set: $repetitions reps x $load.';
  }

  @override
  String exerciseDetailAdaptiveSuggestionMaintainTarget(
    int repetitions,
    String load,
  ) {
    return 'Keep this target for the next set: $repetitions reps x $load.';
  }

  @override
  String exerciseDetailAdaptiveSuggestionBackoffTarget(
    int repetitions,
    String load,
  ) {
    return 'A conservative next set could be $repetitions reps x $load.';
  }

  @override
  String get exerciseDetailAdaptiveSuggestionStopDetail =>
      'Readiness signals are low; finishing this exercise here is a reasonable option.';

  @override
  String get exerciseDetailAdaptiveSuggestionAlternativeDetail =>
      'Readiness signals are low; choosing a nearby exercise can be reasonable.';

  @override
  String get exerciseDetailAdaptiveSuggestionNoSignalDetail =>
      'There is not enough local context for a useful next-set signal yet.';

  @override
  String get exerciseDetailAdaptiveSuggestionReasonLimitedHistory =>
      'Limited local history, so this is a light suggestion.';

  @override
  String get exerciseDetailAdaptiveSuggestionReasonReadiness =>
      'Readiness or soreness signals suggest a conservative next set.';

  @override
  String get exerciseDetailAdaptiveSuggestionReasonProgress =>
      'You beat the prior comparable set.';

  @override
  String get exerciseDetailAdaptiveSuggestionReasonReps =>
      'Load may be capped, so reps are the next progression signal.';

  @override
  String get exerciseDetailAdaptiveSuggestionReasonConservative =>
      'This set trailed the prior comparable one.';

  @override
  String get exerciseDetailAdaptiveSuggestionReasonMatched =>
      'You matched the prior comparable set.';

  @override
  String get exerciseDetailAdaptiveSuggestionReasonLocalHistory =>
      'Based on local set history.';

  @override
  String get exerciseDetailAdaptiveSuggestionAdvisory =>
      'Suggestion only. You can keep logging sets as planned.';

  @override
  String get exerciseDetailAdaptiveSuggestionIgnore => 'Ignore';

  @override
  String exerciseDetailAdaptiveSuggestionSemantics(
    String direction,
    String detail,
  ) {
    return 'Next set signal: $direction. $detail';
  }

  @override
  String get exerciseDetailHistoryTitle => 'Set history';

  @override
  String get exerciseDetailEmptyTitle => 'No set history yet';

  @override
  String get exerciseDetailEmptyMessage =>
      'Log a set to start this exercise history.';

  @override
  String get exerciseDetailMoreHistoryTitle => 'More history available';

  @override
  String exerciseDetailMoreHistoryMessage(int count) {
    return 'Showing the latest $count sets for now.';
  }

  @override
  String exerciseDetailSetLine(int repetitions, String load) {
    return '$repetitions reps x $load';
  }

  @override
  String exerciseDetailAnalyticsSemantics(String name) {
    return 'Open Analytics for $name';
  }

  @override
  String exerciseDetailOneRepMaxSemantics(String name) {
    return 'Open 1RM for $name';
  }

  @override
  String exerciseDetailLogSetSemantics(String name) {
    return 'Log set for $name';
  }

  @override
  String exerciseDetailSetSemantics(int repetitions, String load) {
    return 'Set, $repetitions reps at $load';
  }

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
  String get analyticsMuscleLoadLoading => 'Loading muscle load';

  @override
  String get analyticsMuscleLoadEmptyTitle => 'No muscle load yet';

  @override
  String get analyticsMuscleLoadEmptyMessage =>
      'Log a few sets with catalog exercises to estimate weekly muscle load.';

  @override
  String get analyticsMuscleLoadErrorTitle => 'Muscle load could not load';

  @override
  String get analyticsMuscleLoadErrorMessage =>
      'Try again without changing your local data.';

  @override
  String get analyticsMuscleLoadTitle => 'Muscle Load and Balance';

  @override
  String get analyticsMuscleLoadSubtitle =>
      'Estimated from local sets and catalog activation data.';

  @override
  String get analyticsMuscleLoadWeeklyMetric => '7-day estimated load';

  @override
  String get analyticsMuscleLoadRollingMetric => '28-day estimated load';

  @override
  String get analyticsMuscleLoadCoverageMetric => 'Data coverage';

  @override
  String analyticsMuscleLoadLoggedSets(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sets',
      one: '1 set',
    );
    return '$_temp0';
  }

  @override
  String get analyticsMuscleLoadFocusTitle => 'Focus-aware explanation';

  @override
  String get analyticsMuscleLoadFocusBalanced =>
      'Balanced focus expects broad push, pull, and lower-body coverage. The signal compares your rolling load to that target.';

  @override
  String get analyticsMuscleLoadFocusUpper =>
      'Upper-body focus allows more upper-body load while still keeping some lower-body and pulling work in view.';

  @override
  String get analyticsMuscleLoadFocusLower =>
      'Lower-body focus expects stronger lower-body coverage while keeping upper-back and posture-supporting work visible.';

  @override
  String get analyticsMuscleLoadFocusArmsChest =>
      'Arms and chest focus can bias pressing and isolation work, but pulling and rear-shoulder work still matter.';

  @override
  String get analyticsMuscleLoadFocusStrength =>
      'Strength basics focus looks for the main push, pull, squat, and hinge patterns rather than identical muscle load.';

  @override
  String get analyticsMuscleLoadFocusTimeEfficient =>
      'Time-efficient focus favors useful coverage from fewer movements, so gaps matter more than perfect symmetry.';

  @override
  String get analyticsMuscleLoadFocusBeginner =>
      'Beginner foundation focus rewards consistent broad coverage and treats early estimates gently.';

  @override
  String get analyticsMuscleLoadTopMusclesTitle => 'Top estimated muscle load';

  @override
  String get analyticsMuscleLoadStatusOnTrack => 'On track';

  @override
  String get analyticsMuscleLoadStatusUnderTarget => 'Under target';

  @override
  String get analyticsMuscleLoadStatusOverEmphasized => 'Over-emphasized';

  @override
  String get analyticsMuscleLoadStatusPartialData => 'Partial data';

  @override
  String get analyticsMuscleLoadStatusRecoveryLimited => 'Recovery-limited';

  @override
  String analyticsMuscleLoadSignalSemantics(String status) {
    return 'Muscle balance signal: $status';
  }

  @override
  String get analyticsMuscleLoadSuggestedAction => 'Suggested action';

  @override
  String get analyticsMuscleLoadRecoveryTitle =>
      'Readiness may limit heavy work';

  @override
  String get analyticsMuscleLoadRecoveryExplanation =>
      'Your latest readiness estimate is low, so treat load targets as a softer signal today.';

  @override
  String get analyticsMuscleLoadRecoveryAction =>
      'Consider lighter work, technique practice, or another muscle group.';

  @override
  String get analyticsMuscleLoadBalancedTitle => 'Load looks balanced';

  @override
  String get analyticsMuscleLoadBalancedExplanation =>
      'Your rolling push, pull, and lower-body coverage is on track for the selected focus.';

  @override
  String get analyticsMuscleLoadBalancedAction =>
      'Keep the split balanced this week.';

  @override
  String get analyticsMuscleLoadPushHeavyTitle => 'Pushing load is ahead';

  @override
  String get analyticsMuscleLoadPushHeavyExplanation =>
      'Pressing and push muscles are above pulling work in the rolling estimate.';

  @override
  String get analyticsMuscleLoadPushHeavyAction =>
      'Add a pull movement before adding more pressing work.';

  @override
  String get analyticsMuscleLoadPullNeglectTitle =>
      'Pulling work is under target';

  @override
  String get analyticsMuscleLoadPullNeglectExplanation =>
      'Back and pulling muscles are below the current push/pull target.';

  @override
  String get analyticsMuscleLoadPullNeglectAction =>
      'Add one back exercise such as a row or pulldown this week.';

  @override
  String get analyticsMuscleLoadLowerUnderTitle =>
      'Lower-body work is under target';

  @override
  String get analyticsMuscleLoadLowerUnderExplanation =>
      'Leg and posterior-chain load is below the focus-aware range.';

  @override
  String get analyticsMuscleLoadLowerUnderAction =>
      'Include a squat, lunge, or hinge movement soon.';

  @override
  String get analyticsMuscleLoadUpperUnderTitle =>
      'Upper-body coverage is under target';

  @override
  String get analyticsMuscleLoadUpperUnderExplanation =>
      'Upper-body support work is below the current lower-body-focused target.';

  @override
  String get analyticsMuscleLoadUpperUnderAction =>
      'Add an upper-back or simple push/pull movement.';

  @override
  String get analyticsMuscleLoadMovementGapTitle => 'Movement pattern gap';

  @override
  String get analyticsMuscleLoadMovementGapExplanation =>
      'One expected movement pattern is missing from the rolling estimate.';

  @override
  String get analyticsMuscleLoadMovementGapAction =>
      'Add the missing push, pull, squat, or hinge pattern when practical.';

  @override
  String get analyticsMuscleLoadPartialTitle => 'Unknown activation data';

  @override
  String get analyticsMuscleLoadPartialExplanation =>
      'Some logged exercises do not have activation estimates yet, so the signal is incomplete.';

  @override
  String get analyticsMuscleLoadPartialAction =>
      'Use official catalog exercises for clearer estimates.';

  @override
  String get analyticsMuscleLoadInsufficientTitle => 'More logged sets needed';

  @override
  String get analyticsMuscleLoadInsufficientExplanation =>
      'There are not enough recent sets for a confident balance signal.';

  @override
  String get analyticsMuscleLoadInsufficientAction =>
      'Log a few more sets before changing your plan.';

  @override
  String get analyticsMuscleLoadSignalTitle => 'Muscle balance signal';

  @override
  String get analyticsMuscleLoadSignalExplanation =>
      'This signal is estimated from local training data.';

  @override
  String get analyticsMuscleLoadSignalAction =>
      'Review your next session and keep the choice practical.';

  @override
  String get analyticsMuscleChest => 'Chest';

  @override
  String get analyticsMuscleTriceps => 'Triceps';

  @override
  String get analyticsMuscleFrontDeltoids => 'Front delts';

  @override
  String get analyticsMuscleShoulders => 'Shoulders';

  @override
  String get analyticsMuscleUpperChest => 'Upper chest';

  @override
  String get analyticsMuscleLats => 'Lats';

  @override
  String get analyticsMuscleUpperBack => 'Upper back';

  @override
  String get analyticsMuscleRearDeltoids => 'Rear delts';

  @override
  String get analyticsMuscleBiceps => 'Biceps';

  @override
  String get analyticsMuscleForearms => 'Forearms';

  @override
  String get analyticsMuscleTraps => 'Traps';

  @override
  String get analyticsMuscleQuadriceps => 'Quadriceps';

  @override
  String get analyticsMuscleHamstrings => 'Hamstrings';

  @override
  String get analyticsMuscleGlutes => 'Glutes';

  @override
  String get analyticsMuscleCalves => 'Calves';

  @override
  String get analyticsMuscleErectorSpinae => 'Erector spinae';

  @override
  String get analyticsMuscleCore => 'Core';

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
  String get exerciseAnalyticsChartTitle => 'Exercise chart';

  @override
  String get exerciseAnalyticsMetricSelectorLabel => 'Metric selector';

  @override
  String get exerciseAnalyticsRangeTitle => 'Range';

  @override
  String get exerciseAnalyticsRangeSelectorLabel => 'Range selector';

  @override
  String get exerciseAnalyticsRangeDay => 'D';

  @override
  String get exerciseAnalyticsRangeWeek => 'W';

  @override
  String get exerciseAnalyticsRangeTwoWeeks => '2W';

  @override
  String get exerciseAnalyticsRangeMonth => 'M';

  @override
  String get exerciseAnalyticsRangeThreeMonths => '3M';

  @override
  String get exerciseAnalyticsRangeSixMonths => '6M';

  @override
  String get exerciseAnalyticsRangeAll => 'All';

  @override
  String get exerciseAnalyticsChartLoading => 'Loading exercise chart';

  @override
  String get exerciseAnalyticsChartEmptyTitle => 'No chart data yet';

  @override
  String get exerciseAnalyticsChartEmptyMessage =>
      'Log sets for this exercise to draw a local chart.';

  @override
  String get exerciseAnalyticsOneRepMaxUnavailableTitle =>
      'Estimated 1RM unavailable';

  @override
  String get exerciseAnalyticsOneRepMaxUnavailableMessage =>
      'Log a valid set in this range to estimate 1RM.';

  @override
  String get exerciseAnalyticsChartErrorTitle =>
      'Exercise chart could not load';

  @override
  String get exerciseAnalyticsChartErrorMessage =>
      'Try again without changing local training data.';

  @override
  String get exerciseAnalyticsSelectedPointTitle => 'Selected point';

  @override
  String get exerciseAnalyticsSelectedPointSemantics =>
      'Selected point summary';

  @override
  String exerciseAnalyticsChartSemantics(String metric) {
    return 'Exercise chart for $metric';
  }

  @override
  String get exerciseAnalyticsChartPointsLabel => 'points';

  @override
  String exerciseAnalyticsSetSummary(int repetitions, String load) {
    return '$repetitions reps x $load';
  }

  @override
  String exerciseAnalyticsLimitedHistory(int limit) {
    return 'Chart uses the latest $limit local sets for this exercise.';
  }

  @override
  String get workoutSessionNoActiveTitle => 'No active session';

  @override
  String workoutSessionStartMessage(String source, int count) {
    return 'Start a $source session with $count planned exercises.';
  }

  @override
  String get workoutSessionStart => 'Start workout';

  @override
  String workoutSessionStartSemantics(String source) {
    return 'Start $source workout';
  }

  @override
  String get workoutSessionActiveTitle => 'Active session';

  @override
  String get workoutSessionCompletedTitle => 'Workout complete';

  @override
  String workoutSessionActiveSemantics(
    String source,
    String duration,
    int sets,
    int exercises,
    String volume,
  ) {
    return 'Active session, $source, $duration, $sets sets, $exercises exercises, $volume.';
  }

  @override
  String workoutSessionCompletedSemantics(
    String source,
    String duration,
    int sets,
    int exercises,
    String volume,
  ) {
    return 'Completed workout, $source, $duration, $sets sets, $exercises exercises, $volume.';
  }

  @override
  String workoutSessionSource(String source) {
    return '$source';
  }

  @override
  String get workoutSessionCompleting => 'Completing';

  @override
  String get workoutSessionComplete => 'Complete';

  @override
  String get workoutSessionDuration => 'Duration';

  @override
  String get workoutSessionSets => 'Sets';

  @override
  String get workoutSessionExercises => 'Exercises';

  @override
  String get workoutSessionVolume => 'Volume';

  @override
  String get workoutSessionNoSets => 'No sets logged in this session.';

  @override
  String workoutSessionTopExercise(String exercise) {
    return 'Top exercise: $exercise';
  }

  @override
  String get exercisesCreateCustom => 'Create custom exercise';

  @override
  String get exercisesCustomBadge => 'Custom';

  @override
  String get exercisesOfficialBadge => 'Official';

  @override
  String get exercisesCustomActionsTooltip => 'Custom exercise actions';

  @override
  String get exercisesEditCustom => 'Edit exercise';

  @override
  String get exercisesArchiveCustom => 'Archive exercise';

  @override
  String exercisesCustomSemantics(String name) {
    return 'Custom exercise, $name';
  }

  @override
  String exercisesOfficialSemantics(String name) {
    return 'Official exercise, $name';
  }

  @override
  String get customExerciseCreateTitle => 'Create custom exercise';

  @override
  String get customExerciseEditTitle => 'Edit custom exercise';

  @override
  String get customExerciseNameLabel => 'Name';

  @override
  String get customExerciseNotesLabel => 'Notes';

  @override
  String get customExercisePrimaryMusclesLabel => 'Primary muscles';

  @override
  String get customExerciseSecondaryMusclesLabel => 'Secondary muscles';

  @override
  String get customExerciseEquipmentLabel => 'Equipment';

  @override
  String get customExerciseMovementPatternsLabel => 'Movement patterns';

  @override
  String get customExerciseCommaHelper => 'Comma-separated tags';

  @override
  String get customExerciseCancel => 'Cancel';

  @override
  String get customExerciseSave => 'Save';

  @override
  String get customExerciseNameRequired => 'Add a name.';

  @override
  String get customExercisePrimaryMusclesRequired =>
      'Add at least one primary muscle.';

  @override
  String get customExerciseArchiveTitle => 'Archive custom exercise';

  @override
  String customExerciseArchiveMessage(String name) {
    return 'Archive $name? Historical set snapshots stay readable.';
  }

  @override
  String get customExerciseArchiveConfirm => 'Archive';

  @override
  String get customFolderCreateButton => 'Create folder';

  @override
  String get customFolderCreateMessage =>
      'Build a local folder from official or custom exercises.';

  @override
  String get customFolderCreateTitle => 'Create training folder';

  @override
  String get customFolderEditTitle => 'Edit training folder';

  @override
  String get customFolderNameLabel => 'Folder name';

  @override
  String get customFolderAssignmentsTitle => 'Assigned exercises';

  @override
  String get customFolderCancel => 'Cancel';

  @override
  String get customFolderSave => 'Save';

  @override
  String get customFolderNameRequired => 'Add a folder name.';

  @override
  String get customFolderActionsTooltip => 'Folder actions';

  @override
  String get customFolderEdit => 'Edit folder';

  @override
  String get customFolderArchive => 'Archive folder';

  @override
  String get customFolderArchiveTitle => 'Archive training folder';

  @override
  String customFolderArchiveMessage(String name) {
    return 'Archive $name? Logged workout history stays untouched.';
  }

  @override
  String get customFolderArchiveConfirm => 'Archive';

  @override
  String customFolderSemantics(String name, int count) {
    return 'Training folder, $name, $count exercises';
  }

  @override
  String get customFolderEmptyTitle => 'No assigned exercises';

  @override
  String get customFolderEmptyMessage =>
      'Edit the folder to add official or custom exercises.';

  @override
  String get settingsPlaceholderMessage =>
      'Settings will stay local-first when implemented.';
}
