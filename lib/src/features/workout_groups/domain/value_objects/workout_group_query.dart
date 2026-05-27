import 'workout_group_validation.dart';

final class WorkoutGroupQuery {
  WorkoutGroupQuery({required int limit, required int offset})
    : limit = requirePageLimit('workoutGroupQuery.limit', limit),
      offset = requireNonNegativeInt('workoutGroupQuery.offset', offset);

  final int limit;
  final int offset;
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
