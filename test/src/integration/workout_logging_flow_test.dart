import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/app/localization/app_localizations.dart';
import 'package:repforge/src/core/theme/theme.dart';
import 'package:repforge/src/features/analytics/application/analytics_application.dart';
import 'package:repforge/src/features/analytics/presentation/analytics_presentation.dart';
import 'package:repforge/src/features/exercise_catalog/data/importers/official_exercise_catalog_importer.dart';
import 'package:repforge/src/features/exercise_catalog/data/parsers/official_exercise_catalog_parser.dart';
import 'package:repforge/src/features/exercise_catalog/data/repositories/drift_exercise_catalog_repository.dart';
import 'package:repforge/src/features/exercise_catalog/domain/exercise_catalog_domain.dart';
import 'package:repforge/src/features/recovery/domain/recovery_domain.dart';
import 'package:repforge/src/features/rest_timer/application/rest_timer_application.dart';
import 'package:repforge/src/features/rest_timer/domain/rest_timer_domain.dart';
import 'package:repforge/src/features/rest_timer/presentation/rest_timer_presentation.dart';
import 'package:repforge/src/features/today/presentation/today_presentation.dart';
import 'package:repforge/src/features/training_log/application/training_log_application.dart';
import 'package:repforge/src/features/training_log/data/repositories/drift_workout_set_repository.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';
import 'package:repforge/src/shared/data/local/repforge_database.dart';

void main() {
  testWidgets(
    'logs and edits a set, then updates history, today, analytics, and timer',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1200, 1000);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      final environment = await _WorkoutLoggingFlowEnvironment.create();
      addTearDown(environment.close);

      await tester.pumpWidget(
        _testApp(_WorkoutLoggingFlowHarness(environment)),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('exercise_search_field')),
        'bench',
      );
      await tester.tap(find.byKey(const Key('exercise_search_button')));
      await tester.pumpAndSettle();

      expect(find.text('Barbell Bench Press'), findsOneWidget);

      await tester.tap(
        find.byKey(const Key('exercise_result_barbell_bench_press')),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('load_kg_field')), '100');
      await tester.enterText(find.byKey(const Key('repetitions_field')), '5');
      await tester.enterText(find.byKey(const Key('comment_field')), 'Top set');
      await tester.enterText(find.byKey(const Key('label_field')), 'warmup');
      await tester.tap(find.byKey(const Key('log_set_button')));
      await tester.pumpAndSettle();

      expect(
        find.text('Logged set: Barbell Bench Press, 5 reps at 100 kg'),
        findsOneWidget,
      );
      expect(environment.notificationGateway.scheduledRequests, hasLength(1));
      expect(
        environment.notificationGateway.scheduledRequests.single.targetAt,
        DateTime.utc(2026, 6, 1, 9, 1, 30),
      );

      await tester.enterText(find.byKey(const Key('load_kg_field')), '102.5');
      await tester.enterText(find.byKey(const Key('repetitions_field')), '6');
      await tester.enterText(find.byKey(const Key('comment_field')), 'Smooth');
      await tester.enterText(find.byKey(const Key('label_field')), 'failure');
      await tester.tap(find.byKey(const Key('edit_set_button')));
      await tester.pumpAndSettle();

      expect(
        find.text('Edited set: Barbell Bench Press, 6 reps at 102.5 kg'),
        findsOneWidget,
      );

      final persisted = await environment.workoutSetRepository.findById(
        WorkoutSetId('flow-set-1'),
      );
      expect(persisted, isNotNull);
      expect(persisted!.repetitions, Repetitions(6));
      expect(persisted.load, LoadKg(102.5));
      expect(persisted.comment, SetComment('Smooth'));
      expect(persisted.label, WorkoutSetLabel.failure);

      final todayModel = await _RepositoryTodayDashboardLoader(
        workoutSetRepository: environment.workoutSetRepository,
        restTimerNotifications: environment.restTimerNotifications,
      ).load();
      expect(todayModel.setCount, 1);
      expect(todayModel.totalVolumeKg, 615);
      expect(todayModel.lastLoggedSet?.exerciseName, 'Barbell Bench Press');

      await tester.tap(find.byKey(const Key('flow_tab_history')));
      await tester.pumpAndSettle();

      expect(find.text('History search: bench'), findsOneWidget);
      expect(
        find.text('Barbell Bench Press, 6 reps at 102.5 kg - Smooth - failure'),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('flow_tab_today')));
      await tester.pumpAndSettle();

      expect(find.text('Sets today'), findsOneWidget);
      expect(find.text('Volume today'), findsOneWidget);
      expect(
        find.text('Barbell Bench Press: 6 reps at 102.5 kg'),
        findsOneWidget,
      );
      expect(find.text('Resting'), findsOneWidget);
      expect(find.text('01:30'), findsOneWidget);

      await tester.tap(find.byKey(const Key('flow_tab_analytics')));
      await tester.pumpAndSettle();

      expect(find.text('Summary'), findsOneWidget);
      expect(find.text('Sets'), findsWidgets);
      expect(find.text('Volume'), findsWidgets);
      expect(find.text('615 kg'), findsWidgets);
      expect(find.text('123 kg'), findsWidgets);
    },
  );
}

Widget _testApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: RepForgeTheme.dark(),
    home: child,
  );
}

final class _WorkoutLoggingFlowEnvironment {
  _WorkoutLoggingFlowEnvironment({
    required this.database,
    required this.exerciseCatalogRepository,
    required this.workoutSetRepository,
    required this.restTimerNotifications,
    required this.notificationGateway,
    required this.saveWorkoutSet,
    required this.updateWorkoutSet,
    required this.getExerciseAnalytics,
  });

  final RepForgeDatabase database;
  final DriftExerciseCatalogRepository exerciseCatalogRepository;
  final DriftWorkoutSetRepository workoutSetRepository;
  final RestTimerNotificationCoordinator restTimerNotifications;
  final _FakeRestTimerNotificationGateway notificationGateway;
  final SaveWorkoutSet saveWorkoutSet;
  final UpdateWorkoutSet updateWorkoutSet;
  final GetExerciseAnalytics getExerciseAnalytics;

  static Future<_WorkoutLoggingFlowEnvironment> create() async {
    final database = RepForgeDatabase(NativeDatabase.memory());
    final catalog = const OfficialExerciseCatalogParser().parseString(
      File('assets/catalog/official_exercises_v1.json').readAsStringSync(),
    );
    await OfficialExerciseCatalogImporter(database).importCatalog(catalog);

    final workoutSetRepository = DriftWorkoutSetRepository(database);
    final notificationGateway = _FakeRestTimerNotificationGateway();
    final restTimerNotifications = RestTimerNotificationCoordinator(
      timerController: RestTimerController(
        timeProvider: _FixedTimeProvider(DateTime.utc(2026, 6, 1, 9)),
      ),
      notificationGateway: notificationGateway,
    );

    return _WorkoutLoggingFlowEnvironment(
      database: database,
      exerciseCatalogRepository: DriftExerciseCatalogRepository(database),
      workoutSetRepository: workoutSetRepository,
      restTimerNotifications: restTimerNotifications,
      notificationGateway: notificationGateway,
      saveWorkoutSet: SaveWorkoutSet(workoutSetRepository),
      updateWorkoutSet: UpdateWorkoutSet(workoutSetRepository),
      getExerciseAnalytics: GetExerciseAnalytics(workoutSetRepository),
    );
  }

  Future<void> close() async {
    await database.close();
  }
}

class _WorkoutLoggingFlowHarness extends StatefulWidget {
  const _WorkoutLoggingFlowHarness(this.environment);

  final _WorkoutLoggingFlowEnvironment environment;

  @override
  State<_WorkoutLoggingFlowHarness> createState() =>
      _WorkoutLoggingFlowHarnessState();
}

class _WorkoutLoggingFlowHarnessState
    extends State<_WorkoutLoggingFlowHarness> {
  static final DateTime _loggedAt = DateTime.utc(2026, 6, 1, 9);

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _loadController = TextEditingController();
  final TextEditingController _repetitionsController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _labelController = TextEditingController();

  var _selectedTab = 0;
  var _dataVersion = 0;
  var _matches = const <OfficialExercise>[];
  var _history = const <WorkoutSet>[];
  OfficialExercise? _selectedExercise;
  WorkoutSet? _lastSavedSet;
  String? _statusMessage;

  @override
  void dispose() {
    _searchController.dispose();
    _loadController.dispose();
    _repetitionsController.dispose();
    _commentController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _tabButton(key: 'flow_tab_log', label: 'Log', index: 0),
                  _tabButton(
                    key: 'flow_tab_history',
                    label: 'History',
                    index: 1,
                  ),
                  _tabButton(key: 'flow_tab_today', label: 'Today', index: 2),
                  _tabButton(
                    key: 'flow_tab_analytics',
                    label: 'Analytics',
                    index: 3,
                  ),
                ],
              ),
            ),
            Expanded(child: _body()),
          ],
        ),
      ),
    );
  }

  Widget _tabButton({
    required String key,
    required String label,
    required int index,
  }) {
    return FilledButton(
      key: Key(key),
      onPressed: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Text(label),
    );
  }

  Widget _body() {
    final selectedExerciseRef = _selectedExerciseRef();

    return switch (_selectedTab) {
      0 => _LogSetPane(
        searchController: _searchController,
        loadController: _loadController,
        repetitionsController: _repetitionsController,
        commentController: _commentController,
        labelController: _labelController,
        matches: _matches,
        selectedExercise: _selectedExercise,
        lastSavedSet: _lastSavedSet,
        statusMessage: _statusMessage,
        onSearch: _searchExercises,
        onSelectExercise: _selectExercise,
        onLogSet: _logSet,
        onEditSet: _editSet,
      ),
      1 => _HistoryPane(history: _history),
      2 => TodayPage(
        key: ValueKey<String>('today-$_dataVersion'),
        loader: _RepositoryTodayDashboardLoader(
          workoutSetRepository: widget.environment.workoutSetRepository,
          restTimerNotifications: widget.environment.restTimerNotifications,
        ),
      ),
      3 => AnalyticsPage(
        key: ValueKey<String>('analytics-$_dataVersion'),
        loader: UseCaseExerciseAnalyticsLoader(
          getExerciseAnalytics: widget.environment.getExerciseAnalytics,
          exerciseRef:
              selectedExerciseRef ??
              ExerciseRef.official(
                id: OfficialExerciseId('barbell_bench_press'),
                displayNameSnapshot: 'Barbell Bench Press',
                catalogVersionSnapshot: '2026.05.0',
              ),
        ),
        nowProvider: () => DateTime.utc(2026, 6, 1, 12),
      ),
      _ => const SizedBox.shrink(),
    };
  }

  Future<void> _searchExercises() async {
    final page = await widget.environment.exerciseCatalogRepository
        .findOfficialExercises(
          ExerciseCatalogQuery(
            limit: 10,
            offset: 0,
            searchText: _searchController.text,
          ),
        );

    if (!mounted) {
      return;
    }

    setState(() {
      _matches = page.items;
    });
  }

  void _selectExercise(OfficialExercise exercise) {
    setState(() {
      _selectedExercise = exercise;
      _matches = const <OfficialExercise>[];
    });
  }

  Future<void> _logSet() async {
    final exerciseRef = _selectedExerciseRef();
    if (exerciseRef == null) {
      return;
    }

    final set = await widget.environment.saveWorkoutSet(
      WorkoutSetForm(
        targetExerciseRef: exerciseRef,
        loadKgInput: _loadController.text,
        repetitionsInput: _repetitionsController.text,
        performedAt: _loggedAt,
        commentInput: _commentController.text,
        labelInput: _labelController.text,
      ),
      workoutSetId: WorkoutSetId('flow-set-1'),
      workoutSessionId: WorkoutSessionId('flow-session-1'),
    );
    await widget.environment.restTimerNotifications.start(
      RestTimerDuration(const Duration(seconds: 90)),
      content: const RestTimerNotificationContent(
        title: 'Rest finished',
        body: 'Your rest timer is done.',
      ),
    );
    await _refreshAfterSave(set, prefix: 'Logged set');
  }

  Future<void> _editSet() async {
    final exerciseRef = _selectedExerciseRef();
    if (exerciseRef == null) {
      return;
    }

    final set = await widget.environment.updateWorkoutSet(
      WorkoutSetForm(
        existingWorkoutSetId: WorkoutSetId('flow-set-1'),
        targetExerciseRef: exerciseRef,
        loadKgInput: _loadController.text,
        repetitionsInput: _repetitionsController.text,
        performedAt: _loggedAt,
        commentInput: _commentController.text,
        labelInput: _labelController.text,
      ),
    );
    await _refreshAfterSave(set, prefix: 'Edited set');
  }

  Future<void> _refreshAfterSave(
    WorkoutSet set, {
    required String prefix,
  }) async {
    final history = await widget.environment.workoutSetRepository.searchHistory(
      WorkoutSetHistoryQuery(limit: 20, offset: 0, searchText: 'bench'),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _lastSavedSet = set;
      _history = history.items.toList(growable: false);
      _statusMessage = '$prefix: ${_setSummary(set)}';
      _dataVersion += 1;
    });
  }

  ExerciseRef? _selectedExerciseRef() {
    final exercise = _selectedExercise;
    if (exercise == null) {
      return null;
    }

    return ExerciseRef.official(
      id: exercise.id,
      displayNameSnapshot: exercise.englishName,
      catalogVersionSnapshot: exercise.catalogVersion.value,
    );
  }
}

class _LogSetPane extends StatelessWidget {
  const _LogSetPane({
    required this.searchController,
    required this.loadController,
    required this.repetitionsController,
    required this.commentController,
    required this.labelController,
    required this.matches,
    required this.selectedExercise,
    required this.lastSavedSet,
    required this.statusMessage,
    required this.onSearch,
    required this.onSelectExercise,
    required this.onLogSet,
    required this.onEditSet,
  });

  final TextEditingController searchController;
  final TextEditingController loadController;
  final TextEditingController repetitionsController;
  final TextEditingController commentController;
  final TextEditingController labelController;
  final List<OfficialExercise> matches;
  final OfficialExercise? selectedExercise;
  final WorkoutSet? lastSavedSet;
  final String? statusMessage;
  final VoidCallback onSearch;
  final ValueChanged<OfficialExercise> onSelectExercise;
  final VoidCallback onLogSet;
  final VoidCallback onEditSet;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          key: const Key('exercise_search_field'),
          controller: searchController,
          decoration: const InputDecoration(labelText: 'Exercise search'),
        ),
        const SizedBox(height: 8),
        FilledButton(
          key: const Key('exercise_search_button'),
          onPressed: onSearch,
          child: const Text('Search exercises'),
        ),
        for (final exercise in matches)
          TextButton(
            key: Key('exercise_result_${exercise.id.value}'),
            onPressed: () => onSelectExercise(exercise),
            child: Text(exercise.englishName),
          ),
        if (selectedExercise != null) ...[
          const SizedBox(height: 12),
          Text('Selected: ${selectedExercise!.englishName}'),
        ],
        const SizedBox(height: 12),
        TextField(
          key: const Key('load_kg_field'),
          controller: loadController,
          decoration: const InputDecoration(labelText: 'Load kg'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          key: const Key('repetitions_field'),
          controller: repetitionsController,
          decoration: const InputDecoration(labelText: 'Repetitions'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          key: const Key('comment_field'),
          controller: commentController,
          decoration: const InputDecoration(labelText: 'Comment'),
        ),
        TextField(
          key: const Key('label_field'),
          controller: labelController,
          decoration: const InputDecoration(labelText: 'Label'),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            FilledButton(
              key: const Key('log_set_button'),
              onPressed: selectedExercise == null ? null : onLogSet,
              child: const Text('Log set'),
            ),
            FilledButton.tonal(
              key: const Key('edit_set_button'),
              onPressed: lastSavedSet == null ? null : onEditSet,
              child: const Text('Edit set'),
            ),
          ],
        ),
        if (statusMessage != null) ...[
          const SizedBox(height: 12),
          Text(statusMessage!),
        ],
      ],
    );
  }
}

class _HistoryPane extends StatelessWidget {
  const _HistoryPane({required this.history});

  final List<WorkoutSet> history;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('History search: bench'),
        const SizedBox(height: 8),
        for (final set in history)
          Text(
            '${_setSummary(set)} - ${set.comment?.value ?? 'no comment'} - '
            '${set.label.storageValue}',
          ),
      ],
    );
  }
}

final class _RepositoryTodayDashboardLoader implements TodayDashboardLoader {
  const _RepositoryTodayDashboardLoader({
    required this.workoutSetRepository,
    required this.restTimerNotifications,
  });

  final DriftWorkoutSetRepository workoutSetRepository;
  final RestTimerNotificationCoordinator restTimerNotifications;

  @override
  Future<TodayDashboardReadModel> load() async {
    final page = await workoutSetRepository.searchHistory(
      WorkoutSetHistoryQuery(limit: 100, offset: 0),
    );
    final todaySets = page.items.toList(growable: false);
    final lastLoggedSet = todaySets.isEmpty ? null : todaySets.first;

    return TodayDashboardReadModel(
      setCount: todaySets.length,
      totalVolumeKg: todaySets.fold<double>(
        0,
        (total, set) => total + set.load.value * set.repetitions.value,
      ),
      lastLoggedSet: lastLoggedSet == null
          ? null
          : TodayLastLoggedSetViewModel(
              exerciseName: lastLoggedSet.exerciseRef.displayNameSnapshot,
              repetitions: lastLoggedSet.repetitions.value,
              loadKg: lastLoggedSet.load.value,
            ),
      restTimer: RestTimerCountdownState.fromSnapshot(
        restTimerNotifications.snapshot,
      ),
      readiness: ReadinessReadModel.empty(forDate: DateTime.utc(2026, 6)),
    );
  }
}

String _setSummary(WorkoutSet set) {
  return '${set.exerciseRef.displayNameSnapshot}, '
      '${set.repetitions.value} reps at '
      '${_formatNumber(set.load.value)} kg';
}

String _formatNumber(num value) {
  final formatted = value.toStringAsFixed(1);
  return formatted.replaceFirst(RegExp(r'\.0$'), '');
}

final class _FixedTimeProvider implements TimeProvider {
  const _FixedTimeProvider(this.nowValue);

  final DateTime nowValue;

  @override
  DateTime now() => nowValue;
}

final class _FakeRestTimerNotificationGateway
    implements RestTimerNotificationGateway {
  final List<RestTimerNotificationRequest> scheduledRequests =
      <RestTimerNotificationRequest>[];
  final List<int> cancelledNotificationIds = <int>[];

  @override
  Future<void> cancelRestTimer(int notificationId) async {
    cancelledNotificationIds.add(notificationId);
  }

  @override
  Future<RestTimerNotificationPermissionStatus> requestPermission() async {
    return RestTimerNotificationPermissionStatus.granted;
  }

  @override
  Future<void> scheduleRestTimerFinished(
    RestTimerNotificationRequest request,
  ) async {
    scheduledRequests.add(request);
  }
}
