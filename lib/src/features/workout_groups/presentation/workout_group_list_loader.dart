import '../domain/workout_groups_domain.dart';

abstract interface class WorkoutGroupListLoader {
  Future<WorkoutGroupListViewModel> load();
}

final class RepositoryWorkoutGroupListLoader implements WorkoutGroupListLoader {
  const RepositoryWorkoutGroupListLoader({
    required this.repository,
    this.limit = 50,
  });

  final WorkoutGroupRepository repository;
  final int limit;

  @override
  Future<WorkoutGroupListViewModel> load() async {
    final page = await repository.listGroups(
      WorkoutGroupQuery(limit: limit, offset: 0),
    );
    final groups = <WorkoutGroupListItemViewModel>[];

    for (final group in page.items) {
      final assignments = await repository.listAssignments(
        group.id,
        WorkoutGroupAssignmentQuery(limit: 100, offset: 0),
      );
      groups.add(
        WorkoutGroupListItemViewModel(
          id: group.id.value,
          name: group.name.value,
          exerciseCount: assignments.totalCount,
          exerciseNames: assignments.items
              .map((assignment) => assignment.exerciseRef.displayNameSnapshot)
              .toList(growable: false),
        ),
      );
    }

    return WorkoutGroupListViewModel(
      groups: List<WorkoutGroupListItemViewModel>.unmodifiable(groups),
      totalCount: page.totalCount,
      hasMore: page.hasMore,
    );
  }
}

final class WorkoutGroupListViewModel {
  const WorkoutGroupListViewModel({
    required this.groups,
    required this.totalCount,
    required this.hasMore,
  });

  final List<WorkoutGroupListItemViewModel> groups;
  final int totalCount;
  final bool hasMore;
}

final class WorkoutGroupListItemViewModel {
  const WorkoutGroupListItemViewModel({
    required this.id,
    required this.name,
    required this.exerciseCount,
    required this.exerciseNames,
  });

  final String id;
  final String name;
  final int exerciseCount;
  final List<String> exerciseNames;
}
