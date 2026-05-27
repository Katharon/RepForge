import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:repforge/src/app/composition_root.dart';
import 'package:repforge/src/app/navigation/app_route.dart';
import 'package:repforge/src/app/repforge_app.dart';
import 'package:repforge/src/core/theme/theme.dart';
import 'package:repforge/src/core/widgets/widgets.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

void main() {
  test('test app dependencies expose configuration and repository', () {
    final dependencies = _testAppDependencies();

    expect(dependencies.configuration.locale, isNull);
    expect(dependencies.workoutSetRepository, isNotNull);
  });

  test('route map exposes stable route names and paths', () {
    expect(AppRoute.today.name, 'today');
    expect(AppRoute.today.path, '/today');
    expect(AppRoute.groups.name, 'groups');
    expect(AppRoute.groups.path, '/groups');
    expect(AppRoute.exercises.name, 'exercises');
    expect(AppRoute.exercises.path, '/exercises');
    expect(AppRoute.analytics.name, 'analytics');
    expect(AppRoute.analytics.path, '/analytics');
    expect(AppRoute.settings.name, 'settings');
    expect(AppRoute.settings.path, '/settings');
  });

  testWidgets('starts with English navigation labels by default', (
    tester,
  ) async {
    final dependencies = _testAppDependencies();

    await tester.pumpWidget(RepForgeApp(dependencies: dependencies));

    expect(find.text('Today'), findsWidgets);
    expect(find.text('Groups'), findsWidgets);
    expect(find.text('Exercises'), findsWidgets);
    expect(find.text('Analytics'), findsWidgets);
    expect(find.text('Settings'), findsWidgets);
    expect(
      find.text('Today is ready for the next tracking slice.'),
      findsOneWidget,
    );
    expect(find.byType(AppCard), findsOneWidget);
  });

  testWidgets('renders German navigation labels with forced German locale', (
    tester,
  ) async {
    final dependencies = _testAppDependencies(
      configuration: AppConfiguration(locale: Locale('de')),
    );

    await tester.pumpWidget(RepForgeApp(dependencies: dependencies));

    expect(find.text('Heute'), findsWidgets);
    expect(find.text('Gruppen'), findsWidgets);
    expect(find.text('Uebungen'), findsWidgets);
    expect(find.text('Analyse'), findsWidgets);
    expect(find.text('Einstellungen'), findsWidgets);
    expect(
      find.text('Heute wartet auf den naechsten Tracking-Slice.'),
      findsOneWidget,
    );
  });

  testWidgets('tapping each destination shows the matching placeholder', (
    tester,
  ) async {
    final dependencies = _testAppDependencies();

    await tester.pumpWidget(RepForgeApp(dependencies: dependencies));

    const destinations = <String, String>{
      'Groups': 'Workout groups will be connected in a later slice.',
      'Exercises': 'Exercises will use the bundled catalog and custom entries.',
      'Analytics': 'Analytics will show local training trends later.',
      'Settings': 'Settings will stay local-first when implemented.',
      'Today': 'Today is ready for the next tracking slice.',
    };

    for (final entry in destinations.entries) {
      await tester.tap(find.text(entry.key).last);
      await tester.pumpAndSettle();

      expect(find.text(entry.value), findsOneWidget);
    }
  });

  testWidgets('applies the dark RepForge theme', (tester) async {
    final dependencies = _testAppDependencies();

    await tester.pumpWidget(RepForgeApp(dependencies: dependencies));

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    final theme = materialApp.theme;
    final metricColors = theme?.extension<RepForgeMetricColors>();

    expect(materialApp.themeMode, ThemeMode.dark);
    expect(theme?.brightness, Brightness.dark);
    expect(
      theme?.scaffoldBackgroundColor,
      RepForgeColorTokens.backgroundPrimary,
    );
    expect(theme?.colorScheme.primary, RepForgeColorTokens.accentPrimaryGreen);
    expect(metricColors?.volume, RepForgeColorTokens.metricVolumeBlue);
  });

  testWidgets('app disposal and explicit dependency close are idempotent', (
    tester,
  ) async {
    final dependencies = _testAppDependencies();

    await tester.pumpWidget(RepForgeApp(dependencies: dependencies));
    await tester.pumpWidget(const SizedBox.shrink());
    await dependencies.close();
  });

  testWidgets('AppCard renders themed card styling', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: RepForgeTheme.dark(),
        home: const Scaffold(body: AppCard(child: Text('Card content'))),
      ),
    );

    expect(find.byType(AppCard), findsOneWidget);
    expect(find.text('Card content'), findsOneWidget);

    final decoratedBox = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(AppCard),
        matching: find.byType(DecoratedBox),
      ),
    );
    final decoration = decoratedBox.decoration as BoxDecoration;

    expect(decoration.color, RepForgeColorTokens.surfaceCard);
    expect(decoration.borderRadius, BorderRadius.circular(RepForgeRadius.lg));
  });
}

AppDependencies _testAppDependencies({
  AppConfiguration configuration = const AppConfiguration(),
}) {
  return AppDependencies(
    configuration: configuration,
    workoutSetRepository: _FakeWorkoutSetRepository(),
  );
}

final class _FakeWorkoutSetRepository implements WorkoutSetRepository {
  @override
  Future<void> deleteById(WorkoutSetId id) {
    throw UnimplementedError('Widget smoke tests do not delete workout sets.');
  }

  @override
  Future<WorkoutSet?> findById(WorkoutSetId id) {
    throw UnimplementedError('Widget smoke tests do not read workout sets.');
  }

  @override
  Future<List<WorkoutSet>> historyForExercise(ExerciseRef exerciseRef) {
    throw UnimplementedError('Widget smoke tests do not read workout sets.');
  }

  @override
  Future<WorkoutSetTimelinePage> timelineForExercise(
    WorkoutSetTimelineQuery query,
  ) {
    throw UnimplementedError('Widget smoke tests do not read workout sets.');
  }

  @override
  Future<void> save(WorkoutSet set) {
    throw UnimplementedError('Widget smoke tests do not write workout sets.');
  }

  @override
  Future<List<WorkoutSet>> setsForWorkoutSession(
    WorkoutSessionId workoutSessionId,
  ) {
    throw UnimplementedError('Widget smoke tests do not read workout sets.');
  }
}
