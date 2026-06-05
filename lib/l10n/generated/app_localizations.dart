import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// Application title.
  ///
  /// In en, this message translates to:
  /// **'RepForge'**
  String get appTitle;

  /// Title shown on the initial placeholder screen.
  ///
  /// In en, this message translates to:
  /// **'RepForge'**
  String get homePlaceholderTitle;

  /// Short placeholder message shown before feature slices are implemented.
  ///
  /// In en, this message translates to:
  /// **'Local-first workout tracking is being forged.'**
  String get homePlaceholderMessage;

  /// Bottom navigation label for the Today destination.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// Bottom navigation label for workout groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get navGroups;

  /// Bottom navigation label for exercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get navExercises;

  /// Bottom navigation label for analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get navAnalytics;

  /// Bottom navigation label for settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Placeholder message for the Today destination.
  ///
  /// In en, this message translates to:
  /// **'Today is ready for the next tracking slice.'**
  String get todayPlaceholderMessage;

  /// Title for the Today dashboard.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayDashboardTitle;

  /// Loading state text for the Today dashboard.
  ///
  /// In en, this message translates to:
  /// **'Loading today'**
  String get todayLoading;

  /// Title for an empty Today dashboard.
  ///
  /// In en, this message translates to:
  /// **'No sets logged today'**
  String get todayEmptyTitle;

  /// Message for an empty Today dashboard.
  ///
  /// In en, this message translates to:
  /// **'Your daily summary will fill in as soon as sets are logged.'**
  String get todayEmptyMessage;

  /// Title for a Today dashboard error state.
  ///
  /// In en, this message translates to:
  /// **'Today could not load'**
  String get todayErrorTitle;

  /// Message for a Today dashboard error state.
  ///
  /// In en, this message translates to:
  /// **'Try again without changing local data.'**
  String get todayErrorMessage;

  /// Retry button label for the Today dashboard.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get todayRetry;

  /// Metric label for sets logged today.
  ///
  /// In en, this message translates to:
  /// **'Sets today'**
  String get todaySetCount;

  /// Metric label for volume logged today.
  ///
  /// In en, this message translates to:
  /// **'Volume today'**
  String get todayVolume;

  /// Title for the Today readiness estimate card.
  ///
  /// In en, this message translates to:
  /// **'Readiness estimate'**
  String get todayReadinessTitle;

  /// Readiness card text when no readiness check-in exists today.
  ///
  /// In en, this message translates to:
  /// **'No check-in today'**
  String get todayReadinessUnavailable;

  /// Readiness card score placeholder when no score is available.
  ///
  /// In en, this message translates to:
  /// **'--'**
  String get todayReadinessNoScore;

  /// Readiness estimate score shown on Today.
  ///
  /// In en, this message translates to:
  /// **'{score} / 100'**
  String todayReadinessScore(int score);

  /// High readiness estimate level.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get todayReadinessHigh;

  /// Medium readiness estimate level.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get todayReadinessMedium;

  /// Low readiness estimate level.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get todayReadinessLow;

  /// Very low readiness estimate level.
  ///
  /// In en, this message translates to:
  /// **'Very low'**
  String get todayReadinessVeryLow;

  /// Short non-medical readiness estimate explanation.
  ///
  /// In en, this message translates to:
  /// **'Estimate based on your latest local check-in.'**
  String get todayReadinessEstimateNote;

  /// Title for the last logged set card.
  ///
  /// In en, this message translates to:
  /// **'Last logged'**
  String get todayLastLoggedTitle;

  /// Text when there is no last logged set today.
  ///
  /// In en, this message translates to:
  /// **'No set yet'**
  String get todayNoLastLoggedSet;

  /// Summary for the last logged set.
  ///
  /// In en, this message translates to:
  /// **'{exercise}: {repetitions} reps at {load}'**
  String todayLastLoggedSetSummary(
    String exercise,
    int repetitions,
    String load,
  );

  /// Title for the rest timer card on Today.
  ///
  /// In en, this message translates to:
  /// **'Rest timer'**
  String get todayRestTimerTitle;

  /// Rest timer idle state on Today.
  ///
  /// In en, this message translates to:
  /// **'No active rest timer'**
  String get todayRestTimerIdle;

  /// Rest timer running state on Today.
  ///
  /// In en, this message translates to:
  /// **'Resting'**
  String get todayRestTimerRunning;

  /// Rest timer finished state on Today.
  ///
  /// In en, this message translates to:
  /// **'Rest complete'**
  String get todayRestTimerFinished;

  /// Title for Today quick action placeholder card.
  ///
  /// In en, this message translates to:
  /// **'Quick action'**
  String get todayQuickActionTitle;

  /// Future quick action label for logging a set.
  ///
  /// In en, this message translates to:
  /// **'Log set'**
  String get todayQuickActionLogSet;

  /// Helper text for the Today quick logging entry point.
  ///
  /// In en, this message translates to:
  /// **'Choose an exercise, enter load and reps, and save the set locally.'**
  String get todayQuickActionMessage;

  /// Title for a small Today analytics hint card.
  ///
  /// In en, this message translates to:
  /// **'Training signal'**
  String get todayAnalyticsHintTitle;

  /// Message for a small Today analytics hint card.
  ///
  /// In en, this message translates to:
  /// **'Local trends stay in Analytics while today\'s work stays here.'**
  String get todayAnalyticsHintMessage;

  /// Loading state for workout groups.
  ///
  /// In en, this message translates to:
  /// **'Loading groups'**
  String get groupsLoading;

  /// Title for empty workout groups list.
  ///
  /// In en, this message translates to:
  /// **'No groups yet'**
  String get groupsEmptyTitle;

  /// Message for empty workout groups list.
  ///
  /// In en, this message translates to:
  /// **'Complete onboarding to create starter groups, or add groups in a later editing flow.'**
  String get groupsEmptyMessage;

  /// Title for groups loading error.
  ///
  /// In en, this message translates to:
  /// **'Groups could not load'**
  String get groupsErrorTitle;

  /// Message for groups loading error.
  ///
  /// In en, this message translates to:
  /// **'Try again without changing local data.'**
  String get groupsErrorMessage;

  /// Workout group count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 group} other{{count} groups}}'**
  String groupsCount(int count);

  /// Exercise assignment count for a group.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No exercises assigned} =1{1 exercise assigned} other{{count} exercises assigned}}'**
  String groupsExerciseCount(int count);

  /// Semantic summary for a workout group card.
  ///
  /// In en, this message translates to:
  /// **'{name}, {count, plural, =0{no exercises} =1{1 exercise} other{{count} exercises}}'**
  String groupsSemanticsLabel(String name, int count);

  /// Title for a small local coach preview on groups.
  ///
  /// In en, this message translates to:
  /// **'Coach preview'**
  String get groupsCoachPreviewTitle;

  /// Careful coach preview message for workout groups.
  ///
  /// In en, this message translates to:
  /// **'Recommendations can use local groups, readiness, equipment, and balance signals when enough inputs are available.'**
  String get groupsCoachPreviewMessage;

  /// Loading state for exercises.
  ///
  /// In en, this message translates to:
  /// **'Loading exercises'**
  String get exercisesLoading;

  /// Search field label for exercises.
  ///
  /// In en, this message translates to:
  /// **'Search exercises'**
  String get exercisesSearchLabel;

  /// Tooltip for exercise search button.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get exercisesSearchTooltip;

  /// Title for empty exercise catalog state.
  ///
  /// In en, this message translates to:
  /// **'No exercises found'**
  String get exercisesEmptyTitle;

  /// Message for empty exercise catalog state.
  ///
  /// In en, this message translates to:
  /// **'Try a different search or import the bundled catalog again.'**
  String get exercisesEmptyMessage;

  /// Title for exercise loading error.
  ///
  /// In en, this message translates to:
  /// **'Exercises could not load'**
  String get exercisesErrorTitle;

  /// Message for exercise loading error.
  ///
  /// In en, this message translates to:
  /// **'Try again without changing local data.'**
  String get exercisesErrorMessage;

  /// Official exercise count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 exercise} other{{count} exercises}}'**
  String exercisesCount(int count);

  /// Title shown when the list is capped.
  ///
  /// In en, this message translates to:
  /// **'More exercises available'**
  String get exercisesMoreTitle;

  /// Message shown when the list is capped.
  ///
  /// In en, this message translates to:
  /// **'Use search to narrow the local catalog.'**
  String get exercisesMoreMessage;

  /// Dialog title for quick logging a set.
  ///
  /// In en, this message translates to:
  /// **'Log set'**
  String get quickLogTitle;

  /// Exercise search field label in quick log dialog.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get quickLogExerciseSearchLabel;

  /// Empty exercise state in quick log dialog.
  ///
  /// In en, this message translates to:
  /// **'No exercises available.'**
  String get quickLogNoExercises;

  /// Load field label in quick log dialog.
  ///
  /// In en, this message translates to:
  /// **'Load (kg)'**
  String get quickLogLoadLabel;

  /// Repetitions field label in quick log dialog.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get quickLogRepetitionsLabel;

  /// Set label dropdown label in quick log dialog.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get quickLogLabelLabel;

  /// Comment field label in quick log dialog.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get quickLogCommentLabel;

  /// Cancel button in quick log dialog.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get quickLogCancel;

  /// Save button in quick log dialog.
  ///
  /// In en, this message translates to:
  /// **'Save set'**
  String get quickLogSave;

  /// Validation/save error message in quick log dialog.
  ///
  /// In en, this message translates to:
  /// **'Check the set details and try again.'**
  String get quickLogSaveError;

  /// No set label option.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get quickLogLabelNone;

  /// Warm-up set label option.
  ///
  /// In en, this message translates to:
  /// **'Warm-up'**
  String get quickLogLabelWarmup;

  /// Failure set label option.
  ///
  /// In en, this message translates to:
  /// **'Failure'**
  String get quickLogLabelFailure;

  /// Personal record set label option.
  ///
  /// In en, this message translates to:
  /// **'Personal record'**
  String get quickLogLabelPersonalRecord;

  /// Drop set label option.
  ///
  /// In en, this message translates to:
  /// **'Drop set'**
  String get quickLogLabelDropSet;

  /// Pain note set label option.
  ///
  /// In en, this message translates to:
  /// **'Pain note'**
  String get quickLogLabelPain;

  /// Placeholder message for the analytics destination.
  ///
  /// In en, this message translates to:
  /// **'Analytics will show local training trends later.'**
  String get analyticsPlaceholderMessage;

  /// Analytics metric label for set count.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get analyticsMetricSets;

  /// Analytics metric label for repetition count.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get analyticsMetricRepetitions;

  /// Analytics metric label for training volume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get analyticsMetricVolume;

  /// Analytics metric label for average kilograms per repetition.
  ///
  /// In en, this message translates to:
  /// **'kg/rep'**
  String get analyticsMetricKgPerRep;

  /// Analytics metric label for estimated one repetition maximum.
  ///
  /// In en, this message translates to:
  /// **'Est. 1RM'**
  String get analyticsMetricEstimatedOneRepMax;

  /// Title for the estimated one-rep max analytics card.
  ///
  /// In en, this message translates to:
  /// **'Estimated 1RM'**
  String get analyticsEstimatedOneRepMaxTitle;

  /// Label for the current estimated one-rep max value.
  ///
  /// In en, this message translates to:
  /// **'Best estimate'**
  String get analyticsEstimatedOneRepMaxCurrentLabel;

  /// Label for the previous estimated one-rep max value.
  ///
  /// In en, this message translates to:
  /// **'Previous window'**
  String get analyticsEstimatedOneRepMaxPreviousLabel;

  /// Title when estimated one-rep max is unavailable.
  ///
  /// In en, this message translates to:
  /// **'No estimated 1RM yet'**
  String get analyticsEstimatedOneRepMaxUnavailableTitle;

  /// Message when estimated one-rep max is unavailable.
  ///
  /// In en, this message translates to:
  /// **'Log a set in this range to calculate the Epley estimate.'**
  String get analyticsEstimatedOneRepMaxUnavailableMessage;

  /// Label for an analytics formula identity.
  ///
  /// In en, this message translates to:
  /// **'Formula'**
  String get analyticsFormulaLabel;

  /// Display label for the Epley estimated one-rep max formula.
  ///
  /// In en, this message translates to:
  /// **'Epley v{version}'**
  String analyticsFormulaEpley(int version);

  /// Unit label for kilograms in analytics values.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get analyticsUnitKilograms;

  /// Unit label for kilograms per repetition in analytics values.
  ///
  /// In en, this message translates to:
  /// **'kg/rep'**
  String get analyticsUnitKilogramsPerRep;

  /// Analytics range selector label for seven days.
  ///
  /// In en, this message translates to:
  /// **'7D'**
  String get analyticsRangeSevenDays;

  /// Analytics range selector label for thirty days.
  ///
  /// In en, this message translates to:
  /// **'30D'**
  String get analyticsRangeThirtyDays;

  /// Analytics range selector label for ninety days.
  ///
  /// In en, this message translates to:
  /// **'90D'**
  String get analyticsRangeNinetyDays;

  /// Loading state text for analytics.
  ///
  /// In en, this message translates to:
  /// **'Loading analytics'**
  String get analyticsLoading;

  /// Title for empty analytics state.
  ///
  /// In en, this message translates to:
  /// **'No sets in this range'**
  String get analyticsEmptyTitle;

  /// Message for empty analytics state.
  ///
  /// In en, this message translates to:
  /// **'Log sets for this exercise to see local trends.'**
  String get analyticsEmptyMessage;

  /// Title for analytics error state.
  ///
  /// In en, this message translates to:
  /// **'Analytics could not load'**
  String get analyticsErrorTitle;

  /// Message for analytics error state.
  ///
  /// In en, this message translates to:
  /// **'Try again without changing your local data.'**
  String get analyticsErrorMessage;

  /// Retry button label for analytics loading errors.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get analyticsRetry;

  /// Heading for analytics summary cards.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get analyticsSummaryTitle;

  /// Title for the selected analytics chart.
  ///
  /// In en, this message translates to:
  /// **'{metric} trend'**
  String analyticsChartTitle(String metric);

  /// Label for the current analytics chart value.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get analyticsCurrentPeriod;

  /// Label for the previous analytics chart value.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get analyticsPreviousPeriod;

  /// Loading state text for settings.
  ///
  /// In en, this message translates to:
  /// **'Loading settings'**
  String get settingsLoading;

  /// Title for settings loading errors.
  ///
  /// In en, this message translates to:
  /// **'Settings could not load'**
  String get settingsErrorTitle;

  /// Message for settings loading errors.
  ///
  /// In en, this message translates to:
  /// **'Try again without changing local data.'**
  String get settingsErrorMessage;

  /// Retry button label for settings.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get settingsRetry;

  /// Status text when settings have never been customized.
  ///
  /// In en, this message translates to:
  /// **'Using local defaults'**
  String get settingsUsingDefaults;

  /// Status text after saving settings.
  ///
  /// In en, this message translates to:
  /// **'Saved locally'**
  String get settingsSaved;

  /// Save button label for settings.
  ///
  /// In en, this message translates to:
  /// **'Save settings'**
  String get settingsSave;

  /// Saving button label for settings.
  ///
  /// In en, this message translates to:
  /// **'Saving'**
  String get settingsSaving;

  /// Tooltip for resetting settings to defaults.
  ///
  /// In en, this message translates to:
  /// **'Reset to defaults'**
  String get settingsReset;

  /// Section title for app settings.
  ///
  /// In en, this message translates to:
  /// **'App preferences'**
  String get settingsAppPreferencesTitle;

  /// Section title for basic user profile fields.
  ///
  /// In en, this message translates to:
  /// **'Profile basics'**
  String get settingsProfileTitle;

  /// Section title for training preference settings.
  ///
  /// In en, this message translates to:
  /// **'Training preferences'**
  String get settingsTrainingTitle;

  /// Section title for equipment inventory settings.
  ///
  /// In en, this message translates to:
  /// **'Available equipment'**
  String get settingsEquipmentTitle;

  /// Label for language override selector.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageLabel;

  /// System language option.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsLanguageSystem;

  /// English language option.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// German language option.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get settingsLanguageGerman;

  /// Label for units selector.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get settingsUnitsLabel;

  /// Metric units option.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get settingsUnitsMetric;

  /// Imperial units option.
  ///
  /// In en, this message translates to:
  /// **'Imperial'**
  String get settingsUnitsImperial;

  /// Label for theme selector.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeLabel;

  /// System theme option.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// Dark theme option.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// Light theme option.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// Label for optional profile display name.
  ///
  /// In en, this message translates to:
  /// **'Profile name'**
  String get settingsDisplayNameLabel;

  /// Label for default rest time selector.
  ///
  /// In en, this message translates to:
  /// **'Default rest'**
  String get settingsDefaultRestLabel;

  /// Short seconds label.
  ///
  /// In en, this message translates to:
  /// **'{seconds} sec'**
  String settingsSeconds(int seconds);

  /// Label for focus profile selector.
  ///
  /// In en, this message translates to:
  /// **'Focus profile'**
  String get settingsFocusLabel;

  /// Balanced focus profile option.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get settingsFocusBalanced;

  /// Upper-body focus profile option.
  ///
  /// In en, this message translates to:
  /// **'Upper-body focus'**
  String get settingsFocusUpperBody;

  /// Lower-body focus profile option.
  ///
  /// In en, this message translates to:
  /// **'Lower-body/glute focus'**
  String get settingsFocusLowerBody;

  /// Arms and chest focus profile option.
  ///
  /// In en, this message translates to:
  /// **'Arms/chest focus'**
  String get settingsFocusArmsChest;

  /// Strength basics focus profile option.
  ///
  /// In en, this message translates to:
  /// **'Strength basics'**
  String get settingsFocusStrengthBasics;

  /// Time-efficient focus profile option.
  ///
  /// In en, this message translates to:
  /// **'Time-efficient'**
  String get settingsFocusTimeEfficient;

  /// Beginner foundation focus profile option.
  ///
  /// In en, this message translates to:
  /// **'Beginner foundation'**
  String get settingsFocusBeginnerFoundation;

  /// Custom focus profile option.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get settingsFocusCustom;

  /// Label for training days per week selector.
  ///
  /// In en, this message translates to:
  /// **'Training frequency'**
  String get settingsTrainingFrequencyLabel;

  /// Days per week label.
  ///
  /// In en, this message translates to:
  /// **'{days} days/week'**
  String settingsDaysPerWeek(int days);

  /// Label for session duration selector.
  ///
  /// In en, this message translates to:
  /// **'Session duration'**
  String get settingsSessionDurationLabel;

  /// Minutes label.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String settingsMinutes(int minutes);

  /// Bodyweight equipment option.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight'**
  String get settingsEquipmentBodyweight;

  /// Barbell equipment option.
  ///
  /// In en, this message translates to:
  /// **'Barbell'**
  String get settingsEquipmentBarbell;

  /// Dumbbell equipment option.
  ///
  /// In en, this message translates to:
  /// **'Dumbbell'**
  String get settingsEquipmentDumbbell;

  /// Cable equipment option.
  ///
  /// In en, this message translates to:
  /// **'Cable'**
  String get settingsEquipmentCable;

  /// Machine equipment option.
  ///
  /// In en, this message translates to:
  /// **'Machine'**
  String get settingsEquipmentMachine;

  /// Smith machine equipment option.
  ///
  /// In en, this message translates to:
  /// **'Smith machine'**
  String get settingsEquipmentSmithMachine;

  /// Pull-up bar equipment option.
  ///
  /// In en, this message translates to:
  /// **'Pull-up bar'**
  String get settingsEquipmentPullUpBar;

  /// Bench equipment option.
  ///
  /// In en, this message translates to:
  /// **'Bench'**
  String get settingsEquipmentBench;

  /// Rack equipment option.
  ///
  /// In en, this message translates to:
  /// **'Rack'**
  String get settingsEquipmentRack;

  /// Leg press equipment option.
  ///
  /// In en, this message translates to:
  /// **'Leg press'**
  String get settingsEquipmentLegPress;

  /// Title for the onboarding flow.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get onboardingTitle;

  /// Loading text for onboarding status.
  ///
  /// In en, this message translates to:
  /// **'Preparing setup'**
  String get onboardingLoading;

  /// Welcome title for onboarding.
  ///
  /// In en, this message translates to:
  /// **'Set up RepForge'**
  String get onboardingWelcomeTitle;

  /// Welcome message for onboarding.
  ///
  /// In en, this message translates to:
  /// **'Choose a few local preferences now or skip and start tracking.'**
  String get onboardingWelcomeMessage;

  /// Button to start onboarding.
  ///
  /// In en, this message translates to:
  /// **'Start setup'**
  String get onboardingStart;

  /// Button to skip onboarding.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// Onboarding profile step title.
  ///
  /// In en, this message translates to:
  /// **'Profile and focus'**
  String get onboardingProfileTitle;

  /// Onboarding training step title.
  ///
  /// In en, this message translates to:
  /// **'Training rhythm'**
  String get onboardingTrainingTitle;

  /// Onboarding equipment step title.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get onboardingEquipmentTitle;

  /// Checkbox title for creating starter workout groups.
  ///
  /// In en, this message translates to:
  /// **'Create starter groups'**
  String get onboardingStarterGroupsTitle;

  /// Back button in onboarding.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboardingBack;

  /// Next button in onboarding.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// Complete onboarding button.
  ///
  /// In en, this message translates to:
  /// **'Save setup'**
  String get onboardingComplete;

  /// Saved state title for onboarding.
  ///
  /// In en, this message translates to:
  /// **'Setup saved'**
  String get onboardingSavedTitle;

  /// Saved state message for onboarding.
  ///
  /// In en, this message translates to:
  /// **'Your choices are stored locally and can be changed in Settings.'**
  String get onboardingSavedMessage;

  /// Continue button after onboarding is saved.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// Onboarding error title.
  ///
  /// In en, this message translates to:
  /// **'Setup could not save'**
  String get onboardingErrorTitle;

  /// Onboarding error message.
  ///
  /// In en, this message translates to:
  /// **'Try again without changing local data.'**
  String get onboardingErrorMessage;

  /// Placeholder message for the settings destination.
  ///
  /// In en, this message translates to:
  /// **'Settings will stay local-first when implemented.'**
  String get settingsPlaceholderMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
