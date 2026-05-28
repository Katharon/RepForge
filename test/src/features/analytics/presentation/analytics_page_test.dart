import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/app/localization/app_localizations.dart';
import 'package:repforge/src/core/theme/theme.dart';
import 'package:repforge/src/features/analytics/application/analytics_application.dart';
import 'package:repforge/src/features/analytics/domain/analytics_domain.dart';
import 'package:repforge/src/features/analytics/presentation/analytics_presentation.dart';
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
}

Widget _testApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: RepForgeTheme.dark(),
    home: Scaffold(body: child),
  );
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
