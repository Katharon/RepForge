import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/app/localization/app_localizations.dart';
import 'package:repforge/src/core/theme/theme.dart';
import 'package:repforge/src/features/exercise_catalog/domain/exercise_catalog_domain.dart';
import 'package:repforge/src/features/training_log/application/training_log_application.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';
import 'package:repforge/src/features/training_log/presentation/training_log_presentation.dart';

void main() {
  testWidgets('quick log flow saves a set through SaveWorkoutSet', (
    tester,
  ) async {
    final repository = _FakeWorkoutSetRepository();
    final controller = QuickLogSetController(
      exerciseCatalogRepository: _FakeExerciseCatalogRepository(),
      saveWorkoutSet: SaveWorkoutSet(repository),
      workoutSetIdProvider: () => WorkoutSetId('quick-test-set'),
      nowProvider: () => DateTime.utc(2026, 6, 5, 9),
    );

    await tester.pumpWidget(
      _testApp(
        FilledButton(
          onPressed: () => controller.show(_capturedContext!),
          child: const Text('Open quick log'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open quick log'));
    await tester.pumpAndSettle();

    expect(find.text('Log set'), findsOneWidget);
    expect(find.text('Barbell Bench Press'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('quick_log_load_field')), '80');
    await tester.enterText(
      find.byKey(const Key('quick_log_repetitions_field')),
      '8',
    );
    await tester.enterText(
      find.byKey(const Key('quick_log_comment_field')),
      'Controlled',
    );
    await tester.tap(find.byKey(const Key('quick_log_save_button')));
    await tester.pumpAndSettle();

    expect(repository.savedSets, hasLength(1));
    final saved = repository.savedSets.single;
    expect(saved.id, WorkoutSetId('quick-test-set'));
    expect(saved.exerciseRef.id, 'barbell_bench_press');
    expect(saved.exerciseRef.displayNameSnapshot, 'Barbell Bench Press');
    expect(saved.exerciseRef.catalogVersionSnapshot, '2026.06.0');
    expect(saved.load, LoadKg(80));
    expect(saved.repetitions, Repetitions(8));
    expect(saved.comment, SetComment('Controlled'));
    expect(saved.workoutSessionId, isNull);
  });

  testWidgets('quick log strings are localized in German', (tester) async {
    final repository = _FakeWorkoutSetRepository();
    final controller = QuickLogSetController(
      exerciseCatalogRepository: _FakeExerciseCatalogRepository(),
      saveWorkoutSet: SaveWorkoutSet(repository),
      workoutSetIdProvider: () => WorkoutSetId('quick-test-set'),
    );

    await tester.pumpWidget(
      _testApp(
        FilledButton(
          onPressed: () => controller.show(_capturedContext!),
          child: const Text('Open quick log'),
        ),
        locale: const Locale('de'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open quick log'));
    await tester.pumpAndSettle();

    expect(find.text('Satz protokollieren'), findsOneWidget);
    expect(find.text('Bankdruecken mit Langhantel'), findsOneWidget);
    expect(find.text('Gewicht (kg)'), findsOneWidget);
  });

  testWidgets('quick log can preselect the current exercise ref', (
    tester,
  ) async {
    final repository = _FakeWorkoutSetRepository();
    final controller = QuickLogSetController(
      exerciseCatalogRepository: _FakeExerciseCatalogRepository(),
      saveWorkoutSet: SaveWorkoutSet(repository),
      workoutSetIdProvider: () => WorkoutSetId('quick-preselected-set'),
      nowProvider: () => DateTime.utc(2026, 6, 5, 10),
    );
    final initialRef = ExerciseRef.official(
      id: OfficialExerciseId('seated_cable_row'),
      displayNameSnapshot: 'Seated Cable Row',
      catalogVersionSnapshot: '2026.06.0',
    );

    await tester.pumpWidget(
      _testApp(
        FilledButton(
          onPressed: () => controller.show(_capturedContext!, initialRef),
          child: const Text('Open quick log'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open quick log'));
    await tester.pumpAndSettle();

    expect(find.text('Seated Cable Row'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('quick_log_load_field')), '55');
    await tester.enterText(
      find.byKey(const Key('quick_log_repetitions_field')),
      '10',
    );
    await tester.tap(find.byKey(const Key('quick_log_save_button')));
    await tester.pumpAndSettle();

    expect(repository.savedSets.single.exerciseRef.id, 'seated_cable_row');
  });

  testWidgets('quick log attaches saved sets to the active workout session', (
    tester,
  ) async {
    final repository = _FakeWorkoutSetRepository();
    final workoutSessionController = WorkoutSessionController(
      workoutSetRepository: repository,
      workoutSessionIdProvider: () => WorkoutSessionId('active-session'),
      nowProvider: () => DateTime.utc(2026, 6, 5, 11),
    );
    await workoutSessionController.start(
      sourceName: 'Push',
      exerciseRefs: [
        ExerciseRef.official(
          id: OfficialExerciseId('barbell_bench_press'),
          displayNameSnapshot: 'Barbell Bench Press',
          catalogVersionSnapshot: '2026.06.0',
        ),
      ],
    );
    final controller = QuickLogSetController(
      exerciseCatalogRepository: _FakeExerciseCatalogRepository(),
      saveWorkoutSet: SaveWorkoutSet(repository),
      workoutSessionController: workoutSessionController,
      workoutSetIdProvider: () => WorkoutSetId('quick-session-set'),
      nowProvider: () => DateTime.utc(2026, 6, 5, 11, 10),
    );

    await tester.pumpWidget(
      _testApp(
        FilledButton(
          onPressed: () => controller.show(_capturedContext!),
          child: const Text('Open quick log'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open quick log'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('quick_log_load_field')), '90');
    await tester.enterText(
      find.byKey(const Key('quick_log_repetitions_field')),
      '6',
    );
    await tester.tap(find.byKey(const Key('quick_log_save_button')));
    await tester.pumpAndSettle();

    final saved = repository.savedSets.single;
    expect(saved.workoutSessionId, WorkoutSessionId('active-session'));
    expect(workoutSessionController.snapshot.activeSummary?.setCount, 1);
    expect(workoutSessionController.snapshot.activeSummary?.totalVolumeKg, 540);

    await workoutSessionController.dispose();
  });
}

BuildContext? _capturedContext;

Widget _testApp(Widget child, {Locale? locale}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: RepForgeTheme.dark(),
    home: Builder(
      builder: (context) {
        _capturedContext = context;
        return Scaffold(body: Center(child: child));
      },
    ),
  );
}

final class _FakeExerciseCatalogRepository
    implements ExerciseCatalogRepository {
  @override
  Future<OfficialExercise?> findOfficialExerciseById(
    OfficialExerciseId id,
  ) async {
    if (id == OfficialExerciseId('seated_cable_row')) {
      return OfficialExercise(
        id: OfficialExerciseId('seated_cable_row'),
        catalogVersion: CatalogVersion('2026.06.0'),
        englishName: 'Seated Cable Row',
        germanName: 'Kabelrudern sitzend',
        equipment: [EquipmentTag('cable_machine')],
        movementPatterns: [MovementPattern('horizontal_pull')],
        primaryMuscles: [MuscleGroup('lats')],
      );
    }
    return null;
  }

  @override
  Future<ExerciseCatalogPage> findOfficialExercises(
    ExerciseCatalogQuery query,
  ) async {
    final items = [
      OfficialExercise(
        id: OfficialExerciseId('barbell_bench_press'),
        catalogVersion: CatalogVersion('2026.06.0'),
        englishName: 'Barbell Bench Press',
        germanName: 'Bankdruecken mit Langhantel',
        equipment: [EquipmentTag('barbell')],
        movementPatterns: [MovementPattern('horizontal_push')],
        primaryMuscles: [MuscleGroup('chest')],
      ),
    ];
    return ExerciseCatalogPage(
      items: items,
      totalCount: items.length,
      limit: query.limit,
      offset: query.offset,
    );
  }
}

final class _FakeWorkoutSetRepository implements WorkoutSetRepository {
  final List<WorkoutSet> savedSets = [];

  @override
  Future<void> save(WorkoutSet set) async {
    savedSets.add(set);
  }

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
    return savedSets
        .where((set) => set.workoutSessionId == workoutSessionId)
        .toList(growable: false);
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
