import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:repforge/src/app/composition_root.dart';
import 'package:repforge/src/app/navigation/app_route.dart';
import 'package:repforge/src/app/repforge_app.dart';
import 'package:repforge/src/core/theme/theme.dart';
import 'package:repforge/src/core/widgets/widgets.dart';
import 'package:repforge/src/features/analytics/application/analytics_application.dart';
import 'package:repforge/src/features/auth/application/auth_application.dart';
import 'package:repforge/src/features/backup/application/backup_application.dart';
import 'package:repforge/src/features/backup/domain/backup_domain.dart';
import 'package:repforge/src/features/cloud/application/cloud_application.dart';
import 'package:repforge/src/features/entitlements/application/entitlements_application.dart';
import 'package:repforge/src/features/exercise_catalog/domain/exercise_catalog_domain.dart';
import 'package:repforge/src/features/notifications/application/notifications_application.dart';
import 'package:repforge/src/features/onboarding/application/onboarding_application.dart';
import 'package:repforge/src/features/onboarding/domain/onboarding_domain.dart';
import 'package:repforge/src/features/purchases/application/purchases_application.dart';
import 'package:repforge/src/features/purchases/domain/purchases_domain.dart';
import 'package:repforge/src/features/recovery/application/recovery_application.dart';
import 'package:repforge/src/features/recovery/domain/recovery_domain.dart';
import 'package:repforge/src/features/rest_timer/application/rest_timer_application.dart';
import 'package:repforge/src/features/rest_timer/domain/rest_timer_domain.dart';
import 'package:repforge/src/features/settings/application/settings_application.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';
import 'package:repforge/src/features/training_log/application/training_log_application.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';
import 'package:repforge/src/features/workout_groups/domain/workout_groups_domain.dart';

import 'src/features/purchases/fakes/fake_purchase_gateway.dart';

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
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsWidgets);
    expect(find.text('Train'), findsWidgets);
    expect(find.text('Exercises'), findsWidgets);
    expect(find.text('Analytics'), findsWidgets);
    expect(find.text('Settings'), findsWidgets);
    expect(find.text('No sets logged today'), findsOneWidget);
    expect(find.byType(AppCard), findsWidgets);
  });

  testWidgets('main navigation exposes semantic destination labels', (
    tester,
  ) async {
    final dependencies = _testAppDependencies();

    await tester.pumpWidget(RepForgeApp(dependencies: dependencies));
    await tester.pumpAndSettle();

    final iconLabels = tester
        .widgetList<Icon>(find.byType(Icon))
        .map((icon) => icon.semanticLabel)
        .whereType<String>()
        .toSet();

    expect(
      iconLabels,
      containsAll(['Today', 'Train', 'Exercises', 'Analytics', 'Settings']),
    );
  });

  testWidgets('Today surface stays constrained on a wide layout', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final dependencies = _testAppDependencies();

    await tester.pumpWidget(RepForgeApp(dependencies: dependencies));
    await tester.pumpAndSettle();

    final cardSize = tester.getSize(find.byType(AppCard).first);
    expect(cardSize.width, lessThanOrEqualTo(720));
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders German navigation labels with forced German locale', (
    tester,
  ) async {
    final dependencies = _testAppDependencies(
      configuration: AppConfiguration(locale: Locale('de')),
    );

    await tester.pumpWidget(RepForgeApp(dependencies: dependencies));
    await tester.pumpAndSettle();

    expect(find.text('Heute'), findsWidgets);
    expect(find.text('Training'), findsWidgets);
    expect(find.text('Uebungen'), findsWidgets);
    expect(find.text('Analyse'), findsWidgets);
    expect(find.text('Einstellungen'), findsWidgets);
    expect(find.text('Heute noch keine Saetze'), findsOneWidget);
  });

  testWidgets('tapping each destination shows the wired destination state', (
    tester,
  ) async {
    final dependencies = _testAppDependencies();

    await tester.pumpWidget(RepForgeApp(dependencies: dependencies));

    const destinations = <String, String>{
      'Train': 'My Exercises',
      'Exercises': 'Search exercises',
      'Analytics': 'No sets in this range',
      'Settings': 'Using local defaults',
      'Today': 'No sets logged today',
    };

    for (final entry in destinations.entries) {
      await tester.tap(find.text(entry.key).last);
      await tester.pumpAndSettle();

      expect(find.text(entry.value), findsOneWidget);
    }
  });

  testWidgets('tapping an exercise in Train opens Exercise Detail', (
    tester,
  ) async {
    final dependencies = _testAppDependencies();

    await tester.pumpWidget(RepForgeApp(dependencies: dependencies));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Train').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('My Exercises'));
    await tester.pumpAndSettle();
    await tester.drag(
      find.byType(CustomScrollView).first,
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Barbell Bench Press').first);
    await tester.pumpAndSettle();

    expect(find.text('No set history yet'), findsOneWidget);
    expect(find.text('Compared to previous'), findsOneWidget);

    await tester.tap(find.text('Open chart trends for this exercise.'));
    await tester.pumpAndSettle();

    expect(find.text('Exercise chart'), findsWidgets);
    expect(find.text('No chart data yet'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open the estimated 1RM chart.'));
    await tester.pumpAndSettle();

    expect(find.text('Exercise chart'), findsWidgets);
    expect(find.text('Estimated 1RM unavailable'), findsOneWidget);
  });

  testWidgets('tapping an exercise in Exercises opens Exercise Detail', (
    tester,
  ) async {
    final dependencies = _testAppDependencies();

    await tester.pumpWidget(RepForgeApp(dependencies: dependencies));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Exercises').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Barbell Bench Press').first);
    await tester.pumpAndSettle();

    expect(find.text('No set history yet'), findsOneWidget);
    expect(find.text('Analytics'), findsWidgets);
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
  final workoutSetRepository = _FakeWorkoutSetRepository();
  final exerciseCatalogRepository = _FakeExerciseCatalogRepository();
  final settingsProfileRepository = _FakeSettingsProfileRepository();
  final onboardingStatusRepository = _FakeOnboardingStatusRepository();
  final workoutGroupRepository = _FakeWorkoutGroupRepository();
  final backupRepository = _FakeBackupRepository();
  final readinessCheckInRepository = _FakeReadinessCheckInRepository();
  final authGateway = LocalOnlyAuthGateway();
  final firebaseInitializationGateway =
      UnavailableFirebaseInitializationGateway();
  final remotePushGateway = UnavailableRemotePushGateway();
  final entitlementSnapshotSource = LocalFreeEntitlementSnapshotSource();
  final purchaseGateway = FakePurchaseGateway(
    products: const <PurchaseProduct>[],
    now: DateTime.now,
  );
  final purchaseVerificationSource = UnavailablePurchaseVerificationSource();
  final loadSettingsProfile = LoadSettingsProfile(settingsProfileRepository);
  final saveSettingsProfile = SaveSettingsProfile(settingsProfileRepository);
  final getTodayReadiness = GetTodayReadiness(
    repository: readinessCheckInRepository,
  );

  return AppDependencies(
    configuration: configuration,
    restTimerNotifications: RestTimerNotificationCoordinator(
      timerController: RestTimerController(
        timeProvider: const SystemTimeProvider(),
      ),
      notificationGateway: _FakeRestTimerNotificationGateway(),
    ),
    workoutSetRepository: workoutSetRepository,
    saveWorkoutSet: SaveWorkoutSet(workoutSetRepository),
    deleteWorkoutSet: DeleteWorkoutSet(workoutSetRepository),
    workoutSessionController: WorkoutSessionController(
      workoutSetRepository: workoutSetRepository,
    ),
    getExerciseAnalytics: GetExerciseAnalytics(workoutSetRepository),
    getMuscleLoadDashboard: GetMuscleLoadDashboard(
      workoutSetRepository: workoutSetRepository,
      exerciseCatalogRepository: exerciseCatalogRepository,
      loadSettingsProfile: loadSettingsProfile,
      getTodayReadiness: getTodayReadiness,
    ),
    exerciseCatalogRepository: exerciseCatalogRepository,
    customExerciseRepository: _FakeCustomExerciseRepository(),
    ensureOfficialCatalogImported: () async {},
    settingsProfileRepository: settingsProfileRepository,
    loadSettingsProfile: loadSettingsProfile,
    saveSettingsProfile: saveSettingsProfile,
    resetSettingsProfile: ResetSettingsProfile(settingsProfileRepository),
    workoutGroupRepository: workoutGroupRepository,
    onboardingStatusRepository: onboardingStatusRepository,
    loadOnboardingStatus: LoadOnboardingStatus(onboardingStatusRepository),
    skipOnboarding: SkipOnboarding(onboardingStatusRepository),
    completeOnboarding: CompleteOnboarding(
      loadSettingsProfile: loadSettingsProfile,
      saveSettingsProfile: saveSettingsProfile,
      onboardingStatusRepository: onboardingStatusRepository,
      createStarterGroups: CreateStarterGroups(workoutGroupRepository),
      starterTemplateLoader: _FakeStarterTemplateLoader(),
    ),
    localBackupRepository: backupRepository,
    exportLocalBackup: ExportLocalBackup(backupRepository),
    validateLocalBackup: const ValidateLocalBackup(),
    importLocalBackup: ImportLocalBackup(backupRepository),
    readinessCheckInRepository: readinessCheckInRepository,
    saveReadinessCheckIn: SaveReadinessCheckIn(readinessCheckInRepository),
    getLatestReadiness: GetLatestReadiness(readinessCheckInRepository),
    getTodayReadiness: getTodayReadiness,
    authGateway: authGateway,
    getAuthStatus: GetAuthStatus(authGateway),
    signOut: SignOut(authGateway),
    authSessionPolicy: const AuthSessionPolicy(),
    firebaseInitializationGateway: firebaseInitializationGateway,
    initializeFirebaseIntegration: InitializeFirebaseIntegration(
      firebaseInitializationGateway,
    ),
    remotePushGateway: remotePushGateway,
    registerRemotePush: RegisterRemotePush(remotePushGateway),
    entitlementSnapshotSource: entitlementSnapshotSource,
    getFeatureGateDecision: GetFeatureGateDecision(entitlementSnapshotSource),
    purchaseGateway: purchaseGateway,
    loadPurchaseProducts: LoadPurchaseProducts(purchaseGateway),
    startPurchase: StartPurchase(purchaseGateway),
    restorePurchases: RestorePurchases(purchaseGateway),
    purchaseEntitlementMapper: const PurchaseEntitlementMapper(),
    purchaseVerificationSource: purchaseVerificationSource,
    verifyPurchaseEntitlement: VerifyPurchaseEntitlement(
      purchaseVerificationSource,
    ),
    entitlementCachePolicy: const EntitlementCachePolicy(),
  );
}

final class _FakeExerciseCatalogRepository
    implements ExerciseCatalogRepository {
  @override
  Future<OfficialExercise?> findOfficialExerciseById(
    OfficialExerciseId id,
  ) async {
    if (id != OfficialExerciseId('barbell_bench_press')) {
      return null;
    }
    return _benchPressExercise();
  }

  @override
  Future<ExerciseCatalogPage> findOfficialExercises(
    ExerciseCatalogQuery query,
  ) {
    final exercise = _benchPressExercise();
    return Future.value(
      ExerciseCatalogPage(
        items: [exercise],
        totalCount: 1,
        limit: query.limit,
        offset: query.offset,
      ),
    );
  }

  OfficialExercise _benchPressExercise() {
    return OfficialExercise(
      id: OfficialExerciseId('barbell_bench_press'),
      catalogVersion: CatalogVersion('2026.06.0'),
      englishName: 'Barbell Bench Press',
      germanName: 'Bankdruecken mit Langhantel',
      equipment: [EquipmentTag('barbell')],
      movementPatterns: [MovementPattern('horizontal_push')],
      primaryMuscles: [MuscleGroup('chest')],
    );
  }
}

final class _FakeCustomExerciseRepository implements CustomExerciseRepository {
  @override
  Future<void> saveCustomExercise(CustomExercise exercise) async {}

  @override
  Future<CustomExercise?> findCustomExerciseById(CustomExerciseId id) async {
    return null;
  }

  @override
  Future<CustomExercisePage> listCustomExercises(
    CustomExerciseQuery query,
  ) async {
    return CustomExercisePage(
      items: const [],
      totalCount: 0,
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

final class _FakeReadinessCheckInRepository
    implements ReadinessCheckInRepository {
  ReadinessCheckIn? latestCheckIn;

  @override
  Future<ReadinessCheckIn?> latest() async => latestCheckIn;

  @override
  Future<ReadinessCheckIn?> latestForRange({
    required DateTime startInclusive,
    required DateTime endExclusive,
  }) async {
    final checkIn = latestCheckIn;
    if (checkIn == null) {
      return null;
    }

    final checkedInAt = checkIn.checkedInAt;
    if (checkedInAt.isBefore(startInclusive.toUtc()) ||
        !checkedInAt.isBefore(endExclusive.toUtc())) {
      return null;
    }

    return checkIn;
  }

  @override
  Future<void> save(ReadinessCheckIn checkIn) async {
    latestCheckIn = checkIn;
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
  Future<WorkoutSetHistoryPage> searchHistory(WorkoutSetHistoryQuery query) {
    return Future.value(
      WorkoutSetHistoryPage(
        items: const [],
        totalCount: 0,
        limit: query.limit,
        offset: query.offset,
      ),
    );
  }

  @override
  Future<WorkoutSetDailySummary> dailySummary(
    WorkoutSetDailySummaryQuery query,
  ) {
    return Future.value(
      const WorkoutSetDailySummary(
        setCount: 0,
        totalVolumeKg: 0,
        lastLoggedSet: null,
      ),
    );
  }

  @override
  Future<WorkoutSetTimelinePage> timelineForExercise(
    WorkoutSetTimelineQuery query,
  ) {
    return Future.value(
      WorkoutSetTimelinePage(items: const [], hasMore: false, nextCursor: null),
    );
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

final class _FakeSettingsProfileRepository
    implements SettingsProfileRepository {
  SettingsProfile profile = SettingsProfile.defaults();

  @override
  Future<SettingsProfile> load() async => profile;

  @override
  Future<void> save(SettingsProfile profile) async {
    this.profile = profile;
  }
}

final class _FakeOnboardingStatusRepository
    implements OnboardingStatusRepository {
  OnboardingStatus status = OnboardingStatus(
    completion: OnboardingCompletion.completed,
    updatedAt: DateTime.utc(2026, 5, 28),
  );

  @override
  Future<OnboardingStatus> load() async => status;

  @override
  Future<void> save(OnboardingStatus status) async {
    this.status = status;
  }
}

final class _FakeStarterTemplateLoader implements StarterTemplateLoader {
  @override
  Future<StarterTemplateCatalog> load() async {
    return StarterTemplateCatalog(
      templateVersion: '2026.05.0',
      groups: [
        StarterGroupTemplate(
          id: 'full_body_a',
          name: 'Full Body A',
          exercises: const [
            StarterExerciseTemplate(
              catalogId: 'barbell_back_squat',
              displayNameSnapshot: 'Barbell Back Squat',
              catalogVersionSnapshot: '2026.05.0',
            ),
          ],
        ),
      ],
    );
  }
}

final class _FakeWorkoutGroupRepository implements WorkoutGroupRepository {
  @override
  Future<WorkoutGroup?> findGroupById(WorkoutGroupId id) async => null;

  @override
  Future<WorkoutGroupAssignmentPage> listAssignments(
    WorkoutGroupId groupId,
    WorkoutGroupAssignmentQuery query,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<WorkoutGroupPage> listGroups(WorkoutGroupQuery query) {
    return Future.value(
      WorkoutGroupPage(
        items: const [],
        totalCount: 0,
        limit: query.limit,
        offset: query.offset,
      ),
    );
  }

  @override
  Future<void> archiveGroup(WorkoutGroupId id, DateTime archivedAt) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeAssignment(WorkoutGroupExerciseAssignmentId id) {
    throw UnimplementedError();
  }

  @override
  Future<void> saveAssignment(
    WorkoutGroupExerciseAssignment assignment,
  ) async {}

  @override
  Future<void> saveGroup(WorkoutGroup group) async {}
}

final class _FakeBackupRepository implements LocalBackupRepository {
  RepForgeBackup backup = RepForgeBackup.create(
    exportedAt: DateTime.utc(2026, 5, 28),
  );

  @override
  Future<RepForgeBackup> exportBackup() async => backup;

  @override
  Future<void> importBackup(RepForgeBackup backup) async {
    this.backup = backup;
  }
}
