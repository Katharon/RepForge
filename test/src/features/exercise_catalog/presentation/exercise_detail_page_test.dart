import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/app/localization/app_localizations.dart';
import 'package:repforge/src/core/theme/theme.dart';
import 'package:repforge/src/features/exercise_catalog/presentation/exercise_catalog_presentation.dart';
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
