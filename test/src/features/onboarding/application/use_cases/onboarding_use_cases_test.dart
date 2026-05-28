import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/onboarding/application/onboarding_application.dart';
import 'package:repforge/src/features/onboarding/domain/onboarding_domain.dart';
import 'package:repforge/src/features/settings/application/settings_application.dart';
import 'package:repforge/src/features/settings/domain/settings_domain.dart';
import 'package:repforge/src/features/workout_groups/domain/workout_groups_domain.dart';

void main() {
  test('skip stores deterministic skipped status', () async {
    final repository = _OnboardingStatusRepositoryFake();
    final skipped = await SkipOnboarding(
      repository,
      now: () => DateTime.utc(2026, 5, 28, 12),
    )();

    expect(skipped.completion, OnboardingCompletion.skipped);
    expect(skipped.updatedAt, DateTime.utc(2026, 5, 28, 12));
    expect(await repository.load(), skipped);
  });

  test(
    'complete saves onboarding answers through settings use cases',
    () async {
      final settingsRepository = _SettingsProfileRepositoryFake();
      final statusRepository = _OnboardingStatusRepositoryFake();
      final groupRepository = _WorkoutGroupRepositoryFake();
      final complete = CompleteOnboarding(
        loadSettingsProfile: LoadSettingsProfile(settingsRepository),
        saveSettingsProfile: SaveSettingsProfile(settingsRepository),
        onboardingStatusRepository: statusRepository,
        createStarterGroups: CreateStarterGroups(groupRepository),
        starterTemplateLoader: _StarterTemplateLoaderFake(_catalog()),
        now: () => DateTime.utc(2026, 5, 28, 13),
      );

      await complete(
        OnboardingDraft.defaults().copyWith(
          displayName: 'Mira',
          focusProfile: FocusProfile.strengthBasics,
          trainingFrequency: TrainingFrequency(5),
          sessionDuration: SessionDurationPreference.sixty,
        ),
      );

      expect(settingsRepository.profile.userProfile.displayName, 'Mira');
      expect(
        settingsRepository.profile.focusProfile,
        FocusProfile.strengthBasics,
      );
      expect(settingsRepository.profile.trainingFrequency.daysPerWeek, 5);
      expect(
        settingsRepository.profile.sessionDuration,
        SessionDurationPreference.sixty,
      );
      expect(
        (await statusRepository.load()).completion,
        OnboardingCompletion.completed,
      );
    },
  );

  test(
    'starter group creation uses only bundled template references',
    () async {
      final repository = _WorkoutGroupRepositoryFake();

      await CreateStarterGroups(repository)(_catalog());

      expect(repository.groups.map((group) => group.id.value), <String>[
        'starter_full_body_a',
      ]);
      expect(repository.assignments, hasLength(2));
      expect(repository.assignments.first.exerciseRef.id, 'barbell_back_squat');
      expect(
        repository.assignments.first.exerciseRef.catalogVersionSnapshot,
        '2026.05.0',
      );
    },
  );
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
          StarterExerciseTemplate(
            catalogId: 'barbell_bench_press',
            displayNameSnapshot: 'Barbell Bench Press',
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
  Future<WorkoutGroup?> findGroupById(WorkoutGroupId id) async {
    return groups.where((group) => group.id == id).firstOrNull;
  }

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
    assignments.removeWhere((item) => item.id == assignment.id);
    assignments.add(assignment);
  }

  @override
  Future<void> saveGroup(WorkoutGroup group) async {
    groups.removeWhere((item) => item.id == group.id);
    groups.add(group);
  }
}
