import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/app/localization/app_localizations.dart';
import 'package:repforge/src/core/theme/theme.dart';
import 'package:repforge/src/features/analytics/presentation/analytics_presentation.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

void main() {
  testWidgets('loading state renders', (tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(
        ExerciseAnalyticsChartPage(
          exerciseRef: _benchRef,
          title: 'Barbell Bench Press',
          loader: _PendingExerciseAnalyticsChartLoader(),
        ),
      ),
    );

    expect(find.text('Loading exercise chart'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('empty state renders when no sets exist', (tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(
        ExerciseAnalyticsChartPage(
          exerciseRef: _benchRef,
          title: 'Barbell Bench Press',
          loader: _StaticExerciseAnalyticsChartLoader(_chartModel(points: [])),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No chart data yet'), findsOneWidget);
    expect(
      find.text('Log sets for this exercise to draw a local chart.'),
      findsOneWidget,
    );
  });

  testWidgets('one-point chart state renders selected point summary', (
    tester,
  ) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(
        ExerciseAnalyticsChartPage(
          exerciseRef: _benchRef,
          title: 'Barbell Bench Press',
          loader: _StaticExerciseAnalyticsChartLoader(
            _chartModel(points: [_point(id: 'set-1')]),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('exercise_analytics_chart_point_0')),
      findsOneWidget,
    );
    expect(find.text('Selected point'), findsOneWidget);
    expect(find.text('640 kg'), findsOneWidget);
    expect(find.textContaining('Jun 5, 2026'), findsOneWidget);
    expect(find.text('8 reps x 80 kg'), findsOneWidget);
  });

  testWidgets('multi-point chart state renders deterministic points', (
    tester,
  ) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(
        ExerciseAnalyticsChartPage(
          exerciseRef: _benchRef,
          title: 'Barbell Bench Press',
          loader: _StaticExerciseAnalyticsChartLoader(
            _chartModel(
              points: [
                _point(
                  id: 'set-1',
                  performedAt: DateTime.utc(2026, 6, 1, 9),
                  repetitions: 6,
                  loadKg: 75,
                ),
                _point(id: 'set-2'),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('exercise_analytics_chart_point_0')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('exercise_analytics_chart_point_1')),
      findsOneWidget,
    );
    expect(find.text('Exercise chart'), findsWidgets);
    expect(find.text('640 kg'), findsOneWidget);
  });

  testWidgets('error state renders retry copy', (tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(
        ExerciseAnalyticsChartPage(
          exerciseRef: _benchRef,
          title: 'Barbell Bench Press',
          loader: _FailingExerciseAnalyticsChartLoader(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Exercise chart could not load'), findsOneWidget);
    expect(
      find.text('Try again without changing local training data.'),
      findsOneWidget,
    );
  });

  testWidgets('metric selector changes metric deterministically', (
    tester,
  ) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(
        ExerciseAnalyticsChartPage(
          exerciseRef: _benchRef,
          title: 'Barbell Bench Press',
          loader: _StaticExerciseAnalyticsChartLoader(
            _chartModel(
              title: 'Bankdruecken mit Langhantel',
              points: [_point(id: 'set-1')],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Volume'), findsWidgets);
    expect(find.text('640 kg'), findsOneWidget);

    await tester.tap(
      find.byKey(const Key('exercise_analytics_metric_repetitions')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reps'), findsWidgets);
    expect(find.text('8'), findsOneWidget);
  });

  testWidgets('range selector changes range deterministically', (tester) async {
    _useLargeViewport(tester);
    final loader = _RecordingExerciseAnalyticsChartLoader(
      _chartModel(points: [_point(id: 'set-1')]),
    );

    await tester.pumpWidget(
      _testApp(
        ExerciseAnalyticsChartPage(
          exerciseRef: _benchRef,
          title: 'Barbell Bench Press',
          loader: loader,
          nowProvider: () => DateTime.utc(2026, 6, 6, 12),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('W'));
    await tester.pumpAndSettle();

    expect(loader.ranges, [
      ExerciseAnalyticsChartRange.month,
      ExerciseAnalyticsChartRange.week,
    ]);
  });

  testWidgets('selected data point updates by tapping chart point', (
    tester,
  ) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(
        ExerciseAnalyticsChartPage(
          exerciseRef: _benchRef,
          title: 'Barbell Bench Press',
          loader: _StaticExerciseAnalyticsChartLoader(
            _chartModel(
              points: [
                _point(
                  id: 'set-1',
                  performedAt: DateTime.utc(2026, 6, 1, 9),
                  repetitions: 6,
                  loadKg: 75,
                ),
                _point(id: 'set-2'),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('exercise_analytics_chart_point_0')));
    await tester.pumpAndSettle();

    expect(find.text('450 kg'), findsOneWidget);
    expect(find.textContaining('Jun 1, 2026'), findsOneWidget);
    expect(find.text('6 reps x 75 kg'), findsOneWidget);
  });

  testWidgets('estimated 1RM unavailable state renders with no valid data', (
    tester,
  ) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(
        ExerciseAnalyticsChartPage(
          exerciseRef: _benchRef,
          title: 'Barbell Bench Press',
          loader: _StaticExerciseAnalyticsChartLoader(_chartModel(points: [])),
          initialMetric: AnalyticsMetric.estimatedOneRepMaxKg,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Estimated 1RM unavailable'), findsOneWidget);
  });

  testWidgets('German localization covers chart labels', (tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(
        ExerciseAnalyticsChartPage(
          exerciseRef: _benchRef,
          title: 'Bankdruecken mit Langhantel',
          loader: _StaticExerciseAnalyticsChartLoader(
            _chartModel(
              title: 'Bankdruecken mit Langhantel',
              points: [_point(id: 'set-1')],
            ),
          ),
        ),
        locale: const Locale('de'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bankdruecken mit Langhantel'), findsWidgets);
    expect(find.text('Uebungsdiagramm'), findsWidgets);
    expect(find.text('Ausgewaehlter Punkt'), findsOneWidget);
    expect(find.text('Bereich'), findsOneWidget);
  });

  testWidgets('semantics labels exist for selectors, chart, and summary', (
    tester,
  ) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(
        ExerciseAnalyticsChartPage(
          exerciseRef: _benchRef,
          title: 'Barbell Bench Press',
          loader: _StaticExerciseAnalyticsChartLoader(
            _chartModel(points: [_point(id: 'set-1')]),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(_semanticsLabel('Metric selector'), findsOneWidget);
    expect(_semanticsLabel('Range selector'), findsOneWidget);
    expect(
      _semanticsLabelContaining('Exercise chart for Volume'),
      findsOneWidget,
    );
    expect(_semanticsLabelContaining('Selected point summary'), findsOneWidget);
  });

  test(
    'repository loader uses bounded timeline and never full history',
    () async {
      final repository = _RecordingWorkoutSetRepository([
        _workoutSet(id: 'set-1', performedAt: DateTime.utc(2026, 6, 5)),
      ]);
      final loader = RepositoryExerciseAnalyticsChartLoader(
        workoutSetRepository: repository,
        exerciseRef: _benchRef,
      );

      final model = await loader.load(
        ExerciseAnalyticsChartLoadRequest(
          range: ExerciseAnalyticsChartRange.all,
          now: DateTime.utc(2026, 6, 6),
        ),
      );

      expect(model.points, hasLength(1));
      expect(repository.timelineLimits, [100]);
      expect(repository.fullHistoryCalls, 0);
    },
  );
}

final _benchRef = ExerciseRef.official(
  id: OfficialExerciseId('barbell_bench_press'),
  displayNameSnapshot: 'Barbell Bench Press',
  catalogVersionSnapshot: '2026.06.0',
);

void _useLargeViewport(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1000, 1200);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

Widget _testApp(Widget child, {Locale? locale}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: RepForgeTheme.dark(),
    home: Scaffold(body: child),
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

ExerciseAnalyticsChartViewModel _chartModel({
  String title = 'Barbell Bench Press',
  List<ExerciseAnalyticsChartPointViewModel>? points,
}) {
  return ExerciseAnalyticsChartViewModel(
    exerciseRef: _benchRef,
    title: title,
    range: ExerciseAnalyticsChartRange.month,
    points: points ?? [_point(id: 'set-1')],
    reachedHistoryLimit: false,
  );
}

ExerciseAnalyticsChartPointViewModel _point({
  required String id,
  DateTime? performedAt,
  int repetitions = 8,
  double loadKg = 80,
}) {
  return ExerciseAnalyticsChartPointViewModel.fromWorkoutSet(
    _workoutSet(
      id: id,
      performedAt: performedAt ?? DateTime.utc(2026, 6, 5, 9, 30),
      repetitions: repetitions,
      loadKg: loadKg,
    ),
  );
}

WorkoutSet _workoutSet({
  required String id,
  required DateTime performedAt,
  int repetitions = 8,
  double loadKg = 80,
}) {
  return WorkoutSet(
    id: WorkoutSetId(id),
    exerciseRef: _benchRef,
    repetitions: Repetitions(repetitions),
    load: LoadKg(loadKg),
    performedAt: PerformedAt(performedAt),
  );
}

final class _PendingExerciseAnalyticsChartLoader
    implements ExerciseAnalyticsChartLoader {
  @override
  Future<ExerciseAnalyticsChartViewModel> load(
    ExerciseAnalyticsChartLoadRequest request,
  ) {
    return Completer<ExerciseAnalyticsChartViewModel>().future;
  }
}

final class _StaticExerciseAnalyticsChartLoader
    implements ExerciseAnalyticsChartLoader {
  const _StaticExerciseAnalyticsChartLoader(this.model);

  final ExerciseAnalyticsChartViewModel model;

  @override
  Future<ExerciseAnalyticsChartViewModel> load(
    ExerciseAnalyticsChartLoadRequest request,
  ) async {
    return model.copyWith(range: request.range);
  }
}

final class _RecordingExerciseAnalyticsChartLoader
    implements ExerciseAnalyticsChartLoader {
  _RecordingExerciseAnalyticsChartLoader(this.model);

  final ExerciseAnalyticsChartViewModel model;
  final List<ExerciseAnalyticsChartRange> ranges = [];

  @override
  Future<ExerciseAnalyticsChartViewModel> load(
    ExerciseAnalyticsChartLoadRequest request,
  ) async {
    ranges.add(request.range);
    return model.copyWith(range: request.range);
  }
}

final class _FailingExerciseAnalyticsChartLoader
    implements ExerciseAnalyticsChartLoader {
  @override
  Future<ExerciseAnalyticsChartViewModel> load(
    ExerciseAnalyticsChartLoadRequest request,
  ) {
    return Future<ExerciseAnalyticsChartViewModel>.error(StateError('boom'));
  }
}

final class _RecordingWorkoutSetRepository implements WorkoutSetRepository {
  _RecordingWorkoutSetRepository(this.sets);

  final List<WorkoutSet> sets;
  final List<int> timelineLimits = [];
  var fullHistoryCalls = 0;

  @override
  Future<WorkoutSetTimelinePage> timelineForExercise(
    WorkoutSetTimelineQuery query,
  ) async {
    timelineLimits.add(query.limit);
    return WorkoutSetTimelinePage(
      items: sets.take(query.limit),
      hasMore: sets.length > query.limit,
      nextCursor: null,
    );
  }

  @override
  Future<List<WorkoutSet>> historyForExercise(ExerciseRef exerciseRef) async {
    fullHistoryCalls += 1;
    return sets;
  }

  @override
  Future<void> save(WorkoutSet set) async {}

  @override
  Future<void> deleteById(WorkoutSetId id) async {}

  @override
  Future<WorkoutSet?> findById(WorkoutSetId id) async {
    for (final set in sets) {
      if (set.id == id) {
        return set;
      }
    }
    return null;
  }

  @override
  Future<WorkoutSetHistoryPage> searchHistory(
    WorkoutSetHistoryQuery query,
  ) async {
    return WorkoutSetHistoryPage(
      items: const [],
      totalCount: 0,
      limit: query.limit,
      offset: query.offset,
    );
  }

  @override
  Future<WorkoutSetDailySummary> dailySummary(
    WorkoutSetDailySummaryQuery query,
  ) async {
    return const WorkoutSetDailySummary(
      setCount: 0,
      totalVolumeKg: 0,
      lastLoggedSet: null,
    );
  }

  @override
  Future<List<WorkoutSet>> setsForWorkoutSession(
    WorkoutSessionId workoutSessionId,
  ) async {
    return const [];
  }
}
