import '../entities/workout_group.dart';
import '../entities/workout_group_exercise_assignment.dart';
import '../value_objects/workout_group_ids.dart';
import '../value_objects/workout_group_page.dart';
import '../value_objects/workout_group_query.dart';

abstract interface class WorkoutGroupRepository {
  Future<void> saveGroup(WorkoutGroup group);

  Future<WorkoutGroup?> findGroupById(WorkoutGroupId id);

  Future<WorkoutGroupPage> listGroups(WorkoutGroupQuery query);

  Future<void> saveAssignment(WorkoutGroupExerciseAssignment assignment);

  Future<void> removeAssignment(WorkoutGroupExerciseAssignmentId id);

  Future<WorkoutGroupAssignmentPage> listAssignments(
    WorkoutGroupId groupId,
    WorkoutGroupAssignmentQuery query,
  );
}
