import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/app/localization/app_localizations.dart';
import 'package:repforge/src/core/theme/theme.dart';
import 'package:repforge/src/features/analytics/presentation/analytics_presentation.dart';
import 'package:repforge/src/features/exercise_catalog/presentation/exercise_catalog_presentation.dart';
import 'package:repforge/src/features/recommendations/domain/recommendations_domain.dart';
import 'package:repforge/src/features/training_log/application/training_log_application.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

void main() {
  testWidgets('detail loading state renders', (tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(
        ExerciseDetailPage(
          exerciseRef: _benchRef,
          loader: _PendingExerciseDetailLoader(),
          onLogSet: (_) async => false,
        ),
      ),
    );

    expect(find.text('Loading exercise detail'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('detail empty state renders when no sets exist', (tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(
        ExerciseDetailPage(
          exerciseRef: _benchRef,
          loader: _StaticExerciseDetailLoader(_detailModel(historyGroups: [])),
          onLogSet: (_) async => false,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Barbell Bench Press'), findsWidgets);
    expect(find.text('No set history yet'), findsOneWidget);
    expect(
      find.text('Log a set to start this exercise history.'),
      findsOneWidget,
    );
  });

  testWidgets('detail error state renders', (tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(
        ExerciseDetailPage(
          exerciseRef: _benchRef,
          loader: _FailingExerciseDetailLoader(),
          onLogSet: (_) async => false,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Exercise detail could not load'), findsOneWidget);
    expect(find.text('Try again without changing local data.'), findsOneWidget);
  });

  testWidgets(
    'detail success renders grouped set history and unavailable previous',
    (tester) async {
      _useLargeViewport(tester);
      await tester.pumpWidget(
        _testApp(
          ExerciseDetailPage(
            exerciseRef: _benchRef,
            loader: _StaticExerciseDetailLoader(
              _detailModel(previousAvailable: false),
            ),
            onLogSet: (_) async => false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Analytics'), findsOneWidget);
      expect(find.text('1RM'), findsOneWidget);
      expect(find.text('Compared to previous'), findsOneWidget);
      expect(find.text('Previous session unavailable'), findsWidgets);
      expect(find.text('June 5, 2026'), findsOneWidget);
      expect(find.text('8 reps x 80 kg'), findsOneWidget);
      expect(find.text('Personal record'), findsOneWidget);
      expect(find.text('Controlled'), findsOneWidget);
    },
  );

  testWidgets('previous summary shows deterministic deltas', (tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(
        ExerciseDetailPage(
          exerciseRef: _benchRef,
          loader: _StaticExerciseDetailLoader(_detailModel()),
          onLogSet: (_) async => false,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sets'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('+1'), findsOneWidget);
    expect(find.text('Volume'), findsOneWidget);
    expect(find.text('1,360 kg'), findsOneWidget);
    expect(find.text('+560 kg'), findsOneWidget);
    expect(find.text('kg/rep'), findsOneWidget);
    expect(find.text('+5 kg'), findsOneWidget);
    expect(find.text('Estimated 1RM'), findsOneWidget);
    expect(find.text('+8 kg'), findsOneWidget);
  });

  testWidgets(
    'Log Set action passes current exercise and refreshes after save',
    (tester) async {
      _useLargeViewport(tester);
      final loader = _RecordingExerciseDetailLoader([
        _detailModel(historyGroups: []),
        _detailModel(),
      ]);
      final loggedRefs = <ExerciseRef>[];

      await tester.pumpWidget(
        _testApp(
          ExerciseDetailPage(
            exerciseRef: _benchRef,
            loader: loader,
            onLogSet: (exerciseRef) async {
              loggedRefs.add(exerciseRef);
              return true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('exercise_detail_log_set_button')));
      await tester.pumpAndSettle();

      expect(loggedRefs, [_benchRef]);
      expect(loader.loadCount, 2);
      expect(find.text('8 reps x 80 kg'), findsOneWidget);
    },
  );

  testWidgets(
    'adaptive suggestion appears and updates after logging from detail',
    (tester) async {
      _useLargeViewport(tester);
      final loader = _RecordingExerciseDetailLoader([
        _detailModel(historyGroups: []),
        _detailModel(),
        _detailModel(),
      ]);
      final suggestionLoader = _RecordingAdaptiveSuggestionLoader([
        _suggestion(
          direction: AdaptiveSetDirection.addWeight,
          suggestedLoadKg: 82.5,
          suggestedRepetitions: 8,
          reasons: const [
            AdaptiveSetReasonCode.baselineExceeded,
            AdaptiveSetReasonCode.loadIncrementApplied,
          ],
        ),
        _suggestion(
          direction: AdaptiveSetDirection.addReps,
          suggestedLoadKg: 80,
          suggestedRepetitions: 9,
          reasons: const [AdaptiveSetReasonCode.repProgressionAvailable],
        ),
      ]);

      await tester.pumpWidget(
        _testApp(
          ExerciseDetailPage(
            exerciseRef: _benchRef,
            loader: loader,
            adaptiveSuggestionLoader: suggestionLoader,
            onLogSet: (_) async => true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('exercise_detail_log_set_button')));
      await tester.pumpAndSettle();

      expect(loader.loadCount, 2);
      expect(suggestionLoader.loadCount, 1);
      expect(find.text('Next set signal'), findsOneWidget);
      expect(find.text('Add weight'), findsOneWidget);
      expect(
        find.text('Estimated next set: 8 reps x 82.5 kg.'),
        findsOneWidget,
      );
      expect(find.text('You beat the prior comparable set.'), findsOneWidget);
      expect(find.text('8 reps x 80 kg'), findsOneWidget);

      await tester.tap(find.byKey(const Key('exercise_detail_log_set_button')));
      await tester.pumpAndSettle();

      expect(loader.loadCount, 3);
      expect(suggestionLoader.loadCount, 2);
      expect(find.text('Add reps'), findsOneWidget);
      expect(find.text('Estimated next set: 9 reps x 80 kg.'), findsOneWidget);
    },
  );

  testWidgets('active session card coexists with adaptive detail refresh', (
    tester,
  ) async {
    _useLargeViewport(tester);
    final repository = _FakeWorkoutSetRepository();
    final workoutSessionController = WorkoutSessionController(
      workoutSetRepository: repository,
      workoutSessionIdProvider: () => WorkoutSessionId('detail-session'),
      nowProvider: () => DateTime.utc(2026, 6, 5, 9),
    );
    addTearDown(workoutSessionController.dispose);
    await workoutSessionController.start(
      sourceName: 'Push',
      exerciseRefs: [_benchRef],
    );
    final loader = _RecordingExerciseDetailLoader([
      _detailModel(historyGroups: []),
      _detailModel(),
    ]);
    final suggestionLoader = _StaticAdaptiveSuggestionLoader(
      _suggestion(
        direction: AdaptiveSetDirection.addWeight,
        suggestedLoadKg: 82.5,
        suggestedRepetitions: 8,
      ),
    );

    await tester.pumpWidget(
      _testApp(
        ExerciseDetailPage(
          exerciseRef: _benchRef,
          loader: loader,
          adaptiveSuggestionLoader: suggestionLoader,
          workoutSessionController: workoutSessionController,
          onLogSet: (_) async => true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('workout_session_active_card')), findsOneWidget);
    expect(find.text('Active session'), findsOneWidget);

    await tester.tap(find.byKey(const Key('exercise_detail_log_set_button')));
    await tester.pumpAndSettle();

    expect(loader.loadCount, 2);
    expect(suggestionLoader.loadCount, 1);
    expect(find.text('Next set signal'), findsOneWidget);
    expect(find.byKey(const Key('workout_session_active_card')), findsOneWidget);
  });

  testWidgets('adaptive suggestion handles insufficient history safely', (
    tester,
  ) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(
        ExerciseDetailPage(
          exerciseRef: _benchRef,
          loader: _RecordingExerciseDetailLoader([
            _detailModel(historyGroups: []),
            _detailModel(),
          ]),
          adaptiveSuggestionLoader: _StaticAdaptiveSuggestionLoader(
            _suggestion(
              direction: AdaptiveSetDirection.maintain,
              hasComparableBaseline: false,
              reasons: const [AdaptiveSetReasonCode.noBaseline],
            ),
          ),
          onLogSet: (_) async => true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('exercise_detail_log_set_button')));
    await tester.pumpAndSettle();

    expect(find.text('Maintain'), findsOneWidget);
    expect(
      find.text('Keep this target for the next set: 8 reps x 80 kg.'),
      findsOneWidget,
    );
    expect(
      find.text('Limited local history, so this is a light suggestion.'),
      findsOneWidget,
    );
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('backoff suggestion remains advisory and dismissible', (
    tester,
  ) async {
    _useLargeViewport(tester);
    var logCount = 0;
    final suggestionLoader = _StaticAdaptiveSuggestionLoader(
      _suggestion(
        direction: AdaptiveSetDirection.backoff,
        suggestedLoadKg: 72.5,
        suggestedRepetitions: 6,
        reasons: const [AdaptiveSetReasonCode.lowReadiness],
      ),
    );

    await tester.pumpWidget(
      _testApp(
        ExerciseDetailPage(
          exerciseRef: _benchRef,
          loader: _RecordingExerciseDetailLoader([
            _detailModel(),
            _detailModel(),
            _detailModel(),
          ]),
          adaptiveSuggestionLoader: suggestionLoader,
          onLogSet: (_) async {
            logCount += 1;
            return true;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('exercise_detail_log_set_button')));
    await tester.pumpAndSettle();
    expect(find.text('Ease back'), findsOneWidget);
    expect(
      find.text('A conservative next set could be 6 reps x 72.5 kg.'),
      findsOneWidget,
    );

    await tester.tap(find.byTooltip('Ignore'));
    await tester.pumpAndSettle();
    expect(find.text('Ease back'), findsNothing);

    await tester.tap(find.byKey(const Key('exercise_detail_log_set_button')));
    await tester.pumpAndSettle();
    expect(logCount, 2);
    expect(suggestionLoader.loadCount, 2);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Analytics and 1RM cards open chart callbacks', (tester) async {
    _useLargeViewport(tester);
    final openedMetrics = <AnalyticsMetric>[];

    await tester.pumpWidget(
      _testApp(
        ExerciseDetailPage(
          exerciseRef: _benchRef,
          loader: _StaticExerciseDetailLoader(_detailModel()),
          onLogSet: (_) async => false,
          onOpenAnalytics: (exerciseRef, metric) {
            expect(exerciseRef, _benchRef);
            openedMetrics.add(metric);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Analytics'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1RM'));
    await tester.pumpAndSettle();

    expect(openedMetrics, [
      AnalyticsMetric.volumeKg,
      AnalyticsMetric.estimatedOneRepMaxKg,
    ]);
  });

  testWidgets('German localization covers detail labels', (tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(
        ExerciseDetailPage(
          exerciseRef: _benchRef,
          loader: _StaticExerciseDetailLoader(
            _detailModel(title: 'Bankdruecken mit Langhantel'),
          ),
          onLogSet: (_) async => false,
        ),
        locale: const Locale('de'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bankdruecken mit Langhantel'), findsWidgets);
    expect(find.text('Satz protokollieren'), findsOneWidget);
    expect(find.text('Vergleich zur vorherigen Einheit'), findsOneWidget);
    expect(find.text('Saetze'), findsOneWidget);
    expect(find.text('Volumen'), findsOneWidget);
    expect(find.text('kg/Wdh.'), findsOneWidget);
    expect(find.text('Satzverlauf'), findsOneWidget);
  });

  testWidgets('German localization covers adaptive suggestion labels', (
    tester,
  ) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(
        ExerciseDetailPage(
          exerciseRef: _benchRef,
          loader: _RecordingExerciseDetailLoader([
            _detailModel(title: 'Bankdruecken mit Langhantel'),
            _detailModel(title: 'Bankdruecken mit Langhantel'),
          ]),
          adaptiveSuggestionLoader: _StaticAdaptiveSuggestionLoader(
            _suggestion(
              direction: AdaptiveSetDirection.addWeight,
              suggestedLoadKg: 82.5,
              suggestedRepetitions: 8,
              reasons: const [
                AdaptiveSetReasonCode.baselineExceeded,
                AdaptiveSetReasonCode.loadIncrementApplied,
              ],
            ),
          ),
          onLogSet: (_) async => true,
        ),
        locale: const Locale('de'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('exercise_detail_log_set_button')));
    await tester.pumpAndSettle();

    expect(find.text('Naechster Satz'), findsOneWidget);
    expect(find.text('Gewicht erhoehen'), findsOneWidget);
    expect(
      find.text('Geschaetzter naechster Satz: 8 Wdh. x 82,5 kg.'),
      findsOneWidget,
    );
    expect(find.byTooltip('Ignorieren'), findsOneWidget);
  });

  testWidgets('semantic labels exist for actions and set rows', (tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(
        ExerciseDetailPage(
          exerciseRef: _benchRef,
          loader: _StaticExerciseDetailLoader(_detailModel()),
          onLogSet: (_) async => false,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      _semanticsLabel('Open Analytics for Barbell Bench Press'),
      findsOneWidget,
    );
    expect(_semanticsLabel('Open 1RM for Barbell Bench Press'), findsOneWidget);
    expect(_semanticsLabel('Log set for Barbell Bench Press'), findsOneWidget);
    expect(_semanticsLabel('Set, 8 reps at 80 kg'), findsOneWidget);
  });

  testWidgets('adaptive suggestion has semantic label', (tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(
        ExerciseDetailPage(
          exerciseRef: _benchRef,
          loader: _RecordingExerciseDetailLoader([
            _detailModel(),
            _detailModel(),
          ]),
          adaptiveSuggestionLoader: _StaticAdaptiveSuggestionLoader(
            _suggestion(
              direction: AdaptiveSetDirection.addWeight,
              suggestedLoadKg: 82.5,
              suggestedRepetitions: 8,
            ),
          ),
          onLogSet: (_) async => true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('exercise_detail_log_set_button')));
    await tester.pumpAndSettle();

    expect(
      _semanticsLabel(
        'Next set signal: Add weight. Estimated next set: 8 reps x 82.5 kg.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('loader requests bounded history', (tester) async {
    final loader = _RecordingExerciseDetailLoader([_detailModel()]);
    await loader.load(_benchRef);

    expect(loader.requestedHistoryLimits, [30]);
  });
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

ExerciseDetailViewModel _detailModel({
  String title = 'Barbell Bench Press',
  bool previousAvailable = true,
  List<ExerciseDetailHistoryGroupViewModel>? historyGroups,
}) {
  return ExerciseDetailViewModel(
    exerciseRef: _benchRef,
    title: title,
    tags: const ['barbell', 'horizontal_push', 'chest'],
    summary: ExerciseDetailSummaryViewModel(
      previousAvailable: previousAvailable,
      metrics: [
        ExerciseDetailMetricViewModel(
          label: 'Sets',
          value: '2',
          delta: previousAvailable ? '+1' : null,
        ),
        ExerciseDetailMetricViewModel(
          label: 'Repetitions',
          value: '17',
          delta: previousAvailable ? '+7' : null,
        ),
        ExerciseDetailMetricViewModel(
          label: 'Volume',
          value: '1,360 kg',
          delta: previousAvailable ? '+560 kg' : null,
        ),
        ExerciseDetailMetricViewModel(
          label: 'kg/rep',
          value: '80 kg',
          delta: previousAvailable ? '+5 kg' : null,
        ),
        ExerciseDetailMetricViewModel(
          label: 'Estimated 1RM',
          value: '101 kg',
          delta: previousAvailable ? '+8 kg' : null,
        ),
      ],
    ),
    historyGroups:
        historyGroups ??
        [
          ExerciseDetailHistoryGroupViewModel(
            localDate: DateTime(2026, 6, 5),
            sets: [
              ExerciseDetailSetViewModel(
                performedAt: DateTime(2026, 6, 5, 9, 30),
                repetitions: 8,
                loadKg: 80,
                label: WorkoutSetLabel.personalRecord,
                comment: 'Controlled',
              ),
              ExerciseDetailSetViewModel(
                performedAt: DateTime(2026, 6, 5, 9, 20),
                repetitions: 9,
                loadKg: 80,
              ),
            ],
          ),
        ],
    historyLimit: 30,
    hasMoreHistory: false,
  );
}

final class _PendingExerciseDetailLoader implements ExerciseDetailLoader {
  @override
  Future<ExerciseDetailViewModel> load(
    ExerciseRef exerciseRef, {
    Locale? locale,
    int historyLimit = 30,
  }) {
    return Completer<ExerciseDetailViewModel>().future;
  }
}

final class _StaticExerciseDetailLoader implements ExerciseDetailLoader {
  const _StaticExerciseDetailLoader(this.model);

  final ExerciseDetailViewModel model;

  @override
  Future<ExerciseDetailViewModel> load(
    ExerciseRef exerciseRef, {
    Locale? locale,
    int historyLimit = 30,
  }) async {
    return model;
  }
}

final class _RecordingExerciseDetailLoader implements ExerciseDetailLoader {
  _RecordingExerciseDetailLoader(this.models);

  final List<ExerciseDetailViewModel> models;
  final List<int> requestedHistoryLimits = [];
  int loadCount = 0;

  @override
  Future<ExerciseDetailViewModel> load(
    ExerciseRef exerciseRef, {
    Locale? locale,
    int historyLimit = 30,
  }) async {
    requestedHistoryLimits.add(historyLimit);
    final index = loadCount >= models.length ? models.length - 1 : loadCount;
    loadCount += 1;
    return models[index];
  }
}

final class _FailingExerciseDetailLoader implements ExerciseDetailLoader {
  @override
  Future<ExerciseDetailViewModel> load(
    ExerciseRef exerciseRef, {
    Locale? locale,
    int historyLimit = 30,
  }) {
    return Future<ExerciseDetailViewModel>.error(StateError('boom'));
  }
}

ExerciseDetailAdaptiveSuggestionViewModel _suggestion({
  required AdaptiveSetDirection direction,
  double currentLoadKg = 80,
  int currentRepetitions = 8,
  double? suggestedLoadKg,
  int? suggestedRepetitions,
  bool hasComparableBaseline = true,
  List<AdaptiveSetReasonCode> reasons = const <AdaptiveSetReasonCode>[
    AdaptiveSetReasonCode.baselineMatched,
  ],
}) {
  return ExerciseDetailAdaptiveSuggestionViewModel(
    direction: direction,
    inputQuality: hasComparableBaseline
        ? AdaptiveSetInputQuality.ready
        : AdaptiveSetInputQuality.partial,
    currentLoadKg: currentLoadKg,
    currentRepetitions: currentRepetitions,
    suggestedLoadKg: suggestedLoadKg ?? currentLoadKg,
    suggestedRepetitions: suggestedRepetitions ?? currentRepetitions,
    hasComparableBaseline: hasComparableBaseline,
    allowsWorkoutLogging: true,
    userOverrideAllowed: true,
    reasons: reasons,
  );
}

final class _StaticAdaptiveSuggestionLoader
    implements ExerciseDetailAdaptiveSuggestionLoader {
  _StaticAdaptiveSuggestionLoader(this.suggestion);

  final ExerciseDetailAdaptiveSuggestionViewModel? suggestion;
  int loadCount = 0;

  @override
  Future<ExerciseDetailAdaptiveSuggestionViewModel?> load(
    ExerciseRef exerciseRef, {
    Locale? locale,
  }) async {
    loadCount += 1;
    return suggestion;
  }
}

final class _RecordingAdaptiveSuggestionLoader
    implements ExerciseDetailAdaptiveSuggestionLoader {
  _RecordingAdaptiveSuggestionLoader(this.suggestions);

  final List<ExerciseDetailAdaptiveSuggestionViewModel?> suggestions;
  int loadCount = 0;

  @override
  Future<ExerciseDetailAdaptiveSuggestionViewModel?> load(
    ExerciseRef exerciseRef, {
    Locale? locale,
  }) async {
    final index = loadCount >= suggestions.length
        ? suggestions.length - 1
        : loadCount;
    loadCount += 1;
    return suggestions[index];
  }
}

final class _FakeWorkoutSetRepository implements WorkoutSetRepository {
  @override
  Future<void> save(WorkoutSet set) async {}

  @override
  Future<void> deleteById(WorkoutSetId id) async {}

  @override
  Future<WorkoutSet?> findById(WorkoutSetId id) async => null;

  @override
  Future<List<WorkoutSet>> historyForExercise(ExerciseRef exerciseRef) async {
    return const [];
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
  Future<List<WorkoutSet>> setsForWorkoutSession(
    WorkoutSessionId workoutSessionId,
  ) async {
    return const [];
  }

  @override
  Future<WorkoutSetTimelinePage> timelineForExercise(
    WorkoutSetTimelineQuery query,
  ) async {
    return WorkoutSetTimelinePage(
      items: const [],
      hasMore: false,
      nextCursor: null,
    );
  }
}
