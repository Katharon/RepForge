import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/app/localization/app_localizations.dart';
import 'package:repforge/src/core/theme/theme.dart';
import 'package:repforge/src/core/widgets/widgets.dart';
import 'package:repforge/src/features/analytics/application/analytics_application.dart';
import 'package:repforge/src/features/analytics/domain/analytics_domain.dart';
import 'package:repforge/src/features/analytics/presentation/analytics_presentation.dart';
import 'package:repforge/src/features/onboarding/application/onboarding_application.dart';
import 'package:repforge/src/features/onboarding/domain/onboarding_domain.dart';
import 'package:repforge/src/features/onboarding/presentation/onboarding_presentation.dart';
import 'package:repforge/src/features/rest_timer/domain/rest_timer_domain.dart';
import 'package:repforge/src/features/rest_timer/presentation/rest_timer_presentation.dart';
import 'package:repforge/src/features/settings/application/settings_application.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';
import 'package:repforge/src/features/settings/presentation/settings_presentation.dart';
import 'package:repforge/src/features/today/presentation/today_presentation.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';
import 'package:repforge/src/features/workout_groups/domain/workout_groups_domain.dart';

void main() {
  testWidgets('core app card baseline', (tester) async {
    await _pumpGolden(
      tester,
      Center(
        child: SizedBox(
          width: 320,
          child: AppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Volume today',
                  style: RepForgeTheme.dark().textTheme.labelLarge?.copyWith(
                    color: RepForgeColorTokens.textSecondary,
                  ),
                ),
                const SizedBox(height: RepForgeSpacing.sm),
                Text(
                  '1250 kg',
                  style: RepForgeTheme.dark().textTheme.metricValue.copyWith(
                    color: RepForgeColorTokens.metricVolumeBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      surfaceSize: const Size(390, 240),
    );

    await expectLater(
      find.byKey(_goldenKey),
      matchesGoldenFile('goldens/core_app_card.png'),
    );
  });

  testWidgets('Today success baseline', (tester) async {
    await _pumpGolden(
      tester,
      TodayPage(loader: _StaticTodayDashboardLoader(_todaySuccessModel())),
    );

    await expectLater(
      find.byKey(_goldenKey),
      matchesGoldenFile('goldens/today_success.png'),
    );
  });

  testWidgets('Analytics success baseline', (tester) async {
    await _pumpGolden(
      tester,
      AnalyticsPage(
        loader: _StaticAnalyticsLoader(_analyticsReadModelWithData()),
        nowProvider: () => DateTime.utc(2026, 6),
      ),
    );

    await expectLater(
      find.byKey(_goldenKey),
      matchesGoldenFile('goldens/analytics_success.png'),
    );
  });

  testWidgets('Settings defaults baseline', (tester) async {
    final repository = _SettingsProfileRepositoryFake();

    await _pumpGolden(
      tester,
      SettingsPage(
        loadSettings: LoadSettingsProfile(repository),
        saveSettings: SaveSettingsProfile(repository),
        resetSettings: ResetSettingsProfile(repository),
      ),
    );

    await expectLater(
      find.byKey(_goldenKey),
      matchesGoldenFile('goldens/settings_defaults.png'),
    );
  });

  testWidgets('Onboarding welcome baseline', (tester) async {
    final harness = _OnboardingHarness();

    await _pumpGolden(
      tester,
      OnboardingPage(
        skipOnboarding: harness.skipOnboarding,
        completeOnboarding: harness.completeOnboarding,
        onFinished: () {},
      ),
    );

    await expectLater(
      find.byKey(_goldenKey),
      matchesGoldenFile('goldens/onboarding_welcome.png'),
    );
  });
}

const _goldenKey = Key('repforge_golden_surface');

Future<void> _pumpGolden(
  WidgetTester tester,
  Widget child, {
  Size surfaceSize = const Size(390, 844),
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = surfaceSize;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    RepaintBoundary(
      key: _goldenKey,
      child: SizedBox(
        width: surfaceSize.width,
        height: surfaceSize.height,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: RepForgeTheme.dark(),
          home: Scaffold(body: child),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

TodayDashboardReadModel _todaySuccessModel() {
  return const TodayDashboardReadModel(
    setCount: 4,
    totalVolumeKg: 1250,
    lastLoggedSet: TodayLastLoggedSetViewModel(
      exerciseName: 'Barbell Bench Press',
      repetitions: 5,
      loadKg: 100,
    ),
    restTimer: RestTimerCountdownState(
      status: RestTimerStatus.running,
      remaining: Duration(seconds: 90),
      displayText: '01:30',
      isVisible: true,
    ),
  );
}

ExerciseAnalyticsReadModel _analyticsReadModelWithData() {
  final current = _overview(
    setCount: 2,
    totalRepetitions: 15,
    totalVolumeKg: 1300,
    averageKgPerRep: 86.6666667,
    bestEstimatedOneRepMaxKg: 116.6666667,
  );
  final previous = _overview(
    setCount: 1,
    totalRepetitions: 10,
    totalVolumeKg: 600,
    averageKgPerRep: 60,
    bestEstimatedOneRepMaxKg: 80,
  );

  return ExerciseAnalyticsReadModel(
    exerciseRef: ExerciseRef.official(
      id: OfficialExerciseId('barbell_bench_press'),
      displayNameSnapshot: 'Barbell Bench Press',
      catalogVersionSnapshot: '1.0.0',
    ),
    period: ExerciseAnalyticsPeriod(
      start: DateTime.utc(2026, 5),
      end: DateTime.utc(2026, 6),
    ),
    previousPeriod: ExerciseAnalyticsPeriod(
      start: DateTime.utc(2026, 4),
      end: DateTime.utc(2026, 5),
    ),
    overview: current,
    previousComparableSession: _comparison(current, previous),
    timeWindow: _comparison(current, previous),
    scannedSetCount: current.setCount + previous.setCount,
    reachedHistoryLimit: false,
  );
}

ExerciseAnalyticsComparison _comparison(
  ExerciseAnalyticsOverview current,
  ExerciseAnalyticsOverview previous,
) {
  return ExerciseAnalyticsComparison(
    current: current,
    previous: previous,
    availability: ExerciseAnalyticsComparisonAvailability.available,
    totalVolumeKgDelta: ExerciseMetricDelta.fromValues(
      current: current.totalVolumeKg,
      previous: previous.totalVolumeKg,
    ),
    bestEstimatedOneRepMaxKgDelta: ExerciseMetricDelta.fromValues(
      current: current.bestEstimatedOneRepMaxKg.value ?? 0,
      previous: previous.bestEstimatedOneRepMaxKg.value,
    ),
  );
}

ExerciseAnalyticsOverview _overview({
  required int setCount,
  required int totalRepetitions,
  required double totalVolumeKg,
  required double averageKgPerRep,
  required double bestEstimatedOneRepMaxKg,
}) {
  return ExerciseAnalyticsOverview.fromSummary(
    WorkoutSetAnalyticsSummary(
      setCount: setCount,
      totalRepetitions: totalRepetitions,
      totalVolumeKg: totalVolumeKg,
      averageKgPerRep: averageKgPerRep,
      bestSetLoadKg: null,
      bestEstimatedOneRepMax: EstimatedOneRepMax(
        valueKg: bestEstimatedOneRepMaxKg,
        formulaIdentity: EpleyOneRepMaxFormula.epleyV1,
      ),
      oneRepMaxFormulaIdentity: EpleyOneRepMaxFormula.epleyV1,
    ),
  );
}

final class _StaticTodayDashboardLoader implements TodayDashboardLoader {
  const _StaticTodayDashboardLoader(this.model);

  final TodayDashboardReadModel model;

  @override
  Future<TodayDashboardReadModel> load() async => model;
}

final class _StaticAnalyticsLoader implements ExerciseAnalyticsLoader {
  const _StaticAnalyticsLoader(this.model);

  final ExerciseAnalyticsReadModel model;

  @override
  Future<ExerciseAnalyticsReadModel> load(
    ExerciseAnalyticsLoadRequest request,
  ) async {
    return model;
  }
}

final class _SettingsProfileRepositoryFake
    implements SettingsProfileRepository {
  SettingsProfile profile = SettingsProfile.defaults();

  @override
  Future<SettingsProfile> load() async => profile;

  @override
  Future<void> save(SettingsProfile profile) async {
    this.profile = profile;
  }
}

final class _OnboardingHarness {
  _OnboardingHarness() {
    skipOnboarding = SkipOnboarding(
      statusRepository,
      now: () => DateTime.utc(2026, 6),
    );
    completeOnboarding = CompleteOnboarding(
      loadSettingsProfile: LoadSettingsProfile(settingsRepository),
      saveSettingsProfile: SaveSettingsProfile(settingsRepository),
      onboardingStatusRepository: statusRepository,
      createStarterGroups: CreateStarterGroups(groupRepository),
      starterTemplateLoader: const _StarterTemplateLoaderFake(),
      now: () => DateTime.utc(2026, 6),
    );
  }

  final _SettingsProfileRepositoryFake settingsRepository =
      _SettingsProfileRepositoryFake();
  final _OnboardingStatusRepositoryFake statusRepository =
      _OnboardingStatusRepositoryFake();
  final _WorkoutGroupRepositoryFake groupRepository =
      _WorkoutGroupRepositoryFake();

  late final SkipOnboarding skipOnboarding;
  late final CompleteOnboarding completeOnboarding;
}

final class _StarterTemplateLoaderFake implements StarterTemplateLoader {
  const _StarterTemplateLoaderFake();

  @override
  Future<StarterTemplateCatalog> load() async {
    return StarterTemplateCatalog(
      templateVersion: '2026.06.0',
      groups: [
        StarterGroupTemplate(
          id: 'full_body_a',
          name: 'Full Body A',
          exercises: const [
            StarterExerciseTemplate(
              catalogId: 'barbell_back_squat',
              displayNameSnapshot: 'Barbell Back Squat',
              catalogVersionSnapshot: '2026.06.0',
            ),
          ],
        ),
      ],
    );
  }
}

final class _OnboardingStatusRepositoryFake
    implements OnboardingStatusRepository {
  OnboardingStatus status = OnboardingStatus.notStarted();

  @override
  Future<OnboardingStatus> load() async => status;

  @override
  Future<void> save(OnboardingStatus status) async {
    this.status = status;
  }
}

final class _WorkoutGroupRepositoryFake implements WorkoutGroupRepository {
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
    throw UnimplementedError();
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
