import 'workout_group_validation.dart';

enum WorkoutGroupListSort { sortOrder, name }

final class WorkoutGroupQuery {
  WorkoutGroupQuery({
    required int limit,
    required int offset,
    String? searchText,
    this.includeArchived = false,
    this.sort = WorkoutGroupListSort.sortOrder,
  }) : limit = requirePageLimit('workoutGroupQuery.limit', limit),
       offset = requireNonNegativeInt('workoutGroupQuery.offset', offset),
       searchText = _normalizeSearchText(searchText);

  final int limit;
  final int offset;
  final String? searchText;
  final bool includeArchived;
  final WorkoutGroupListSort sort;
}

final class WorkoutGroupAssignmentQuery {
  WorkoutGroupAssignmentQuery({required int limit, required int offset})
    : limit = requirePageLimit('workoutGroupAssignmentQuery.limit', limit),
      offset = requireNonNegativeInt(
        'workoutGroupAssignmentQuery.offset',
        offset,
      );

  final int limit;
  final int offset;
}

String? _normalizeSearchText(String? value) {
  if (value == null) {
    return null;
  }

  final normalized = value.trim();
  return normalized.isEmpty
      ? null
      : requireWorkoutGroupText('workoutGroupQuery.searchText', value);
}
