import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/app/localization/app_localizations.dart';
import 'package:repforge/src/core/theme/theme.dart';
import 'package:repforge/src/features/analytics/application/analytics_application.dart';
import 'package:repforge/src/features/analytics/domain/analytics_domain.dart';
import 'package:repforge/src/features/analytics/presentation/analytics_presentation.dart';
import 'package:repforge/src/features/recovery/domain/recovery_domain.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

void main() {
  testWidgets('loading state renders', (tester) async {
    await tester.pumpWidget(
      _testApp(AnalyticsPage(loader: _PendingAnalyticsLoader())),
    );

    expect(find.text('Loading analytics'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('empty state renders', (tester) async {
    await tester.pumpWidget(
      _testApp(AnalyticsPage(loader: _StaticAnalyticsLoader(_readModel()))),
    );
    await tester.pumpAndSettle();

    expect(find.text('No sets in this range'), findsOneWidget);
    expect(
      find.text('Log sets for this exercise to see local trends.'),
      findsOneWidget,
    );
  });

  testWidgets('error state renders', (tester) async {
    await tester.pumpWidget(
      _testApp(AnalyticsPage(loader: _FailingAnalyticsLoader())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Analytics could not load'), findsOneWidget);
    expect(
      find.text('Try again without changing your local data.'),
      findsOneWidget,
    );
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('success state renders metric cards', (tester) async {
    await tester.pumpWidget(
      _testApp(
        AnalyticsPage(loader: _StaticAnalyticsLoader(_readModelWithData())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Summary'), findsOneWidget);
    expect(find.text('Sets'), findsWidgets);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('Reps'), findsWidgets);
    expect(find.text('15'), findsOneWidget);
    expect(find.text('Volume'), findsWidgets);
    expect(find.text('1300 kg'), findsWidgets);
    expect(find.text('86.7 kg/rep'), findsOneWidget);
    expect(find.text('116.7 kg'), findsWidgets);
  });

  testWidgets('metric cards and chart expose readable semantic labels', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        AnalyticsPage(loader: _StaticAnalyticsLoader(_readModelWithData())),
      ),
    );
    await tester.pumpAndSettle();

    expect(_semanticsLabel('Volume, 1300 kg'), findsOneWidget);
    expect(
      _semanticsLabel('Volume trend, Current 1300 kg, Previous 600 kg'),
      findsOneWidget,
    );
  });

  testWidgets('success state remains readable at increased text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        AnalyticsPage(loader: _StaticAnalyticsLoader(_readModelWithData())),
        textScaler: const TextScaler.linear(2),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Summary'), findsOneWidget);
    expect(find.text('Volume trend'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('estimated 1RM value card renders available state and formula', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        AnalyticsPage(loader: _StaticAnalyticsLoader(_readModelWithData())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Estimated 1RM'), findsOneWidget);
    expect(find.text('Best estimate'), findsOneWidget);
    expect(find.text('Formula: Epley v1'), findsOneWidget);
    expect(find.text('Previous window'), findsOneWidget);
    expect(find.text('116.7 kg'), findsWidgets);
    expect(find.text('80 kg'), findsOneWidget);
  });

  testWidgets('estimated 1RM value card renders unavailable state', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        AnalyticsPage(
          loader: _StaticAnalyticsLoader(
            _readModel(
              current: _overview(
                setCount: 1,
                totalRepetitions: 5,
                totalVolumeKg: 500,
                averageKgPerRep: 100,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No estimated 1RM yet'), findsOneWidget);
    expect(
      find.text('Log a set in this range to calculate the Epley estimate.'),
      findsOneWidget,
    );
    expect(find.text('Formula: Epley v1'), findsOneWidget);
  });

  testWidgets('estimated 1RM value card renders zero-load estimates', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        AnalyticsPage(
          loader: _StaticAnalyticsLoader(
            _readModel(
              current: _overview(
                setCount: 1,
                totalRepetitions: 10,
                averageKgPerRep: 0,
                bestEstimatedOneRepMaxKg: 0,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Best estimate'), findsOneWidget);
    expect(find.text('0 kg'), findsWidgets);
  });

  testWidgets('metric selector changes selected metric', (tester) async {
    await tester.pumpWidget(
      _testApp(
        AnalyticsPage(loader: _StaticAnalyticsLoader(_readModelWithData())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Volume trend'), findsOneWidget);

    await tester.tap(
      find.byKey(const Key('analytics_metric_estimatedOneRepMaxKg')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Est. 1RM trend'), findsOneWidget);
    expect(find.text('116.7 kg'), findsWidgets);
    expect(find.text('80 kg'), findsWidgets);
  });

  testWidgets('range selector triggers reload', (tester) async {
    final loader = _RecordingAnalyticsLoader(_readModelWithData());

    await tester.pumpWidget(_testApp(AnalyticsPage(loader: loader)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('90D'));
    await tester.pumpAndSettle();

    expect(loader.ranges, [
      ExerciseAnalyticsRange.thirtyDays,
      ExerciseAnalyticsRange.ninetyDays,
    ]);
  });

  testWidgets('chart visualization renders deterministic values', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        AnalyticsPage(loader: _StaticAnalyticsLoader(_readModelWithData())),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('analytics_chart_current_bar')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('analytics_chart_previous_bar')),
      findsOneWidget,
    );
    expect(find.text('Current'), findsOneWidget);
    expect(find.text('Previous'), findsOneWidget);
    expect(find.text('1300 kg'), findsWidgets);
    expect(find.text('600 kg'), findsOneWidget);
  });

  testWidgets('muscle load dashboard renders loading state', (tester) async {
    await tester.pumpWidget(
      _testApp(
        AnalyticsPage(
          loader: _StaticAnalyticsLoader(_readModelWithData()),
          muscleLoadDashboardLoader: _PendingMuscleLoadDashboardLoader(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Loading muscle load'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('muscle load dashboard renders empty state', (tester) async {
    await tester.pumpWidget(
      _testApp(
        AnalyticsPage(
          loader: _StaticAnalyticsLoader(_readModelWithData()),
          muscleLoadDashboardLoader: _StaticMuscleLoadDashboardLoader(
            _muscleDashboardModel(loggedSetCount: 0),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No muscle load yet'), findsOneWidget);
    expect(
      find.text(
        'Log a few sets with catalog exercises to estimate weekly muscle load.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('muscle load dashboard renders balanced on-track state', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        AnalyticsPage(
          loader: _StaticAnalyticsLoader(_readModelWithData()),
          muscleLoadDashboardLoader: _StaticMuscleLoadDashboardLoader(
            _muscleDashboardModel(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Muscle Load and Balance'), findsOneWidget);
    expect(find.text('On track'), findsOneWidget);
    expect(find.text('Load looks balanced'), findsOneWidget);
    expect(
      find.textContaining('Keep the split balanced this week.'),
      findsOneWidget,
    );
    expect(
      _semanticsLabelContaining('Muscle balance signal: On track'),
      findsOneWidget,
    );
  });

  testWidgets('muscle load dashboard renders under-target signal and action', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        AnalyticsPage(
          loader: _StaticAnalyticsLoader(_readModelWithData()),
          muscleLoadDashboardLoader: _StaticMuscleLoadDashboardLoader(
            _muscleDashboardModel(
              signals: [_signal(MuscleBalanceSignalType.pullNeglect)],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Under target'), findsOneWidget);
    expect(find.text('Pulling work is under target'), findsOneWidget);
    expect(
      find.textContaining('Add one back exercise such as a row or pulldown'),
      findsOneWidget,
    );
  });

  testWidgets('muscle load dashboard renders over-emphasized signal', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        AnalyticsPage(
          loader: _StaticAnalyticsLoader(_readModelWithData()),
          muscleLoadDashboardLoader: _StaticMuscleLoadDashboardLoader(
            _muscleDashboardModel(
              signals: [_signal(MuscleBalanceSignalType.pushHeavy)],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Over-emphasized'), findsOneWidget);
    expect(find.text('Pushing load is ahead'), findsOneWidget);
    expect(
      find.textContaining('Add a pull movement before adding more pressing'),
      findsOneWidget,
    );
  });

  testWidgets('muscle load dashboard renders partial activation data state', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        AnalyticsPage(
          loader: _StaticAnalyticsLoader(_readModelWithData()),
          muscleLoadDashboardLoader: _StaticMuscleLoadDashboardLoader(
            _muscleDashboardModel(
              rollingEstimate: MuscleLoadEstimate(
                muscleLoads: [
                  MuscleLoad(muscleId: MuscleId('chest'), estimatedLoadKg: 400),
                ],
                unknownExercises: [
                  ExerciseRef.custom(
                    id: CustomExerciseId('custom-press'),
                    displayNameSnapshot: 'Custom Press',
                  ),
                ],
                confidence: MuscleLoadConfidence.unavailable,
              ),
              signals: [_signal(MuscleBalanceSignalType.incompleteData)],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Partial data'), findsOneWidget);
    expect(find.text('Unknown activation data'), findsOneWidget);
    expect(
      find.textContaining(
        'Use official catalog exercises for clearer estimates.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('muscle load dashboard renders recovery-limited state', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        AnalyticsPage(
          loader: _StaticAnalyticsLoader(_readModelWithData()),
          muscleLoadDashboardLoader: _StaticMuscleLoadDashboardLoader(
            _muscleDashboardModel(readiness: _lowReadiness()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Recovery-limited'), findsOneWidget);
    expect(find.text('Readiness may limit heavy work'), findsOneWidget);
    expect(
      find.textContaining('Consider lighter work, technique practice'),
      findsOneWidget,
    );
  });

  testWidgets('muscle load dashboard localizes German strings', (tester) async {
    await tester.pumpWidget(
      _testApp(
        AnalyticsPage(
          loader: _StaticAnalyticsLoader(_readModelWithData()),
          muscleLoadDashboardLoader: _StaticMuscleLoadDashboardLoader(
            _muscleDashboardModel(),
          ),
        ),
        locale: const Locale('de'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Muskelbelastung und Balance'), findsOneWidget);
    expect(find.text('Im Ziel'), findsOneWidget);
  });

  testWidgets('muscle load dashboard avoids medical and shaming wording', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        AnalyticsPage(
          loader: _StaticAnalyticsLoader(_readModelWithData()),
          muscleLoadDashboardLoader: _StaticMuscleLoadDashboardLoader(
            _muscleDashboardModel(
              readiness: _lowReadiness(),
              signals: [
                _signal(MuscleBalanceSignalType.pullNeglect),
                _signal(MuscleBalanceSignalType.pushHeavy),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.textContaining(
        RegExp(
          'diagnos|medical|injury|shame|exact fatigue',
          caseSensitive: false,
        ),
      ),
      findsNothing,
    );
  });
}

Widget _testApp(
  Widget child, {
  TextScaler textScaler = TextScaler.noScaling,
  Locale? locale,
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: RepForgeTheme.dark(),
    home: MediaQuery(
      data: MediaQueryData(textScaler: textScaler),
      child: Scaffold(body: child),
    ),
  );
}

Finder _semanticsLabel(String label) {
  return find.byWidgetPredicate((widget) {
    return widget is Semantics && widget.properties.label == label;
  });
}

Finder _semanticsLabelContaining(String label) {
  return find.byWidgetPredicate((widget) {
    return widget is Semantics &&
        (widget.properties.label?.contains(label) ?? false);
  });
}

final class _PendingAnalyticsLoader implements ExerciseAnalyticsLoader {
  @override
  Future<ExerciseAnalyticsReadModel> load(
    ExerciseAnalyticsLoadRequest request,
  ) {
    return Completer<ExerciseAnalyticsReadModel>().future;
  }
}

final class _StaticAnalyticsLoader implements ExerciseAnalyticsLoader {
  const _StaticAnalyticsLoader(this.model);

  final ExerciseAnalyticsReadModel model;

  @override
  Future<ExerciseAnalyticsReadModel> load(
    ExerciseAnalyticsLoadRequest request,
  ) {
    return Future.value(model);
  }
}

final class _FailingAnalyticsLoader implements ExerciseAnalyticsLoader {
  @override
  Future<ExerciseAnalyticsReadModel> load(
    ExerciseAnalyticsLoadRequest request,
  ) {
    return Future<ExerciseAnalyticsReadModel>.error(StateError('boom'));
  }
}

final class _RecordingAnalyticsLoader implements ExerciseAnalyticsLoader {
  _RecordingAnalyticsLoader(this.model);

  final ExerciseAnalyticsReadModel model;
  final List<ExerciseAnalyticsRange> ranges = [];

  @override
  Future<ExerciseAnalyticsReadModel> load(
    ExerciseAnalyticsLoadRequest request,
  ) {
    ranges.add(request.range);

    return Future.value(model);
  }
}

final class _PendingMuscleLoadDashboardLoader
    implements MuscleLoadDashboardLoader {
  @override
  Future<MuscleLoadDashboardReadModel> load(
    MuscleLoadDashboardLoadRequest request,
  ) {
    return Completer<MuscleLoadDashboardReadModel>().future;
  }
}

final class _StaticMuscleLoadDashboardLoader
    implements MuscleLoadDashboardLoader {
  const _StaticMuscleLoadDashboardLoader(this.model);

  final MuscleLoadDashboardReadModel model;

  @override
  Future<MuscleLoadDashboardReadModel> load(
    MuscleLoadDashboardLoadRequest request,
  ) {
    return Future.value(model);
  }
}

ExerciseAnalyticsReadModel _readModelWithData() {
  return _readModel(
    current: _overview(
      setCount: 2,
      totalRepetitions: 15,
      totalVolumeKg: 1300,
      averageKgPerRep: 86.6666667,
      bestEstimatedOneRepMaxKg: 116.6666667,
    ),
    previous: _overview(
      setCount: 1,
      totalRepetitions: 10,
      totalVolumeKg: 600,
      averageKgPerRep: 60,
      bestEstimatedOneRepMaxKg: 80,
    ),
  );
}

MuscleLoadDashboardReadModel _muscleDashboardModel({
  int loggedSetCount = 8,
  MuscleLoadEstimate? weeklyEstimate,
  MuscleLoadEstimate? rollingEstimate,
  List<MuscleBalanceSignal>? signals,
  ReadinessReadModel? readiness,
}) {
  final resolvedRollingEstimate = rollingEstimate ?? _muscleEstimate();
  final resolvedSignals =
      signals ?? [_signal(MuscleBalanceSignalType.balanced)];

  return MuscleLoadDashboardReadModel(
    weeklyEstimate: weeklyEstimate ?? _muscleEstimate(chest: 350, lats: 320),
    rollingEstimate: resolvedRollingEstimate,
    balanceAssessment: MuscleBalanceAssessment(
      status:
          resolvedSignals.any(
            (signal) => signal.type != MuscleBalanceSignalType.balanced,
          )
          ? MuscleBalanceAssessmentStatus.imbalanced
          : MuscleBalanceAssessmentStatus.balanced,
      confidence: MuscleBalanceConfidence.high,
      targetRange: MuscleBalanceTargetRange.forFocus(FocusProfile.balanced),
      signals: resolvedSignals,
      totalKnownLoadKg: resolvedRollingEstimate.totalKnownLoadKg,
    ),
    focusProfile: FocusProfile.balanced,
    readiness:
        readiness ??
        ReadinessReadModel.empty(forDate: DateTime.utc(2026, 6, 5)),
    weeklyLoggedSetCount: loggedSetCount == 0 ? 0 : 3,
    rollingLoggedSetCount: loggedSetCount,
    scannedSetCount: loggedSetCount,
    historyLimit: 100,
    reachedHistoryLimit: false,
  );
}

MuscleLoadEstimate _muscleEstimate({
  double chest = 900,
  double lats = 850,
  double quadriceps = 700,
}) {
  return MuscleLoadEstimate(
    muscleLoads: [
      MuscleLoad(muscleId: MuscleId('chest'), estimatedLoadKg: chest),
      MuscleLoad(muscleId: MuscleId('lats'), estimatedLoadKg: lats),
      MuscleLoad(muscleId: MuscleId('quadriceps'), estimatedLoadKg: quadriceps),
    ],
    unknownExercises: const <ExerciseRef>[],
    confidence: MuscleLoadConfidence.estimated,
  );
}

MuscleBalanceSignal _signal(MuscleBalanceSignalType type) {
  return MuscleBalanceSignal(
    type: type,
    severity: type == MuscleBalanceSignalType.balanced
        ? MuscleBalanceSeverity.info
        : MuscleBalanceSeverity.attention,
    evidence: MuscleBalanceEvidence(
      code: switch (type) {
        MuscleBalanceSignalType.balanced => 'muscle_balance.balanced',
        MuscleBalanceSignalType.pushHeavy => 'muscle_balance.push_heavy',
        MuscleBalanceSignalType.pullNeglect => 'muscle_balance.pull_neglect',
        MuscleBalanceSignalType.legNeglect => 'muscle_balance.leg_neglect',
        MuscleBalanceSignalType.lowerBodyUnderTarget =>
          'muscle_balance.lower_body_under_target',
        MuscleBalanceSignalType.upperBodyUnderTarget =>
          'muscle_balance.upper_body_under_target',
        MuscleBalanceSignalType.movementPatternGap =>
          'muscle_balance.movement_pattern_gap',
        MuscleBalanceSignalType.incompleteData =>
          'muscle_balance.incomplete_activation_data',
        MuscleBalanceSignalType.insufficientData =>
          'muscle_balance.insufficient_data',
      },
    ),
  );
}

ReadinessReadModel _lowReadiness() {
  return ReadinessReadModel(
    status: ReadinessReadModelStatus.available,
    forDate: DateTime.utc(2026, 6, 5),
    confidence: ReadinessConfidence.reported,
    latestCheckIn: null,
    score: ReadinessScore(35),
    level: ReadinessLevel.low,
    reasons: const [ReadinessReason.highSoreness],
  );
}

ExerciseAnalyticsReadModel _readModel({
  ExerciseAnalyticsOverview? current,
  ExerciseAnalyticsOverview? previous,
}) {
  final currentOverview = current ?? _overview();
  final previousOverview = previous;

  return ExerciseAnalyticsReadModel(
    exerciseRef: ExerciseRef.official(
      id: OfficialExerciseId('barbell_bench_press'),
      displayNameSnapshot: 'Barbell Bench Press',
      catalogVersionSnapshot: '1.0.0',
    ),
    period: ExerciseAnalyticsPeriod(
      start: DateTime.utc(2026, 4, 28),
      end: DateTime.utc(2026, 5, 28),
    ),
    previousPeriod: ExerciseAnalyticsPeriod(
      start: DateTime.utc(2026, 3, 29),
      end: DateTime.utc(2026, 4, 28),
    ),
    overview: currentOverview,
    previousComparableSession: _comparison(currentOverview, previousOverview),
    timeWindow: _comparison(currentOverview, previousOverview),
    scannedSetCount:
        currentOverview.setCount + (previousOverview?.setCount ?? 0),
    reachedHistoryLimit: false,
  );
}

ExerciseAnalyticsComparison _comparison(
  ExerciseAnalyticsOverview current,
  ExerciseAnalyticsOverview? previous,
) {
  return ExerciseAnalyticsComparison(
    current: current,
    previous: previous,
    availability: previous == null || previous.isEmpty
        ? ExerciseAnalyticsComparisonAvailability.missingPrevious
        : ExerciseAnalyticsComparisonAvailability.available,
    totalVolumeKgDelta: ExerciseMetricDelta.fromValues(
      current: current.totalVolumeKg,
      previous: previous?.totalVolumeKg,
    ),
    bestEstimatedOneRepMaxKgDelta: ExerciseMetricDelta.fromValues(
      current: current.bestEstimatedOneRepMaxKg.value ?? 0,
      previous: previous?.bestEstimatedOneRepMaxKg.value,
    ),
  );
}

ExerciseAnalyticsOverview _overview({
  int setCount = 0,
  int totalRepetitions = 0,
  double totalVolumeKg = 0,
  double? averageKgPerRep,
  double? bestEstimatedOneRepMaxKg,
}) {
  return ExerciseAnalyticsOverview.fromSummary(
    WorkoutSetAnalyticsSummary(
      setCount: setCount,
      totalRepetitions: totalRepetitions,
      totalVolumeKg: totalVolumeKg,
      averageKgPerRep: averageKgPerRep,
      bestSetLoadKg: null,
      bestEstimatedOneRepMax: bestEstimatedOneRepMaxKg == null
          ? null
          : EstimatedOneRepMax(
              valueKg: bestEstimatedOneRepMaxKg,
              formulaIdentity: EpleyOneRepMaxFormula.epleyV1,
            ),
      oneRepMaxFormulaIdentity: EpleyOneRepMaxFormula.epleyV1,
    ),
  );
}
