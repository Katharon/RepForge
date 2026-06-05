import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/app/localization/app_localizations.dart';
import 'package:repforge/src/core/theme/theme.dart';
import 'package:repforge/src/features/recovery/application/recovery_application.dart';
import 'package:repforge/src/features/recovery/domain/recovery_domain.dart';
import 'package:repforge/src/features/rest_timer/application/rest_timer_application.dart';
import 'package:repforge/src/features/rest_timer/domain/rest_timer_domain.dart';
import 'package:repforge/src/features/rest_timer/presentation/rest_timer_presentation.dart';
import 'package:repforge/src/features/today/presentation/today_presentation.dart';
import 'package:repforge/src/features/training_log/data/repositories/drift_workout_set_repository.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';
import 'package:repforge/src/shared/data/local/repforge_database.dart';

void main() {
  test('loader aggregates today from a bounded local summary query', () async {
    final database = RepForgeDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriftWorkoutSetRepository(database);
    await repository.save(
      _set(id: 'yesterday', performedAt: DateTime.utc(2026, 5, 31, 20)),
    );
    await repository.save(
      _set(id: 'today-a', performedAt: DateTime.utc(2026, 6, 1, 9)),
    );
    await repository.save(
      _set(
        id: 'today-b',
        repetitions: 10,
        loadKg: 40,
        performedAt: DateTime.utc(2026, 6, 1, 10),
      ),
    );

    final loader = RestTimerTodayDashboardLoader(
      restTimerNotifications: RestTimerNotificationCoordinator(
        timerController: RestTimerController(
          timeProvider: const SystemTimeProvider(),
        ),
        notificationGateway: _FakeRestTimerNotificationGateway(),
      ),
      workoutSetRepository: repository,
      getTodayReadiness: GetTodayReadiness(
        repository: _InMemoryReadinessCheckInRepository(),
        nowProvider: () => DateTime.utc(2026, 6, 1, 12),
      ),
      nowProvider: () => DateTime.utc(2026, 6, 1, 12),
    );

    final model = await loader.load();

    expect(model.setCount, 2);
    expect(model.totalVolumeKg, 900);
    expect(model.lastLoggedSet?.exerciseName, 'Barbell Bench Press');
    expect(model.lastLoggedSet?.repetitions, 10);
    expect(model.lastLoggedSet?.loadKg, 40);
  });

  testWidgets('loading state renders', (tester) async {
    await tester.pumpWidget(
      _testApp(TodayPage(loader: _PendingTodayDashboardLoader())),
    );

    expect(find.text('Loading today'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('empty state renders', (tester) async {
    await tester.pumpWidget(
      _testApp(TodayPage(loader: _StaticTodayDashboardLoader(_emptyModel()))),
    );
    await tester.pumpAndSettle();

    expect(find.text('No sets logged today'), findsOneWidget);
    expect(
      find.text('Your daily summary will fill in as soon as sets are logged.'),
      findsOneWidget,
    );
    expect(find.text('Sets today'), findsOneWidget);
    expect(find.text('Volume today'), findsOneWidget);
  });

  testWidgets('error state renders', (tester) async {
    await tester.pumpWidget(
      _testApp(TodayPage(loader: _FailingTodayDashboardLoader())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Today could not load'), findsOneWidget);
    expect(find.text('Try again without changing local data.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('success state renders dashboard cards', (tester) async {
    await tester.pumpWidget(
      _testApp(TodayPage(loader: _StaticTodayDashboardLoader(_successModel()))),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sets today'), findsOneWidget);
    expect(find.text('Volume today'), findsOneWidget);
    expect(find.text('Last logged'), findsOneWidget);
    expect(find.text('Rest timer'), findsOneWidget);
    expect(find.text('Quick action'), findsOneWidget);
    expect(find.text('Training signal'), findsOneWidget);
    expect(find.text('Readiness estimate'), findsOneWidget);
  });

  testWidgets('success state remains readable at increased text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        TodayPage(loader: _StaticTodayDashboardLoader(_successModel())),
        textScaler: const TextScaler.linear(2),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sets today'), findsOneWidget);
    expect(find.text('01:30'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('metrics and visible rest timer expose semantic summaries', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(TodayPage(loader: _StaticTodayDashboardLoader(_successModel()))),
    );
    await tester.pumpAndSettle();

    expect(_semanticsLabel('Sets today, 4'), findsOneWidget);
    expect(_semanticsLabel('Volume today, 1250 kg'), findsOneWidget);
    expect(
      _semanticsLabel(
        'Readiness estimate, Medium, 70 / 100. '
        'Estimate based on your latest local check-in.',
      ),
      findsOneWidget,
    );
    expect(_semanticsLabel('Rest timer, Resting, 01:30'), findsOneWidget);
  });

  testWidgets('readiness estimate card renders success state', (tester) async {
    await tester.pumpWidget(
      _testApp(TodayPage(loader: _StaticTodayDashboardLoader(_successModel()))),
    );
    await tester.pumpAndSettle();

    expect(find.text('Readiness estimate'), findsOneWidget);
    expect(find.text('Medium'), findsOneWidget);
    expect(find.text('70 / 100'), findsOneWidget);
    expect(
      find.text('Estimate based on your latest local check-in.'),
      findsOneWidget,
    );
  });

  testWidgets('readiness alone can make Today a success state', (tester) async {
    await tester.pumpWidget(
      _testApp(
        TodayPage(
          loader: _StaticTodayDashboardLoader(
            _emptyModel().copyWith(readiness: _readinessModel()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Readiness estimate'), findsOneWidget);
    expect(find.text('No sets logged today'), findsNothing);
    expect(find.text('Log set'), findsOneWidget);
  });

  testWidgets('today set count and volume are displayed', (tester) async {
    await tester.pumpWidget(
      _testApp(TodayPage(loader: _StaticTodayDashboardLoader(_successModel()))),
    );
    await tester.pumpAndSettle();

    expect(find.text('4'), findsOneWidget);
    expect(find.text('1250 kg'), findsOneWidget);
  });

  testWidgets('last logged set summary is displayed when available', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(TodayPage(loader: _StaticTodayDashboardLoader(_successModel()))),
    );
    await tester.pumpAndSettle();

    expect(find.text('Barbell Bench Press: 5 reps at 100 kg'), findsOneWidget);
  });

  testWidgets('rest timer status and countdown are displayed when available', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(TodayPage(loader: _StaticTodayDashboardLoader(_successModel()))),
    );
    await tester.pumpAndSettle();

    expect(find.text('Resting'), findsOneWidget);
    expect(find.text('01:30'), findsOneWidget);
  });

  testWidgets('quick action message is present', (tester) async {
    await tester.pumpWidget(
      _testApp(TodayPage(loader: _StaticTodayDashboardLoader(_successModel()))),
    );
    await tester.pumpAndSettle();

    expect(find.text('Log set'), findsOneWidget);
    expect(
      find.text(
        'Choose an exercise, enter load and reps, and save the set locally.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('quick action is enabled when logging flow is available', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    var callCount = 0;

    await tester.pumpWidget(
      _testApp(
        TodayPage(
          loader: _StaticTodayDashboardLoader(_successModel()),
          logSetAction: (_) async {
            callCount += 1;
            return false;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Log set'),
    );
    expect(button.onPressed, isNotNull);

    await tester.tap(find.text('Log set'));
    await tester.pumpAndSettle();

    expect(callCount, 1);
  });

  testWidgets('quick action refreshes Today after a saved set', (tester) async {
    final loader = _QueueTodayDashboardLoader([_emptyModel(), _successModel()]);

    await tester.pumpWidget(
      _testApp(TodayPage(loader: loader, logSetAction: (_) async => true)),
    );
    await tester.pumpAndSettle();

    expect(find.text('No sets logged today'), findsOneWidget);

    await tester.tap(find.text('Log set'));
    await tester.pumpAndSettle();

    expect(loader.loadCount, 2);
    expect(find.text('Barbell Bench Press: 5 reps at 100 kg'), findsOneWidget);
  });
}

Widget _testApp(Widget child, {TextScaler textScaler = TextScaler.noScaling}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: RepForgeTheme.dark(),
    home: MediaQuery(
      data: MediaQueryData(textScaler: textScaler),
      child: Scaffold(body: child),
    ),
  );
}

Finder _semanticsLabel(String label) {
  return find.byWidgetPredicate((widget) {
    return widget is Semantics && widget.properties.label == label;
  });
}

final class _PendingTodayDashboardLoader implements TodayDashboardLoader {
  @override
  Future<TodayDashboardReadModel> load() {
    return Completer<TodayDashboardReadModel>().future;
  }
}

final class _StaticTodayDashboardLoader implements TodayDashboardLoader {
  const _StaticTodayDashboardLoader(this.model);

  final TodayDashboardReadModel model;

  @override
  Future<TodayDashboardReadModel> load() {
    return Future.value(model);
  }
}

final class _QueueTodayDashboardLoader implements TodayDashboardLoader {
  _QueueTodayDashboardLoader(this.models);

  final List<TodayDashboardReadModel> models;
  var loadCount = 0;

  @override
  Future<TodayDashboardReadModel> load() async {
    final index = loadCount;
    loadCount += 1;
    return models[index.clamp(0, models.length - 1)];
  }
}

final class _FailingTodayDashboardLoader implements TodayDashboardLoader {
  @override
  Future<TodayDashboardReadModel> load() {
    return Future<TodayDashboardReadModel>.error(StateError('boom'));
  }
}

final class _FakeRestTimerNotificationGateway
    implements RestTimerNotificationGateway {
  @override
  Future<void> cancelRestTimer(int notificationId) async {}

  @override
  Future<RestTimerNotificationPermissionStatus> requestPermission() async {
    return RestTimerNotificationPermissionStatus.granted;
  }

  @override
  Future<void> scheduleRestTimerFinished(
    RestTimerNotificationRequest request,
  ) async {}
}

TodayDashboardReadModel _emptyModel() {
  return TodayDashboardReadModel(
    setCount: 0,
    totalVolumeKg: 0,
    restTimer: const RestTimerCountdownState(
      status: RestTimerStatus.idle,
      remaining: Duration.zero,
      displayText: '00:00',
      isVisible: false,
    ),
    readiness: ReadinessReadModel.empty(forDate: _today),
  );
}

TodayDashboardReadModel _successModel() {
  return TodayDashboardReadModel(
    setCount: 4,
    totalVolumeKg: 1250,
    lastLoggedSet: const TodayLastLoggedSetViewModel(
      exerciseName: 'Barbell Bench Press',
      repetitions: 5,
      loadKg: 100,
    ),
    restTimer: const RestTimerCountdownState(
      status: RestTimerStatus.running,
      remaining: Duration(seconds: 90),
      displayText: '01:30',
      isVisible: true,
    ),
    readiness: _readinessModel(),
  );
}

final _today = DateTime.utc(2026, 6);

extension on TodayDashboardReadModel {
  TodayDashboardReadModel copyWith({ReadinessReadModel? readiness}) {
    return TodayDashboardReadModel(
      setCount: setCount,
      totalVolumeKg: totalVolumeKg,
      lastLoggedSet: lastLoggedSet,
      restTimer: restTimer,
      readiness: readiness ?? this.readiness,
    );
  }
}

ReadinessReadModel _readinessModel() {
  final checkIn = ReadinessCheckIn(
    id: ReadinessCheckInId('today-readiness'),
    checkedInAt: DateTime.utc(2026, 6, 1, 8),
    soreness: SorenessRating.light(),
    sleepQuality: SleepQualityRating(4),
    energy: EnergyRating(3),
    stress: StressRating(3),
    motivation: MotivationRating(4),
  );
  const calculator = ReadinessScoreCalculator();
  final result = calculator.calculate(checkIn);
  return ReadinessReadModel(
    status: ReadinessReadModelStatus.available,
    forDate: _today,
    confidence: result.confidence,
    latestCheckIn: checkIn,
    score: result.score,
    level: result.level,
    reasons: result.reasons,
  );
}

WorkoutSet _set({
  required String id,
  required DateTime performedAt,
  int repetitions = 5,
  num loadKg = 100,
}) {
  return WorkoutSet(
    id: WorkoutSetId(id),
    exerciseRef: ExerciseRef.official(
      id: OfficialExerciseId('barbell-bench-press'),
      displayNameSnapshot: 'Barbell Bench Press',
      catalogVersionSnapshot: '2026.05.0',
    ),
    repetitions: Repetitions(repetitions),
    load: LoadKg(loadKg),
    performedAt: PerformedAt(performedAt),
  );
}

final class _InMemoryReadinessCheckInRepository
    implements ReadinessCheckInRepository {
  @override
  Future<ReadinessCheckIn?> latest() async => null;

  @override
  Future<ReadinessCheckIn?> latestForRange({
    required DateTime startInclusive,
    required DateTime endExclusive,
  }) async {
    return null;
  }

  @override
  Future<void> save(ReadinessCheckIn checkIn) async {}
}
