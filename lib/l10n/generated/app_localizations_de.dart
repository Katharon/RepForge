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
  String get todayDashboardTitle => 'Heute';

  @override
  String get todayLoading => 'Heute wird geladen';

  @override
  String get todayEmptyTitle => 'Heute noch keine Saetze';

  @override
  String get todayEmptyMessage =>
      'Deine Tagesuebersicht fuellt sich, sobald Saetze protokolliert sind.';

  @override
  String get todayErrorTitle => 'Heute konnte nicht geladen werden';

  @override
  String get todayErrorMessage =>
      'Versuche es erneut, ohne lokale Daten zu aendern.';

  @override
  String get todayRetry => 'Erneut versuchen';

  @override
  String get todaySetCount => 'Saetze heute';

  @override
  String get todayVolume => 'Volumen heute';

  @override
  String get todayReadinessTitle => 'Readiness-Schaetzung';

  @override
  String get todayReadinessUnavailable => 'Heute kein Check-in';

  @override
  String get todayReadinessNoScore => '--';

  @override
  String todayReadinessScore(int score) {
    return '$score / 100';
  }

  @override
  String get todayReadinessHigh => 'Hoch';

  @override
  String get todayReadinessMedium => 'Mittel';

  @override
  String get todayReadinessLow => 'Niedrig';

  @override
  String get todayReadinessVeryLow => 'Sehr niedrig';

  @override
  String get todayReadinessEstimateNote =>
      'Schaetzung anhand deines letzten lokalen Check-ins.';

  @override
  String get todayLastLoggedTitle => 'Zuletzt protokolliert';

  @override
  String get todayNoLastLoggedSet => 'Noch kein Satz';

  @override
  String todayLastLoggedSetSummary(
    String exercise,
    int repetitions,
    String load,
  ) {
    return '$exercise: $repetitions Wdh. mit $load';
  }

  @override
  String get todayRestTimerTitle => 'Pausentimer';

  @override
  String get todayRestTimerIdle => 'Kein aktiver Pausentimer';

  @override
  String get todayRestTimerRunning => 'Pause laeuft';

  @override
  String get todayRestTimerFinished => 'Pause beendet';

  @override
  String get todayQuickActionTitle => 'Schnellaktion';

  @override
  String get todayQuickActionLogSet => 'Satz protokollieren';

  @override
  String get todayQuickActionMessage =>
      'Waehle eine Uebung, trage Gewicht und Wiederholungen ein und speichere den Satz lokal.';

  @override
  String get todayAnalyticsHintTitle => 'Trainingssignal';

  @override
  String get todayAnalyticsHintMessage =>
      'Lokale Trends bleiben in Analyse, waehrend die heutige Arbeit hier sichtbar ist.';

  @override
  String get groupsLoading => 'Gruppen werden geladen';

  @override
  String get groupsEmptyTitle => 'Noch keine Gruppen';

  @override
  String get groupsEmptyMessage =>
      'Schliesse das Onboarding ab, um Startgruppen zu erstellen. Bearbeiten folgt in einem spaeteren Flow.';

  @override
  String get groupsErrorTitle => 'Gruppen konnten nicht geladen werden';

  @override
  String get groupsErrorMessage =>
      'Versuche es erneut, ohne lokale Daten zu aendern.';

  @override
  String groupsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Gruppen',
      one: '1 Gruppe',
    );
    return '$_temp0';
  }

  @override
  String groupsExerciseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Uebungen zugewiesen',
      one: '1 Uebung zugewiesen',
      zero: 'Keine Uebungen zugewiesen',
    );
    return '$_temp0';
  }

  @override
  String groupsSemanticsLabel(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Uebungen',
      one: '1 Uebung',
      zero: 'keine Uebungen',
    );
    return '$name, $_temp0';
  }

  @override
  String get groupsCoachPreviewTitle => 'Coach-Vorschau';

  @override
  String get groupsCoachPreviewMessage =>
      'Empfehlungen koennen lokale Gruppen, Readiness, Equipment und Balance-Signale nutzen, sobald genug Eingaben vorhanden sind.';

  @override
  String get exercisesLoading => 'Uebungen werden geladen';

  @override
  String get exercisesSearchLabel => 'Uebungen suchen';

  @override
  String get exercisesSearchTooltip => 'Suchen';

  @override
  String get exercisesEmptyTitle => 'Keine Uebungen gefunden';

  @override
  String get exercisesEmptyMessage =>
      'Probiere eine andere Suche oder importiere den gebuendelten Katalog erneut.';

  @override
  String get exercisesErrorTitle => 'Uebungen konnten nicht geladen werden';

  @override
  String get exercisesErrorMessage =>
      'Versuche es erneut, ohne lokale Daten zu aendern.';

  @override
  String exercisesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Uebungen',
      one: '1 Uebung',
    );
    return '$_temp0';
  }

  @override
  String get exercisesMoreTitle => 'Weitere Uebungen verfuegbar';

  @override
  String get exercisesMoreMessage =>
      'Nutze die Suche, um den lokalen Katalog einzugrenzen.';

  @override
  String get quickLogTitle => 'Satz protokollieren';

  @override
  String get quickLogExerciseSearchLabel => 'Uebung';

  @override
  String get quickLogNoExercises => 'Keine Uebungen verfuegbar.';

  @override
  String get quickLogLoadLabel => 'Gewicht (kg)';

  @override
  String get quickLogRepetitionsLabel => 'Wdh.';

  @override
  String get quickLogLabelLabel => 'Label';

  @override
  String get quickLogCommentLabel => 'Kommentar';

  @override
  String get quickLogCancel => 'Abbrechen';

  @override
  String get quickLogSave => 'Satz speichern';

  @override
  String get quickLogSaveError =>
      'Pruefe die Satzdetails und versuche es erneut.';

  @override
  String get quickLogLabelNone => 'Keins';

  @override
  String get quickLogLabelWarmup => 'Aufwaermen';

  @override
  String get quickLogLabelFailure => 'Failure';

  @override
  String get quickLogLabelPersonalRecord => 'Persoenlicher Rekord';

  @override
  String get quickLogLabelDropSet => 'Drop-Set';

  @override
  String get quickLogLabelPain => 'Schmerznotiz';

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
  String get settingsLoading => 'Einstellungen werden geladen';

  @override
  String get settingsErrorTitle => 'Einstellungen konnten nicht geladen werden';

  @override
  String get settingsErrorMessage =>
      'Versuche es erneut, ohne lokale Daten zu aendern.';

  @override
  String get settingsRetry => 'Erneut versuchen';

  @override
  String get settingsUsingDefaults => 'Lokale Standardwerte aktiv';

  @override
  String get settingsSaved => 'Lokal gespeichert';

  @override
  String get settingsSave => 'Einstellungen speichern';

  @override
  String get settingsSaving => 'Speichert';

  @override
  String get settingsReset => 'Auf Standardwerte zuruecksetzen';

  @override
  String get settingsAppPreferencesTitle => 'App-Einstellungen';

  @override
  String get settingsProfileTitle => 'Profilbasis';

  @override
  String get settingsTrainingTitle => 'Trainingseinstellungen';

  @override
  String get settingsEquipmentTitle => 'Verfuegbare Ausruestung';

  @override
  String get settingsLanguageLabel => 'Sprache';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsLanguageEnglish => 'Englisch';

  @override
  String get settingsLanguageGerman => 'Deutsch';

  @override
  String get settingsUnitsLabel => 'Einheiten';

  @override
  String get settingsUnitsMetric => 'Metrisch';

  @override
  String get settingsUnitsImperial => 'Imperial';

  @override
  String get settingsThemeLabel => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsDisplayNameLabel => 'Profilname';

  @override
  String get settingsDefaultRestLabel => 'Standardpause';

  @override
  String settingsSeconds(int seconds) {
    return '$seconds Sek.';
  }

  @override
  String get settingsFocusLabel => 'Fokusprofil';

  @override
  String get settingsFocusBalanced => 'Ausgewogen';

  @override
  String get settingsFocusUpperBody => 'Oberkoerperfokus';

  @override
  String get settingsFocusLowerBody => 'Unterkoerper-/Glutefokus';

  @override
  String get settingsFocusArmsChest => 'Arm-/Brustfokus';

  @override
  String get settingsFocusStrengthBasics => 'Kraft-Basics';

  @override
  String get settingsFocusTimeEfficient => 'Zeiteffizient';

  @override
  String get settingsFocusBeginnerFoundation => 'Einsteigerbasis';

  @override
  String get settingsFocusCustom => 'Eigener Fokus';

  @override
  String get settingsTrainingFrequencyLabel => 'Trainingshaeufigkeit';

  @override
  String settingsDaysPerWeek(int days) {
    return '$days Tage/Woche';
  }

  @override
  String get settingsSessionDurationLabel => 'Sitzungsdauer';

  @override
  String settingsMinutes(int minutes) {
    return '$minutes Min.';
  }

  @override
  String get settingsEquipmentBodyweight => 'Koerpergewicht';

  @override
  String get settingsEquipmentBarbell => 'Langhantel';

  @override
  String get settingsEquipmentDumbbell => 'Kurzhantel';

  @override
  String get settingsEquipmentCable => 'Kabelzug';

  @override
  String get settingsEquipmentMachine => 'Maschine';

  @override
  String get settingsEquipmentSmithMachine => 'Smith Machine';

  @override
  String get settingsEquipmentPullUpBar => 'Klimmzugstange';

  @override
  String get settingsEquipmentBench => 'Bank';

  @override
  String get settingsEquipmentRack => 'Rack';

  @override
  String get settingsEquipmentLegPress => 'Beinpresse';

  @override
  String get onboardingTitle => 'Einrichtung';

  @override
  String get onboardingLoading => 'Einrichtung wird vorbereitet';

  @override
  String get onboardingWelcomeTitle => 'RepForge einrichten';

  @override
  String get onboardingWelcomeMessage =>
      'Waehle jetzt ein paar lokale Einstellungen oder ueberspringe und starte direkt.';

  @override
  String get onboardingStart => 'Einrichtung starten';

  @override
  String get onboardingSkip => 'Ueberspringen';

  @override
  String get onboardingProfileTitle => 'Profil und Fokus';

  @override
  String get onboardingTrainingTitle => 'Trainingsrhythmus';

  @override
  String get onboardingEquipmentTitle => 'Ausruestung';

  @override
  String get onboardingStarterGroupsTitle => 'Startergruppen erstellen';

  @override
  String get onboardingBack => 'Zurueck';

  @override
  String get onboardingNext => 'Weiter';

  @override
  String get onboardingComplete => 'Einrichtung speichern';

  @override
  String get onboardingSavedTitle => 'Einrichtung gespeichert';

  @override
  String get onboardingSavedMessage =>
      'Deine Auswahl bleibt lokal gespeichert und kann in den Einstellungen geaendert werden.';

  @override
  String get onboardingContinue => 'Weiter';

  @override
  String get onboardingErrorTitle =>
      'Einrichtung konnte nicht gespeichert werden';

  @override
  String get onboardingErrorMessage =>
      'Versuche es erneut, ohne lokale Daten zu aendern.';

  @override
  String get settingsPlaceholderMessage =>
      'Einstellungen bleiben bei der Umsetzung lokal-first.';
}
