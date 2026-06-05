import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/app/localization/app_localizations.dart';
import 'package:repforge/src/core/theme/theme.dart';
import 'package:repforge/src/features/exercise_catalog/presentation/exercise_catalog_presentation.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';
import 'package:repforge/src/features/workout_groups/presentation/workout_groups_presentation.dart';

void main() {
  testWidgets('loading state renders', (tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(GroupsPage(loader: _PendingTrainPageLoader())),
    );

    expect(find.text('Loading training'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('empty state renders', (tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(
        GroupsPage(
          loader: _StaticTrainPageLoader(
            const TrainLandingViewModel(
              categories: [],
              groups: [],
              totalGroupCount: 0,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No training categories ready'), findsOneWidget);
    expect(find.text('Complete catalog import and try again.'), findsOneWidget);
  });

  testWidgets('error state renders', (tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(GroupsPage(loader: _FailingTrainPageLoader())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Training could not load'), findsOneWidget);
    expect(find.text('Try again without changing local data.'), findsOneWidget);
  });

  testWidgets('landing shows training categories and deterministic counts', (
    tester,
  ) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(GroupsPage(loader: _StaticTrainPageLoader(_trainModel()))),
    );
    await tester.pumpAndSettle();

    expect(find.text('Train'), findsWidgets);
    expect(find.text('New workout'), findsOneWidget);
    expect(find.text('My Exercises'), findsOneWidget);
    expect(find.text('Full Body'), findsOneWidget);
    expect(find.text('Upper Body'), findsOneWidget);
    expect(find.text('Lower Body'), findsOneWidget);
    expect(find.text('Push'), findsOneWidget);
    expect(find.text('Pull'), findsOneWidget);
    expect(find.text('Legs'), findsOneWidget);
    expect(find.text('Core'), findsOneWidget);
    expect(find.text('6 exercises'), findsOneWidget);
    expect(find.text('1 exercise'), findsWidgets);
  });

  testWidgets('category rows expose semantic summaries', (tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(GroupsPage(loader: _StaticTrainPageLoader(_trainModel()))),
    );
    await tester.pumpAndSettle();

    expect(_semanticsLabel('Push, 2 exercises'), findsOneWidget);
    expect(_semanticsLabel('My Exercises, 6 exercises'), findsOneWidget);
  });

  testWidgets('opening Push shows push-relevant exercises', (tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(GroupsPage(loader: _StaticTrainPageLoader(_trainModel()))),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Push'));
    await tester.pumpAndSettle();

    expect(find.text('Barbell Bench Press'), findsOneWidget);
    expect(find.text('Dumbbell Shoulder Press'), findsOneWidget);
    expect(find.text('Seated Cable Row'), findsNothing);
  });

  testWidgets('opening Pull shows pull-relevant exercises', (tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(GroupsPage(loader: _StaticTrainPageLoader(_trainModel()))),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pull'));
    await tester.pumpAndSettle();

    expect(find.text('Seated Cable Row'), findsOneWidget);
    expect(find.text('Barbell Bench Press'), findsNothing);
  });

  testWidgets('opening Legs shows lower-body exercises', (tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(GroupsPage(loader: _StaticTrainPageLoader(_trainModel()))),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Legs'));
    await tester.pumpAndSettle();

    expect(find.text('Barbell Back Squat'), findsOneWidget);
    expect(find.text('Romanian Deadlift'), findsOneWidget);
    expect(find.text('Barbell Bench Press'), findsNothing);
  });

  testWidgets('opening My Exercises shows all available exercises', (
    tester,
  ) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(GroupsPage(loader: _StaticTrainPageLoader(_trainModel()))),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('My Exercises'));
    await tester.pumpAndSettle();

    expect(find.text('Barbell Bench Press'), findsOneWidget);
    expect(find.text('Seated Cable Row'), findsOneWidget);
    expect(find.text('Barbell Back Squat'), findsOneWidget);
    expect(find.text('Plank'), findsOneWidget);
  });

  testWidgets('category search filters within selected category', (
    tester,
  ) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(GroupsPage(loader: _StaticTrainPageLoader(_trainModel()))),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('My Exercises'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('train_category_search_field')),
      'row',
    );
    await tester.tap(find.byKey(const Key('train_category_search_button')));
    await tester.pumpAndSettle();

    expect(find.text('Seated Cable Row'), findsOneWidget);
    expect(find.text('Barbell Bench Press'), findsNothing);
  });

  testWidgets('tapping Train exercise emits stable exercise ref', (
    tester,
  ) async {
    _useLargeViewport(tester);
    final opened = <ExerciseRef>[];
    await tester.pumpWidget(
      _testApp(
        GroupsPage(
          loader: _StaticTrainPageLoader(_trainModel()),
          onOpenExercise: opened.add,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('My Exercises'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Barbell Bench Press'));
    await tester.pumpAndSettle();

    expect(opened.single.id, 'barbell_bench_press');
    expect(opened.single.displayNameSnapshot, 'Barbell Bench Press');
  });

  testWidgets('German localization covers Train labels', (tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(
      _testApp(
        GroupsPage(loader: _StaticTrainPageLoader(_trainModel())),
        locale: const Locale('de'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Training'), findsWidgets);
    expect(find.text('Neues Workout'), findsOneWidget);
    expect(find.text('Meine Uebungen'), findsOneWidget);
    expect(find.text('Ganzkoerper'), findsOneWidget);
    expect(find.text('Oberkoerper'), findsOneWidget);
    expect(find.text('Unterkoerper'), findsOneWidget);
  });
}

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

TrainLandingViewModel _trainModel() {
  return TrainLandingViewModel.fromExercises(
    exercises: const [
      ExerciseListItemViewModel(
        id: 'barbell_bench_press',
        name: 'Barbell Bench Press',
        equipment: ['barbell'],
        movementPatterns: ['horizontal_push'],
        primaryMuscles: ['chest'],
        secondaryMuscles: ['triceps', 'front_deltoids'],
      ),
      ExerciseListItemViewModel(
        id: 'dumbbell_shoulder_press',
        name: 'Dumbbell Shoulder Press',
        equipment: ['dumbbells'],
        movementPatterns: ['vertical_push'],
        primaryMuscles: ['shoulders'],
        secondaryMuscles: ['triceps'],
      ),
      ExerciseListItemViewModel(
        id: 'seated_cable_row',
        name: 'Seated Cable Row',
        equipment: ['cable_machine'],
        movementPatterns: ['horizontal_pull'],
        primaryMuscles: ['lats', 'upper_back'],
        secondaryMuscles: ['biceps'],
      ),
      ExerciseListItemViewModel(
        id: 'barbell_back_squat',
        name: 'Barbell Back Squat',
        equipment: ['barbell', 'rack'],
        movementPatterns: ['squat', 'knee_dominant'],
        primaryMuscles: ['quadriceps', 'glutes'],
        secondaryMuscles: ['hamstrings'],
      ),
      ExerciseListItemViewModel(
        id: 'romanian_deadlift',
        name: 'Romanian Deadlift',
        equipment: ['barbell'],
        movementPatterns: ['hinge'],
        primaryMuscles: ['hamstrings', 'glutes'],
        secondaryMuscles: ['erector_spinae'],
      ),
      ExerciseListItemViewModel(
        id: 'plank',
        name: 'Plank',
        equipment: ['bodyweight'],
        movementPatterns: ['core'],
        primaryMuscles: ['core'],
      ),
    ],
    groups: const [
      WorkoutGroupListItemViewModel(
        id: 'push_day',
        name: 'Push Day',
        exerciseCount: 2,
        exerciseNames: ['Barbell Bench Press', 'Dumbbell Shoulder Press'],
      ),
    ],
    totalGroupCount: 1,
  );
}

final class _PendingTrainPageLoader implements TrainPageLoader {
  @override
  Future<TrainLandingViewModel> load({Locale? locale}) {
    return Completer<TrainLandingViewModel>().future;
  }
}

final class _StaticTrainPageLoader implements TrainPageLoader {
  const _StaticTrainPageLoader(this.model);

  final TrainLandingViewModel model;

  @override
  Future<TrainLandingViewModel> load({Locale? locale}) async {
    return model;
  }
}

final class _FailingTrainPageLoader implements TrainPageLoader {
  @override
  Future<TrainLandingViewModel> load({Locale? locale}) {
    return Future<TrainLandingViewModel>.error(StateError('boom'));
  }
}
