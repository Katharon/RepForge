import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/app/localization/app_localizations.dart';
import 'package:repforge/src/core/theme/theme.dart';
import 'package:repforge/src/features/exercise_catalog/presentation/exercise_catalog_presentation.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

void main() {
  testWidgets('loading state renders', (tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(ExercisesPage(loader: _PendingExerciseCatalogListLoader())),
    );

    expect(find.text('Loading exercises'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('empty state renders', (tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(
        ExercisesPage(
          loader: _StaticExerciseCatalogListLoader(
            const ExerciseCatalogListViewModel(
              exercises: [],
              totalCount: 0,
              hasMore: false,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No exercises found'), findsOneWidget);
    expect(find.text('Exercises will use the bundled catalog'), findsNothing);
  });

  testWidgets('error state renders', (tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(ExercisesPage(loader: _FailingExerciseCatalogListLoader())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Exercises could not load'), findsOneWidget);
    expect(find.text('Try again without changing local data.'), findsOneWidget);
  });

  testWidgets('success state renders catalog exercise metadata', (
    tester,
  ) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(
        ExercisesPage(
          loader: _StaticExerciseCatalogListLoader(
            const ExerciseCatalogListViewModel(
              exercises: [
                ExerciseListItemViewModel(
                  id: 'barbell_bench_press',
                  name: 'Barbell Bench Press',
                  equipment: ['barbell'],
                  movementPatterns: ['horizontal_push'],
                  primaryMuscles: ['chest'],
                ),
              ],
              totalCount: 1,
              hasMore: false,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Barbell Bench Press'), findsOneWidget);
    expect(find.text('Barbell'), findsOneWidget);
    expect(find.text('Horizontal Push'), findsOneWidget);
    expect(find.text('Chest'), findsOneWidget);
  });

  testWidgets('search text is forwarded to loader', (tester) async {
    _useLargeViewport(tester);
    final loader = _RecordingExerciseCatalogListLoader();

    await tester.pumpWidget(_testApp(ExercisesPage(loader: loader)));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('exercise_catalog_search_field')),
      'bench',
    );
    await tester.tap(find.byKey(const Key('exercise_catalog_search_button')));
    await tester.pumpAndSettle();

    expect(loader.searches, contains('bench'));
  });

  testWidgets('tapping catalog exercise emits stable exercise ref', (
    tester,
  ) async {
    _useLargeViewport(tester);
    final opened = <ExerciseRef>[];

    await tester.pumpWidget(
      _testApp(
        ExercisesPage(
          loader: const _StaticExerciseCatalogListLoader(
            ExerciseCatalogListViewModel(
              exercises: [
                ExerciseListItemViewModel(
                  id: 'barbell_bench_press',
                  name: 'Barbell Bench Press',
                  catalogVersionSnapshot: '2026.06.0',
                  equipment: ['barbell'],
                  movementPatterns: ['horizontal_push'],
                  primaryMuscles: ['chest'],
                ),
              ],
              totalCount: 1,
              hasMore: false,
            ),
          ),
          onOpenExercise: opened.add,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Barbell Bench Press'));
    await tester.pumpAndSettle();

    expect(opened.single.id, 'barbell_bench_press');
    expect(opened.single.displayNameSnapshot, 'Barbell Bench Press');
    expect(opened.single.catalogVersionSnapshot, '2026.06.0');
  });

  testWidgets('custom exercise appears in list and search with custom badge', (
    tester,
  ) async {
    _useLargeViewport(tester);
    final loader = _RecordingExerciseCatalogListLoader(
      exercise: const ExerciseListItemViewModel(
        id: 'custom_cable_fly',
        name: 'Cable Fly',
        source: ExerciseSource.custom,
        notes: 'Slow tempo',
        equipment: ['cable'],
        movementPatterns: ['horizontal_push'],
        primaryMuscles: ['chest'],
      ),
    );

    await tester.pumpWidget(_testApp(ExercisesPage(loader: loader)));
    await tester.pumpAndSettle();

    expect(find.text('Cable Fly'), findsOneWidget);
    expect(find.text('Custom'), findsOneWidget);
    expect(find.text('Slow tempo'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('exercise_catalog_search_field')),
      'cable',
    );
    await tester.tap(find.byKey(const Key('exercise_catalog_search_button')));
    await tester.pumpAndSettle();

    expect(loader.searches, contains('cable'));
  });

  testWidgets('official exercise does not expose custom edit actions', (
    tester,
  ) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(
        ExercisesPage(
          loader: const _StaticExerciseCatalogListLoader(
            ExerciseCatalogListViewModel(
              exercises: [
                ExerciseListItemViewModel(
                  id: 'barbell_bench_press',
                  name: 'Barbell Bench Press',
                  equipment: ['barbell'],
                  movementPatterns: ['horizontal_push'],
                  primaryMuscles: ['chest'],
                ),
              ],
              totalCount: 1,
              hasMore: false,
            ),
          ),
          onEditCustomExercise: (_) async => true,
          onArchiveCustomExercise: (_) async => true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Official'), findsOneWidget);
    expect(find.byTooltip('Custom exercise actions'), findsNothing);
  });

  testWidgets('custom exercise edit and archive callbacks reload list', (
    tester,
  ) async {
    _useLargeViewport(tester);
    final loader = _RecordingExerciseCatalogListLoader(
      exercise: const ExerciseListItemViewModel(
        id: 'custom_cable_fly',
        name: 'Cable Fly',
        source: ExerciseSource.custom,
        equipment: ['cable'],
        movementPatterns: ['horizontal_push'],
        primaryMuscles: ['chest'],
      ),
    );
    final edited = <ExerciseListItemViewModel>[];
    final archived = <ExerciseListItemViewModel>[];

    await tester.pumpWidget(
      _testApp(
        ExercisesPage(
          loader: loader,
          onEditCustomExercise: (exercise) async {
            edited.add(exercise);
            return true;
          },
          onArchiveCustomExercise: (exercise) async {
            archived.add(exercise);
            return true;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Custom exercise actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit exercise'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Custom exercise actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Archive exercise'));
    await tester.pumpAndSettle();

    expect(edited.single.id, 'custom_cable_fly');
    expect(archived.single.id, 'custom_cable_fly');
    expect(loader.searches, hasLength(greaterThanOrEqualTo(3)));
  });
}

void _useLargeViewport(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1000, 1200);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

Widget _testApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: RepForgeTheme.dark(),
    home: Scaffold(body: child),
  );
}

final class _PendingExerciseCatalogListLoader
    implements ExerciseCatalogListLoader {
  @override
  Future<ExerciseCatalogListViewModel> load({
    String? searchText,
    Locale? locale,
  }) {
    return Completer<ExerciseCatalogListViewModel>().future;
  }
}

final class _StaticExerciseCatalogListLoader
    implements ExerciseCatalogListLoader {
  const _StaticExerciseCatalogListLoader(this.model);

  final ExerciseCatalogListViewModel model;

  @override
  Future<ExerciseCatalogListViewModel> load({
    String? searchText,
    Locale? locale,
  }) async {
    return model;
  }
}

final class _RecordingExerciseCatalogListLoader
    implements ExerciseCatalogListLoader {
  _RecordingExerciseCatalogListLoader({
    this.exercise = const ExerciseListItemViewModel(
      id: 'barbell_bench_press',
      name: 'Barbell Bench Press',
      equipment: ['barbell'],
      movementPatterns: ['horizontal_push'],
      primaryMuscles: ['chest'],
    ),
  });

  final ExerciseListItemViewModel exercise;
  final List<String?> searches = [];

  @override
  Future<ExerciseCatalogListViewModel> load({
    String? searchText,
    Locale? locale,
  }) async {
    searches.add(searchText);
    return ExerciseCatalogListViewModel(
      exercises: [exercise],
      totalCount: 1,
      hasMore: false,
    );
  }
}

final class _FailingExerciseCatalogListLoader
    implements ExerciseCatalogListLoader {
  @override
  Future<ExerciseCatalogListViewModel> load({
    String? searchText,
    Locale? locale,
  }) {
    return Future<ExerciseCatalogListViewModel>.error(StateError('boom'));
  }
}
