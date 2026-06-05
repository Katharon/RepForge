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

  /// Bottom navigation label for the training entry point.
  ///
  /// In en, this message translates to:
  /// **'Train'**
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

  /// Loading state for the Train tab.
  ///
  /// In en, this message translates to:
  /// **'Loading training'**
  String get trainLoading;

  /// Title for empty Train tab state.
  ///
  /// In en, this message translates to:
  /// **'No training categories ready'**
  String get trainEmptyTitle;

  /// Message for empty Train tab state.
  ///
  /// In en, this message translates to:
  /// **'Complete catalog import and try again.'**
  String get trainEmptyMessage;

  /// Title for Train tab loading error.
  ///
  /// In en, this message translates to:
  /// **'Training could not load'**
  String get trainErrorTitle;

  /// Message for Train tab loading error.
  ///
  /// In en, this message translates to:
  /// **'Try again without changing local data.'**
  String get trainErrorMessage;

  /// Disabled future action label for starting a new workout.
  ///
  /// In en, this message translates to:
  /// **'New workout'**
  String get trainNewWorkout;

  /// Helper text explaining that the full workout session flow is not implemented yet.
  ///
  /// In en, this message translates to:
  /// **'Full session flow lands later. For now, choose a split below or log a set from Today.'**
  String get trainNewWorkoutUnavailable;

  /// Section title for Train split/category rows.
  ///
  /// In en, this message translates to:
  /// **'Training splits'**
  String get trainSplitsTitle;

  /// Section title for existing starter workout groups on Train.
  ///
  /// In en, this message translates to:
  /// **'Starter groups'**
  String get trainStarterGroupsTitle;

  /// Exercise count for a Train category.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 exercise} other{{count} exercises}}'**
  String trainExerciseCount(int count);

  /// Semantic summary for a Train category row.
  ///
  /// In en, this message translates to:
  /// **'{name}, {count, plural, =0{no exercises} =1{1 exercise} other{{count} exercises}}'**
  String trainCategorySemanticsLabel(String name, int count);

  /// Semantic label for an exercise row inside a Train category.
  ///
  /// In en, this message translates to:
  /// **'Exercise {name}'**
  String trainExerciseSemanticsLabel(String name);

  /// Back button from category exercise list to Train splits.
  ///
  /// In en, this message translates to:
  /// **'Back to splits'**
  String get trainBackToSplits;

  /// Search field label inside a Train category.
  ///
  /// In en, this message translates to:
  /// **'Search this split'**
  String get trainSearchLabel;

  /// Tooltip for Train category search button.
  ///
  /// In en, this message translates to:
  /// **'Search split'**
  String get trainSearchTooltip;

  /// Title when a Train category has no matching exercises.
  ///
  /// In en, this message translates to:
  /// **'No exercises in this split'**
  String get trainCategoryEmptyTitle;

  /// Message when a Train category has no matching exercises.
  ///
  /// In en, this message translates to:
  /// **'Try a different search or use My Exercises.'**
  String get trainCategoryEmptyMessage;

  /// Train category title for all available exercises.
  ///
  /// In en, this message translates to:
  /// **'My Exercises'**
  String get trainCategoryMyExercises;

  /// Train category title for full-body exercises.
  ///
  /// In en, this message translates to:
  /// **'Full Body'**
  String get trainCategoryFullBody;

  /// Train category title for upper-body exercises.
  ///
  /// In en, this message translates to:
  /// **'Upper Body'**
  String get trainCategoryUpperBody;

  /// Train category title for lower-body exercises.
  ///
  /// In en, this message translates to:
  /// **'Lower Body'**
  String get trainCategoryLowerBody;

  /// Train category title for push exercises.
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get trainCategoryPush;

  /// Train category title for pull exercises.
  ///
  /// In en, this message translates to:
  /// **'Pull'**
  String get trainCategoryPull;

  /// Train category title for leg exercises.
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get trainCategoryLegs;

  /// Train category title for core exercises.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get trainCategoryCore;

  /// Description for My Exercises category.
  ///
  /// In en, this message translates to:
  /// **'All available local catalog exercises.'**
  String get trainCategoryMyExercisesDescription;

  /// Description for Full Body category.
  ///
  /// In en, this message translates to:
  /// **'Broad compound patterns for whole-session coverage.'**
  String get trainCategoryFullBodyDescription;

  /// Description for Upper Body category.
  ///
  /// In en, this message translates to:
  /// **'Pressing, pulling, shoulders, chest, back, and arms.'**
  String get trainCategoryUpperBodyDescription;

  /// Description for Lower Body category.
  ///
  /// In en, this message translates to:
  /// **'Squat, hinge, glute, quad, and hamstring work.'**
  String get trainCategoryLowerBodyDescription;

  /// Description for Push category.
  ///
  /// In en, this message translates to:
  /// **'Chest, shoulder, triceps, and push-pattern work.'**
  String get trainCategoryPushDescription;

  /// Description for Pull category.
  ///
  /// In en, this message translates to:
  /// **'Back, lats, biceps, rear delts, and pull patterns.'**
  String get trainCategoryPullDescription;

  /// Description for Legs category.
  ///
  /// In en, this message translates to:
  /// **'Lower-body squat, lunge, and hinge exercises.'**
  String get trainCategoryLegsDescription;

  /// Description for Core category.
  ///
  /// In en, this message translates to:
  /// **'Core-focused work when catalog metadata supports it.'**
  String get trainCategoryCoreDescription;

  /// Loading state for Exercise Detail.
  ///
  /// In en, this message translates to:
  /// **'Loading exercise detail'**
  String get exerciseDetailLoading;

  /// Title for Exercise Detail loading failure.
  ///
  /// In en, this message translates to:
  /// **'Exercise detail could not load'**
  String get exerciseDetailErrorTitle;

  /// Message for Exercise Detail loading failure.
  ///
  /// In en, this message translates to:
  /// **'Try again without changing local data.'**
  String get exerciseDetailErrorMessage;

  /// Exercise Detail analytics entry card title.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get exerciseDetailAnalyticsTitle;

  /// Exercise Detail analytics entry placeholder message.
  ///
  /// In en, this message translates to:
  /// **'Full charts land in the next slice.'**
  String get exerciseDetailAnalyticsMessage;

  /// Exercise Detail estimated one-rep max entry card title.
  ///
  /// In en, this message translates to:
  /// **'1RM'**
  String get exerciseDetailOneRepMaxTitle;

  /// Exercise Detail estimated one-rep max entry placeholder message.
  ///
  /// In en, this message translates to:
  /// **'Quick estimate now, full view later.'**
  String get exerciseDetailOneRepMaxMessage;

  /// Exercise Detail previous-comparable-session summary title.
  ///
  /// In en, this message translates to:
  /// **'Compared to previous'**
  String get exerciseDetailComparedTitle;

  /// Exercise Detail summary text when previous comparable data exists.
  ///
  /// In en, this message translates to:
  /// **'Current session compared with the previous comparable session.'**
  String get exerciseDetailComparedAvailable;

  /// Exercise Detail summary text when no previous comparable data exists.
  ///
  /// In en, this message translates to:
  /// **'Previous session unavailable'**
  String get exerciseDetailComparedUnavailable;

  /// Neutral unavailable metric text.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get exerciseDetailUnavailable;

  /// Exercise Detail set history section title.
  ///
  /// In en, this message translates to:
  /// **'Set history'**
  String get exerciseDetailHistoryTitle;

  /// Exercise Detail empty history title.
  ///
  /// In en, this message translates to:
  /// **'No set history yet'**
  String get exerciseDetailEmptyTitle;

  /// Exercise Detail empty history message.
  ///
  /// In en, this message translates to:
  /// **'Log a set to start this exercise history.'**
  String get exerciseDetailEmptyMessage;

  /// Exercise Detail bounded history note title.
  ///
  /// In en, this message translates to:
  /// **'More history available'**
  String get exerciseDetailMoreHistoryTitle;

  /// Exercise Detail bounded history note message.
  ///
  /// In en, this message translates to:
  /// **'Showing the latest {count} sets for now.'**
  String exerciseDetailMoreHistoryMessage(int count);

  /// Exercise Detail set row main line.
  ///
  /// In en, this message translates to:
  /// **'{repetitions} reps x {load}'**
  String exerciseDetailSetLine(int repetitions, String load);

  /// Semantic label for Exercise Detail analytics entry.
  ///
  /// In en, this message translates to:
  /// **'Open Analytics for {name}'**
  String exerciseDetailAnalyticsSemantics(String name);

  /// Semantic label for Exercise Detail 1RM entry.
  ///
  /// In en, this message translates to:
  /// **'Open 1RM for {name}'**
  String exerciseDetailOneRepMaxSemantics(String name);

  /// Semantic label for Exercise Detail log-set action.
  ///
  /// In en, this message translates to:
  /// **'Log set for {name}'**
  String exerciseDetailLogSetSemantics(String name);

  /// Semantic label for Exercise Detail history set rows.
  ///
  /// In en, this message translates to:
  /// **'Set, {repetitions} reps at {load}'**
  String exerciseDetailSetSemantics(int repetitions, String load);

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

  /// Loading state text for the muscle load dashboard.
  ///
  /// In en, this message translates to:
  /// **'Loading muscle load'**
  String get analyticsMuscleLoadLoading;

  /// Title for the empty muscle load dashboard state.
  ///
  /// In en, this message translates to:
  /// **'No muscle load yet'**
  String get analyticsMuscleLoadEmptyTitle;

  /// Message for the empty muscle load dashboard state.
  ///
  /// In en, this message translates to:
  /// **'Log a few sets with catalog exercises to estimate weekly muscle load.'**
  String get analyticsMuscleLoadEmptyMessage;

  /// Title for muscle load dashboard loading errors.
  ///
  /// In en, this message translates to:
  /// **'Muscle load could not load'**
  String get analyticsMuscleLoadErrorTitle;

  /// Message for muscle load dashboard loading errors.
  ///
  /// In en, this message translates to:
  /// **'Try again without changing your local data.'**
  String get analyticsMuscleLoadErrorMessage;

  /// Title for the muscle load dashboard section.
  ///
  /// In en, this message translates to:
  /// **'Muscle Load and Balance'**
  String get analyticsMuscleLoadTitle;

  /// Subtitle for the muscle load dashboard section.
  ///
  /// In en, this message translates to:
  /// **'Estimated from local sets and catalog activation data.'**
  String get analyticsMuscleLoadSubtitle;

  /// Metric label for weekly estimated muscle load.
  ///
  /// In en, this message translates to:
  /// **'7-day estimated load'**
  String get analyticsMuscleLoadWeeklyMetric;

  /// Metric label for rolling estimated muscle load.
  ///
  /// In en, this message translates to:
  /// **'28-day estimated load'**
  String get analyticsMuscleLoadRollingMetric;

  /// Metric label for muscle load data coverage.
  ///
  /// In en, this message translates to:
  /// **'Data coverage'**
  String get analyticsMuscleLoadCoverageMetric;

  /// Logged set count for muscle load data coverage.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 set} other{{count} sets}}'**
  String analyticsMuscleLoadLoggedSets(int count);

  /// Title for the focus-aware muscle load explanation card.
  ///
  /// In en, this message translates to:
  /// **'Focus-aware explanation'**
  String get analyticsMuscleLoadFocusTitle;

  /// Focus-aware explanation for balanced focus.
  ///
  /// In en, this message translates to:
  /// **'Balanced focus expects broad push, pull, and lower-body coverage. The signal compares your rolling load to that target.'**
  String get analyticsMuscleLoadFocusBalanced;

  /// Focus-aware explanation for upper-body focus.
  ///
  /// In en, this message translates to:
  /// **'Upper-body focus allows more upper-body load while still keeping some lower-body and pulling work in view.'**
  String get analyticsMuscleLoadFocusUpper;

  /// Focus-aware explanation for lower-body focus.
  ///
  /// In en, this message translates to:
  /// **'Lower-body focus expects stronger lower-body coverage while keeping upper-back and posture-supporting work visible.'**
  String get analyticsMuscleLoadFocusLower;

  /// Focus-aware explanation for arms and chest focus.
  ///
  /// In en, this message translates to:
  /// **'Arms and chest focus can bias pressing and isolation work, but pulling and rear-shoulder work still matter.'**
  String get analyticsMuscleLoadFocusArmsChest;

  /// Focus-aware explanation for strength basics focus.
  ///
  /// In en, this message translates to:
  /// **'Strength basics focus looks for the main push, pull, squat, and hinge patterns rather than identical muscle load.'**
  String get analyticsMuscleLoadFocusStrength;

  /// Focus-aware explanation for time-efficient focus.
  ///
  /// In en, this message translates to:
  /// **'Time-efficient focus favors useful coverage from fewer movements, so gaps matter more than perfect symmetry.'**
  String get analyticsMuscleLoadFocusTimeEfficient;

  /// Focus-aware explanation for beginner foundation focus.
  ///
  /// In en, this message translates to:
  /// **'Beginner foundation focus rewards consistent broad coverage and treats early estimates gently.'**
  String get analyticsMuscleLoadFocusBeginner;

  /// Title for top muscle load rows.
  ///
  /// In en, this message translates to:
  /// **'Top estimated muscle load'**
  String get analyticsMuscleLoadTopMusclesTitle;

  /// Status label for balanced muscle load.
  ///
  /// In en, this message translates to:
  /// **'On track'**
  String get analyticsMuscleLoadStatusOnTrack;

  /// Status label for under-target muscle load.
  ///
  /// In en, this message translates to:
  /// **'Under target'**
  String get analyticsMuscleLoadStatusUnderTarget;

  /// Status label for over-emphasized muscle load.
  ///
  /// In en, this message translates to:
  /// **'Over-emphasized'**
  String get analyticsMuscleLoadStatusOverEmphasized;

  /// Status label for partial muscle load data.
  ///
  /// In en, this message translates to:
  /// **'Partial data'**
  String get analyticsMuscleLoadStatusPartialData;

  /// Status label when readiness should soften muscle load guidance.
  ///
  /// In en, this message translates to:
  /// **'Recovery-limited'**
  String get analyticsMuscleLoadStatusRecoveryLimited;

  /// Accessibility label prefix for a muscle balance signal.
  ///
  /// In en, this message translates to:
  /// **'Muscle balance signal: {status}'**
  String analyticsMuscleLoadSignalSemantics(String status);

  /// Label before constructive muscle load actions.
  ///
  /// In en, this message translates to:
  /// **'Suggested action'**
  String get analyticsMuscleLoadSuggestedAction;

  /// No description provided for @analyticsMuscleLoadRecoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Readiness may limit heavy work'**
  String get analyticsMuscleLoadRecoveryTitle;

  /// No description provided for @analyticsMuscleLoadRecoveryExplanation.
  ///
  /// In en, this message translates to:
  /// **'Your latest readiness estimate is low, so treat load targets as a softer signal today.'**
  String get analyticsMuscleLoadRecoveryExplanation;

  /// No description provided for @analyticsMuscleLoadRecoveryAction.
  ///
  /// In en, this message translates to:
  /// **'Consider lighter work, technique practice, or another muscle group.'**
  String get analyticsMuscleLoadRecoveryAction;

  /// No description provided for @analyticsMuscleLoadBalancedTitle.
  ///
  /// In en, this message translates to:
  /// **'Load looks balanced'**
  String get analyticsMuscleLoadBalancedTitle;

  /// No description provided for @analyticsMuscleLoadBalancedExplanation.
  ///
  /// In en, this message translates to:
  /// **'Your rolling push, pull, and lower-body coverage is on track for the selected focus.'**
  String get analyticsMuscleLoadBalancedExplanation;

  /// No description provided for @analyticsMuscleLoadBalancedAction.
  ///
  /// In en, this message translates to:
  /// **'Keep the split balanced this week.'**
  String get analyticsMuscleLoadBalancedAction;

  /// No description provided for @analyticsMuscleLoadPushHeavyTitle.
  ///
  /// In en, this message translates to:
  /// **'Pushing load is ahead'**
  String get analyticsMuscleLoadPushHeavyTitle;

  /// No description provided for @analyticsMuscleLoadPushHeavyExplanation.
  ///
  /// In en, this message translates to:
  /// **'Pressing and push muscles are above pulling work in the rolling estimate.'**
  String get analyticsMuscleLoadPushHeavyExplanation;

  /// No description provided for @analyticsMuscleLoadPushHeavyAction.
  ///
  /// In en, this message translates to:
  /// **'Add a pull movement before adding more pressing work.'**
  String get analyticsMuscleLoadPushHeavyAction;

  /// No description provided for @analyticsMuscleLoadPullNeglectTitle.
  ///
  /// In en, this message translates to:
  /// **'Pulling work is under target'**
  String get analyticsMuscleLoadPullNeglectTitle;

  /// No description provided for @analyticsMuscleLoadPullNeglectExplanation.
  ///
  /// In en, this message translates to:
  /// **'Back and pulling muscles are below the current push/pull target.'**
  String get analyticsMuscleLoadPullNeglectExplanation;

  /// No description provided for @analyticsMuscleLoadPullNeglectAction.
  ///
  /// In en, this message translates to:
  /// **'Add one back exercise such as a row or pulldown this week.'**
  String get analyticsMuscleLoadPullNeglectAction;

  /// No description provided for @analyticsMuscleLoadLowerUnderTitle.
  ///
  /// In en, this message translates to:
  /// **'Lower-body work is under target'**
  String get analyticsMuscleLoadLowerUnderTitle;

  /// No description provided for @analyticsMuscleLoadLowerUnderExplanation.
  ///
  /// In en, this message translates to:
  /// **'Leg and posterior-chain load is below the focus-aware range.'**
  String get analyticsMuscleLoadLowerUnderExplanation;

  /// No description provided for @analyticsMuscleLoadLowerUnderAction.
  ///
  /// In en, this message translates to:
  /// **'Include a squat, lunge, or hinge movement soon.'**
  String get analyticsMuscleLoadLowerUnderAction;

  /// No description provided for @analyticsMuscleLoadUpperUnderTitle.
  ///
  /// In en, this message translates to:
  /// **'Upper-body coverage is under target'**
  String get analyticsMuscleLoadUpperUnderTitle;

  /// No description provided for @analyticsMuscleLoadUpperUnderExplanation.
  ///
  /// In en, this message translates to:
  /// **'Upper-body support work is below the current lower-body-focused target.'**
  String get analyticsMuscleLoadUpperUnderExplanation;

  /// No description provided for @analyticsMuscleLoadUpperUnderAction.
  ///
  /// In en, this message translates to:
  /// **'Add an upper-back or simple push/pull movement.'**
  String get analyticsMuscleLoadUpperUnderAction;

  /// No description provided for @analyticsMuscleLoadMovementGapTitle.
  ///
  /// In en, this message translates to:
  /// **'Movement pattern gap'**
  String get analyticsMuscleLoadMovementGapTitle;

  /// No description provided for @analyticsMuscleLoadMovementGapExplanation.
  ///
  /// In en, this message translates to:
  /// **'One expected movement pattern is missing from the rolling estimate.'**
  String get analyticsMuscleLoadMovementGapExplanation;

  /// No description provided for @analyticsMuscleLoadMovementGapAction.
  ///
  /// In en, this message translates to:
  /// **'Add the missing push, pull, squat, or hinge pattern when practical.'**
  String get analyticsMuscleLoadMovementGapAction;

  /// No description provided for @analyticsMuscleLoadPartialTitle.
  ///
  /// In en, this message translates to:
  /// **'Unknown activation data'**
  String get analyticsMuscleLoadPartialTitle;

  /// No description provided for @analyticsMuscleLoadPartialExplanation.
  ///
  /// In en, this message translates to:
  /// **'Some logged exercises do not have activation estimates yet, so the signal is incomplete.'**
  String get analyticsMuscleLoadPartialExplanation;

  /// No description provided for @analyticsMuscleLoadPartialAction.
  ///
  /// In en, this message translates to:
  /// **'Use official catalog exercises for clearer estimates.'**
  String get analyticsMuscleLoadPartialAction;

  /// No description provided for @analyticsMuscleLoadInsufficientTitle.
  ///
  /// In en, this message translates to:
  /// **'More logged sets needed'**
  String get analyticsMuscleLoadInsufficientTitle;

  /// No description provided for @analyticsMuscleLoadInsufficientExplanation.
  ///
  /// In en, this message translates to:
  /// **'There are not enough recent sets for a confident balance signal.'**
  String get analyticsMuscleLoadInsufficientExplanation;

  /// No description provided for @analyticsMuscleLoadInsufficientAction.
  ///
  /// In en, this message translates to:
  /// **'Log a few more sets before changing your plan.'**
  String get analyticsMuscleLoadInsufficientAction;

  /// No description provided for @analyticsMuscleLoadSignalTitle.
  ///
  /// In en, this message translates to:
  /// **'Muscle balance signal'**
  String get analyticsMuscleLoadSignalTitle;

  /// No description provided for @analyticsMuscleLoadSignalExplanation.
  ///
  /// In en, this message translates to:
  /// **'This signal is estimated from local training data.'**
  String get analyticsMuscleLoadSignalExplanation;

  /// No description provided for @analyticsMuscleLoadSignalAction.
  ///
  /// In en, this message translates to:
  /// **'Review your next session and keep the choice practical.'**
  String get analyticsMuscleLoadSignalAction;

  /// No description provided for @analyticsMuscleChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get analyticsMuscleChest;

  /// No description provided for @analyticsMuscleTriceps.
  ///
  /// In en, this message translates to:
  /// **'Triceps'**
  String get analyticsMuscleTriceps;

  /// No description provided for @analyticsMuscleFrontDeltoids.
  ///
  /// In en, this message translates to:
  /// **'Front delts'**
  String get analyticsMuscleFrontDeltoids;

  /// No description provided for @analyticsMuscleShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get analyticsMuscleShoulders;

  /// No description provided for @analyticsMuscleUpperChest.
  ///
  /// In en, this message translates to:
  /// **'Upper chest'**
  String get analyticsMuscleUpperChest;

  /// No description provided for @analyticsMuscleLats.
  ///
  /// In en, this message translates to:
  /// **'Lats'**
  String get analyticsMuscleLats;

  /// No description provided for @analyticsMuscleUpperBack.
  ///
  /// In en, this message translates to:
  /// **'Upper back'**
  String get analyticsMuscleUpperBack;

  /// No description provided for @analyticsMuscleRearDeltoids.
  ///
  /// In en, this message translates to:
  /// **'Rear delts'**
  String get analyticsMuscleRearDeltoids;

  /// No description provided for @analyticsMuscleBiceps.
  ///
  /// In en, this message translates to:
  /// **'Biceps'**
  String get analyticsMuscleBiceps;

  /// No description provided for @analyticsMuscleForearms.
  ///
  /// In en, this message translates to:
  /// **'Forearms'**
  String get analyticsMuscleForearms;

  /// No description provided for @analyticsMuscleTraps.
  ///
  /// In en, this message translates to:
  /// **'Traps'**
  String get analyticsMuscleTraps;

  /// No description provided for @analyticsMuscleQuadriceps.
  ///
  /// In en, this message translates to:
  /// **'Quadriceps'**
  String get analyticsMuscleQuadriceps;

  /// No description provided for @analyticsMuscleHamstrings.
  ///
  /// In en, this message translates to:
  /// **'Hamstrings'**
  String get analyticsMuscleHamstrings;

  /// No description provided for @analyticsMuscleGlutes.
  ///
  /// In en, this message translates to:
  /// **'Glutes'**
  String get analyticsMuscleGlutes;

  /// No description provided for @analyticsMuscleCalves.
  ///
  /// In en, this message translates to:
  /// **'Calves'**
  String get analyticsMuscleCalves;

  /// No description provided for @analyticsMuscleErectorSpinae.
  ///
  /// In en, this message translates to:
  /// **'Erector spinae'**
  String get analyticsMuscleErectorSpinae;

  /// No description provided for @analyticsMuscleCore.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get analyticsMuscleCore;

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
