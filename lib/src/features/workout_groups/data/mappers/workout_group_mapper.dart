import 'package:drift/drift.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';
import 'package:repforge/src/features/workout_groups/domain/workout_groups_domain.dart';
import 'package:repforge/src/shared/data/local/repforge_database.dart';

final class WorkoutGroupMapper {
  const WorkoutGroupMapper._();

  static const String officialSource = 'official';
  static const String customSource = 'custom';

  static WorkoutGroupsCompanion toGroupCompanion(WorkoutGroup group) {
    return WorkoutGroupsCompanion(
      workoutGroupId: Value<String>(group.id.value),
      name: Value<String>(group.name.value),
      sortOrder: Value<int>(group.sortOrder.value),
      archivedAt: Value<DateTime?>(group.archivedAt?.toUtc()),
    );
  }

  static WorkoutGroup toGroupDomain(WorkoutGroupRow row) {
    return WorkoutGroup(
      id: WorkoutGroupId(row.workoutGroupId),
      name: WorkoutGroupName(row.name),
      sortOrder: WorkoutGroupSortOrder(row.sortOrder),
      archivedAt: row.archivedAt?.toUtc(),
    );
  }

  static WorkoutGroupExerciseAssignmentsCompanion toAssignmentCompanion(
    WorkoutGroupExerciseAssignment assignment,
  ) {
    return WorkoutGroupExerciseAssignmentsCompanion(
      assignmentId: Value<String>(assignment.id.value),
      workoutGroupId: Value<String>(assignment.workoutGroupId.value),
      exerciseSource: Value<String>(
        toStorageExerciseSource(assignment.exerciseRef),
      ),
      exerciseId: Value<String>(assignment.exerciseRef.id),
      exerciseDisplayNameSnapshot: Value<String>(
        assignment.exerciseRef.displayNameSnapshot,
      ),
      catalogVersionSnapshot: Value<String?>(
        assignment.exerciseRef.catalogVersionSnapshot,
      ),
      position: Value<int>(assignment.position.value),
    );
  }

  static WorkoutGroupExerciseAssignment toAssignmentDomain(
    WorkoutGroupExerciseAssignmentRow row,
  ) {
    return WorkoutGroupExerciseAssignment(
      id: WorkoutGroupExerciseAssignmentId(row.assignmentId),
      workoutGroupId: WorkoutGroupId(row.workoutGroupId),
      exerciseRef: _exerciseRef(row),
      position: AssignmentPosition(row.position),
    );
  }

  static String toStorageExerciseSource(ExerciseRef exerciseRef) {
    return switch (exerciseRef.source) {
      ExerciseSource.official => officialSource,
      ExerciseSource.custom => customSource,
    };
  }

  static ExerciseRef _exerciseRef(WorkoutGroupExerciseAssignmentRow row) {
    return switch (row.exerciseSource) {
      officialSource => ExerciseRef.official(
        id: OfficialExerciseId(row.exerciseId),
        displayNameSnapshot: row.exerciseDisplayNameSnapshot,
        catalogVersionSnapshot: row.catalogVersionSnapshot,
      ),
      customSource => _customExerciseRef(row),
      _ => throw WorkoutGroupValidationException(
        'exerciseRef.source',
        'Unsupported persisted assignment exercise source: '
            '${row.exerciseSource}.',
      ),
    };
  }

  static ExerciseRef _customExerciseRef(WorkoutGroupExerciseAssignmentRow row) {
    if (row.catalogVersionSnapshot != null) {
      throw const WorkoutGroupValidationException(
        'exerciseRef.catalogVersionSnapshot',
        'Custom workout group assignment rows must not contain catalog '
            'version snapshots.',
      );
    }

    return ExerciseRef.custom(
      id: CustomExerciseId(row.exerciseId),
      displayNameSnapshot: row.exerciseDisplayNameSnapshot,
    );
  }
}
