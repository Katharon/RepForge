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

  testWidgets('high repetitions trigger confirmation and can be cancelled', (
    tester,
  ) async {
    final repository = _FakeWorkoutSetRepository();
    final controller = QuickLogSetController(
      exerciseCatalogRepository: _FakeExerciseCatalogRepository(),
      saveWorkoutSet: SaveWorkoutSet(repository),
      workoutSetIdProvider: () => WorkoutSetId('quick-high-reps'),
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
    await tester.enterText(find.byKey(const Key('quick_log_load_field')), '40');
    await tester.enterText(
      find.byKey(const Key('quick_log_repetitions_field')),
      '101',
    );
    await tester.tap(find.byKey(const Key('quick_log_save_button')));
    await tester.pumpAndSettle();

    expect(find.text('Check logged values'), findsOneWidget);
    expect(find.text('Repetitions are unusually high.'), findsOneWidget);

    await tester.tap(
      find.byKey(const Key('quick_log_unusually_high_cancel_button')),
    );
    await tester.pumpAndSettle();

    expect(repository.savedSets, isEmpty);
    expect(find.text('Log set'), findsOneWidget);
  });

  testWidgets('high load and high set volume can be saved after confirmation', (
    tester,
  ) async {
    final repository = _FakeWorkoutSetRepository();
    final controller = QuickLogSetController(
      exerciseCatalogRepository: _FakeExerciseCatalogRepository(),
      saveWorkoutSet: SaveWorkoutSet(repository),
      workoutSetIdProvider: () => WorkoutSetId('quick-high-load-volume'),
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
    await tester.enterText(
      find.byKey(const Key('quick_log_load_field')),
      '501',
    );
    await tester.enterText(
      find.byKey(const Key('quick_log_repetitions_field')),
      '41',
    );
    await tester.tap(find.byKey(const Key('quick_log_save_button')));
    await tester.pumpAndSettle();

    expect(find.text('Load is unusually high.'), findsOneWidget);
    expect(find.text('Set volume is unusually high.'), findsOneWidget);

    await tester.tap(
      find.byKey(const Key('quick_log_unusually_high_confirm_button')),
    );
    await tester.pumpAndSettle();

    expect(repository.savedSets.single.id, WorkoutSetId('quick-high-load-volume'));
    expect(repository.savedSets.single.load, LoadKg(501));
    expect(repository.savedSets.single.repetitions, Repetitions(41));
  });

  testWidgets('malformed and invalid values remain blocked before warning', (
    tester,
  ) async {
    final repository = _FakeWorkoutSetRepository();
    final controller = QuickLogSetController(
      exerciseCatalogRepository: _FakeExerciseCatalogRepository(),
      saveWorkoutSet: SaveWorkoutSet(repository),
      workoutSetIdProvider: () => WorkoutSetId('quick-invalid'),
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
    await tester.enterText(find.byKey(const Key('quick_log_load_field')), '-1');
    await tester.enterText(
      find.byKey(const Key('quick_log_repetitions_field')),
      '0',
    );
    await tester.tap(find.byKey(const Key('quick_log_save_button')));
    await tester.pumpAndSettle();

    expect(find.text('Set could not be saved. Check the values.'), findsOneWidget);
    expect(find.text('Check logged values'), findsNothing);
    expect(repository.savedSets, isEmpty);
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

  testWidgets('quick log can save a custom exercise ref', (tester) async {
    final repository = _FakeWorkoutSetRepository();
    final controller = QuickLogSetController(
      exerciseCatalogRepository: _FakeExerciseCatalogRepository(),
      customExerciseRepository: _FakeCustomExerciseRepository(),
      saveWorkoutSet: SaveWorkoutSet(repository),
      workoutSetIdProvider: () => WorkoutSetId('quick-custom-set'),
      nowProvider: () => DateTime.utc(2026, 6, 5, 10, 30),
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
    await tester.tap(find.text('Cable Fly'));
    await tester.enterText(find.byKey(const Key('quick_log_load_field')), '30');
    await tester.enterText(
      find.byKey(const Key('quick_log_repetitions_field')),
      '12',
    );
    await tester.tap(find.byKey(const Key('quick_log_save_button')));
    await tester.pumpAndSettle();

    final saved = repository.savedSets.single;
    expect(saved.exerciseRef.source, ExerciseSource.custom);
    expect(saved.exerciseRef.id, 'custom_cable_fly');
    expect(saved.exerciseRef.displayNameSnapshot, 'Cable Fly');
    expect(saved.exerciseRef.catalogVersionSnapshot, isNull);
  });

  testWidgets('custom exercise logging uses the same guard path', (tester) async {
    final repository = _FakeWorkoutSetRepository();
    final controller = QuickLogSetController(
      exerciseCatalogRepository: _FakeExerciseCatalogRepository(),
      customExerciseRepository: _FakeCustomExerciseRepository(),
      saveWorkoutSet: SaveWorkoutSet(repository),
      workoutSetIdProvider: () => WorkoutSetId('quick-custom-guarded'),
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
    await tester.tap(find.text('Cable Fly'));
    await tester.enterText(
      find.byKey(const Key('quick_log_load_field')),
      '600',
    );
    await tester.enterText(
      find.byKey(const Key('quick_log_repetitions_field')),
      '1',
    );
    await tester.tap(find.byKey(const Key('quick_log_save_button')));
    await tester.pumpAndSettle();

    expect(find.text('Load is unusually high.'), findsOneWidget);

    await tester.tap(
      find.byKey(const Key('quick_log_unusually_high_confirm_button')),
    );
    await tester.pumpAndSettle();

    expect(repository.savedSets.single.exerciseRef.source, ExerciseSource.custom);
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

  testWidgets('active-session logging uses the same guard path', (tester) async {
    final repository = _FakeWorkoutSetRepository();
    final workoutSessionController = WorkoutSessionController(
      workoutSetRepository: repository,
      workoutSessionIdProvider: () => WorkoutSessionId('guarded-session'),
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
      workoutSetIdProvider: () => WorkoutSetId('quick-session-guarded'),
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
    await tester.enterText(find.byKey(const Key('quick_log_load_field')), '40');
    await tester.enterText(
      find.byKey(const Key('quick_log_repetitions_field')),
      '120',
    );
    await tester.tap(find.byKey(const Key('quick_log_save_button')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const Key('quick_log_unusually_high_confirm_button')),
    );
    await tester.pumpAndSettle();

    expect(repository.savedSets.single.workoutSessionId, WorkoutSessionId('guarded-session'));
    expect(workoutSessionController.snapshot.activeSummary?.setCount, 1);

    await workoutSessionController.dispose();
  });

  testWidgets('post-save snackbar exposes undo when delete is available', (
    tester,
  ) async {
    final repository = _FakeWorkoutSetRepository();
    final controller = QuickLogSetController(
      exerciseCatalogRepository: _FakeExerciseCatalogRepository(),
      saveWorkoutSet: SaveWorkoutSet(repository),
      deleteWorkoutSet: DeleteWorkoutSet(repository),
      workoutSetIdProvider: () => WorkoutSetId('quick-undo-set'),
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
    await tester.enterText(find.byKey(const Key('quick_log_load_field')), '80');
    await tester.enterText(
      find.byKey(const Key('quick_log_repetitions_field')),
      '8',
    );
    await tester.tap(find.byKey(const Key('quick_log_save_button')));
    await tester.pumpAndSettle();

    expect(find.text('Set saved.'), findsOneWidget);
    expect(find.text('Undo'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();

    expect(repository.deletedIds.single, WorkoutSetId('quick-undo-set'));
    expect(repository.savedSets, isEmpty);
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

final class _FakeCustomExerciseRepository implements CustomExerciseRepository {
  final custom = CustomExercise(
    id: CustomExerciseId('custom_cable_fly'),
    name: 'Cable Fly',
    primaryMuscles: [MuscleGroup('chest')],
    equipment: [EquipmentTag('cable')],
    movementPatterns: [MovementPattern('horizontal_push')],
    createdAt: DateTime.utc(2026, 6, 5),
    updatedAt: DateTime.utc(2026, 6, 5),
  );

  @override
  Future<void> saveCustomExercise(CustomExercise exercise) async {}

  @override
  Future<CustomExercise?> findCustomExerciseById(CustomExerciseId id) async {
    return id == custom.id ? custom : null;
  }

  @override
  Future<CustomExercisePage> listCustomExercises(
    CustomExerciseQuery query,
  ) async {
    final matches =
        query.searchText == null ||
        custom.name.toLowerCase().contains(query.searchText!.toLowerCase());
    final items = matches ? [custom] : const <CustomExercise>[];
    return CustomExercisePage(
      items: items,
      totalCount: items.length,
      limit: query.limit,
      offset: query.offset,
    );
  }

  @override
  Future<void> archiveCustomExercise(
    CustomExerciseId id,
    DateTime archivedAt,
  ) async {}
}

final class _FakeWorkoutSetRepository implements WorkoutSetRepository {
  final List<WorkoutSet> savedSets = [];
  final List<WorkoutSetId> deletedIds = [];

  @override
  Future<void> save(WorkoutSet set) async {
    savedSets.add(set);
  }

  @override
  Future<void> deleteById(WorkoutSetId id) async {
    deletedIds.add(id);
    savedSets.removeWhere((set) => set.id == id);
  }

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
