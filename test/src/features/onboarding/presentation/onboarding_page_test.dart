import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/app/localization/app_localizations.dart';
import 'package:repforge/src/core/theme/theme.dart';
import 'package:repforge/src/features/onboarding/application/onboarding_application.dart';
import 'package:repforge/src/features/onboarding/domain/onboarding_domain.dart';
import 'package:repforge/src/features/onboarding/presentation/onboarding_presentation.dart';
import 'package:repforge/src/features/settings/application/settings_application.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';
import 'package:repforge/src/features/workout_groups/domain/workout_groups_domain.dart';

void main() {
  testWidgets('onboarding welcome renders', (tester) async {
    await tester.pumpWidget(_testApp(_page(_Harness())));
    await tester.pumpAndSettle();

    expect(find.text('Set up RepForge'), findsOneWidget);
    expect(find.text('Start setup'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
  });

  testWidgets('skip path works and stores skipped status', (tester) async {
    final harness = _Harness();
    var finished = false;

    await tester.pumpWidget(
      _testApp(_page(harness, onFinished: () => finished = true)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('onboarding_skip_button')));
    await tester.pumpAndSettle();

    expect(finished, isTrue);
    expect(
      harness.statusRepository.status.completion,
      OnboardingCompletion.skipped,
    );
  });

  testWidgets('entering profile, time, and equipment values saves locally', (
    tester,
  ) async {
    _useTallTestSurface(tester);
    final harness = _Harness();

    await tester.pumpWidget(_testApp(_page(harness)));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('onboarding_start_button')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('onboarding_display_name_field')),
      'Mira',
    );
    await _selectDropdown(
      tester,
      const Key('onboarding_focus_dropdown'),
      'Strength basics',
    );
    await tester.tap(find.byKey(const Key('onboarding_next_button')));
    await tester.pumpAndSettle();
    await _selectDropdown(
      tester,
      const Key('onboarding_frequency_dropdown'),
      '5 days/week',
    );
    await _selectDropdown(
      tester,
      const Key('onboarding_session_duration_dropdown'),
      '60 min',
    );
    await tester.tap(find.byKey(const Key('onboarding_next_button')));
    await tester.pumpAndSettle();
    await tester.tap(
      _filterChip(const Key('onboarding_equipment_dumbbell')).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding_complete_button')));
    await tester.pumpAndSettle();

    expect(find.text('Setup saved'), findsOneWidget);
    expect(harness.settingsRepository.profile.userProfile.displayName, 'Mira');
    expect(
      harness.settingsRepository.profile.focusProfile,
      FocusProfile.strengthBasics,
    );
    expect(harness.settingsRepository.profile.trainingFrequency.daysPerWeek, 5);
    expect(
      harness.settingsRepository.profile.sessionDuration,
      SessionDurationPreference.sixty,
    );
    expect(
      harness.settingsRepository.profile.equipmentInventory.contains(
        AvailableEquipment.dumbbell,
      ),
      isTrue,
    );
    expect(harness.groupRepository.groups, isNotEmpty);
  });

  testWidgets('error state renders when completion fails', (tester) async {
    _useTallTestSurface(tester);
    final harness = _Harness(failStarterTemplates: true);

    await tester.pumpWidget(_testApp(_page(harness)));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('onboarding_start_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding_next_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding_next_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding_complete_button')));
    await tester.pumpAndSettle();

    expect(
      find.text('Setup could not save. Try again without changing local data.'),
      findsOneWidget,
    );
  });
}

Widget _page(_Harness harness, {VoidCallback? onFinished}) {
  return OnboardingPage(
    skipOnboarding: harness.skipOnboarding,
    completeOnboarding: harness.completeOnboarding,
    onFinished: onFinished ?? () {},
  );
}

Widget _testApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: RepForgeTheme.dark(),
    home: Scaffold(body: child),
  );
}

Future<void> _selectDropdown(
  WidgetTester tester,
  Key dropdownKey,
  String label,
) async {
  await tester.tap(_dropdown(dropdownKey).first);
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

Finder _dropdown(Key key) {
  return find.byWidgetPredicate((widget) {
    return widget is DropdownButtonFormField && widget.key == key;
  });
}

Finder _filterChip(Key key) {
  return find.byWidgetPredicate((widget) {
    return widget is FilterChip && widget.key == key;
  });
}

void _useTallTestSurface(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1000, 1600);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

final class _Harness {
  _Harness({bool failStarterTemplates = false})
    : starterTemplateLoader = failStarterTemplates
          ? _FailingStarterTemplateLoader()
          : _StarterTemplateLoaderFake(_catalog()) {
    skipOnboarding = SkipOnboarding(
      statusRepository,
      now: () => DateTime.utc(2026, 5, 28, 12),
    );
    completeOnboarding = CompleteOnboarding(
      loadSettingsProfile: LoadSettingsProfile(settingsRepository),
      saveSettingsProfile: SaveSettingsProfile(settingsRepository),
      onboardingStatusRepository: statusRepository,
      createStarterGroups: CreateStarterGroups(groupRepository),
      starterTemplateLoader: starterTemplateLoader,
      now: () => DateTime.utc(2026, 5, 28, 13),
    );
  }

  final _SettingsProfileRepositoryFake settingsRepository =
      _SettingsProfileRepositoryFake();
  final _OnboardingStatusRepositoryFake statusRepository =
      _OnboardingStatusRepositoryFake();
  final _WorkoutGroupRepositoryFake groupRepository =
      _WorkoutGroupRepositoryFake();
  final StarterTemplateLoader starterTemplateLoader;

  late final SkipOnboarding skipOnboarding;
  late final CompleteOnboarding completeOnboarding;
}

StarterTemplateCatalog _catalog() {
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

final class _StarterTemplateLoaderFake implements StarterTemplateLoader {
  const _StarterTemplateLoaderFake(this.catalog);

  final StarterTemplateCatalog catalog;

  @override
  Future<StarterTemplateCatalog> load() async => catalog;
}

final class _FailingStarterTemplateLoader implements StarterTemplateLoader {
  @override
  Future<StarterTemplateCatalog> load() {
    return Future<StarterTemplateCatalog>.error(StateError('boom'));
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

final class _WorkoutGroupRepositoryFake implements WorkoutGroupRepository {
  final List<WorkoutGroup> groups = <WorkoutGroup>[];
  final List<WorkoutGroupExerciseAssignment> assignments =
      <WorkoutGroupExerciseAssignment>[];

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
  Future<void> saveAssignment(WorkoutGroupExerciseAssignment assignment) async {
    assignments.add(assignment);
  }

  @override
  Future<void> saveGroup(WorkoutGroup group) async {
    groups.add(group);
  }
}
