import '../entities/workout_group.dart';
import '../entities/workout_group_exercise_assignment.dart';

final class WorkoutGroupPage {
  const WorkoutGroupPage({
    required this.items,
    required this.totalCount,
    required this.limit,
    required this.offset,
  });

  final List<WorkoutGroup> items;
  final int totalCount;
  final int limit;
  final int offset;

  bool get hasMore => offset + items.length < totalCount;
}

final class WorkoutGroupAssignmentPage {
  const WorkoutGroupAssignmentPage({
    required this.items,
    required this.totalCount,
    required this.limit,
    required this.offset,
  });

  final List<WorkoutGroupExerciseAssignment> items;
  final int totalCount;
  final int limit;
  final int offset;

  bool get hasMore => offset + items.length < totalCount;
}
