import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';
import 'package:repforge/src/features/workout_groups/data/mappers/workout_group_mapper.dart';
import 'package:repforge/src/features/workout_groups/domain/workout_groups_domain.dart';
import 'package:repforge/src/shared/data/local/repforge_database.dart';

void main() {
  group('WorkoutGroupMapper', () {
    test('round-trips a workout group with archivedAt', () {
      final archivedAt = DateTime.utc(2026, 5, 27, 18);
      final group = WorkoutGroup(
        id: WorkoutGroupId('group-1'),
        name: WorkoutGroupName('Push Day'),
        sortOrder: WorkoutGroupSortOrder(2),
        archivedAt: archivedAt,
      );

      final row = _groupRowFromCompanion(
        WorkoutGroupMapper.toGroupCompanion(group),
      );

      expect(row.workoutGroupId, 'group-1');
      expect(row.name, 'Push Day');
      expect(row.sortOrder, 2);
      expect(row.archivedAt, archivedAt);
      expect(WorkoutGroupMapper.toGroupDomain(row), group);
    });

    test('round-trips an official assignment with catalog snapshot', () {
      final assignment = _officialAssignment();
      final row = _assignmentRowFromCompanion(
        WorkoutGroupMapper.toAssignmentCompanion(assignment),
      );

      expect(row.assignmentId, 'assignment-1');
      expect(row.workoutGroupId, 'push-day');
      expect(row.exerciseSource, 'official');
      expect(row.exerciseId, 'barbell_bench_press');
      expect(row.exerciseDisplayNameSnapshot, 'Barbell Bench Press');
      expect(row.catalogVersionSnapshot, '2026.05.0');
      expect(row.position, 0);
      expect(WorkoutGroupMapper.toAssignmentDomain(row), assignment);
    });

    test('round-trips a future custom assignment without catalog snapshot', () {
      final assignment = WorkoutGroupExerciseAssignment(
        id: WorkoutGroupExerciseAssignmentId('assignment-custom-1'),
        workoutGroupId: WorkoutGroupId('pull-day'),
        exerciseRef: ExerciseRef.custom(
          id: CustomExerciseId('custom-row-1'),
          displayNameSnapshot: 'Home Row',
        ),
        position: AssignmentPosition(1),
      );
      final row = _assignmentRowFromCompanion(
        WorkoutGroupMapper.toAssignmentCompanion(assignment),
      );

      expect(row.exerciseSource, 'custom');
      expect(row.catalogVersionSnapshot, isNull);
      expect(WorkoutGroupMapper.toAssignmentDomain(row), assignment);
    });

    test('rejects custom assignment rows with catalog snapshots', () {
      final row = _assignmentRow(exerciseSource: 'custom');

      expect(
        () => WorkoutGroupMapper.toAssignmentDomain(row),
        throwsA(
          isA<WorkoutGroupValidationException>()
              .having(
                (error) => error.field,
                'field',
                'exerciseRef.catalogVersionSnapshot',
              )
              .having(
                (error) => error.message,
                'message',
                contains('Custom workout group assignment rows must not'),
              ),
        ),
      );
    });

    test('rejects unsupported persisted assignment exercise source', () {
      final row = _assignmentRow(exerciseSource: 'remote');

      expect(
        () => WorkoutGroupMapper.toAssignmentDomain(row),
        throwsA(
          isA<WorkoutGroupValidationException>().having(
            (error) => error.field,
            'field',
            'exerciseRef.source',
          ),
        ),
      );
    });
  });
}

WorkoutGroupExerciseAssignment _officialAssignment() {
  return WorkoutGroupExerciseAssignment(
    id: WorkoutGroupExerciseAssignmentId('assignment-1'),
    workoutGroupId: WorkoutGroupId('push-day'),
    exerciseRef: ExerciseRef.official(
      id: OfficialExerciseId('barbell_bench_press'),
      displayNameSnapshot: 'Barbell Bench Press',
      catalogVersionSnapshot: '2026.05.0',
    ),
    position: AssignmentPosition(0),
  );
}

WorkoutGroupRow _groupRowFromCompanion(WorkoutGroupsCompanion companion) {
  return WorkoutGroupRow(
    workoutGroupId: companion.workoutGroupId.value,
    name: companion.name.value,
    sortOrder: companion.sortOrder.value,
    archivedAt: companion.archivedAt.value,
  );
}

WorkoutGroupExerciseAssignmentRow _assignmentRowFromCompanion(
  WorkoutGroupExerciseAssignmentsCompanion companion,
) {
  return WorkoutGroupExerciseAssignmentRow(
    assignmentId: companion.assignmentId.value,
    workoutGroupId: companion.workoutGroupId.value,
    exerciseSource: companion.exerciseSource.value,
    exerciseId: companion.exerciseId.value,
    exerciseDisplayNameSnapshot: companion.exerciseDisplayNameSnapshot.value,
    catalogVersionSnapshot: companion.catalogVersionSnapshot.value,
    position: companion.position.value,
  );
}

WorkoutGroupExerciseAssignmentRow _assignmentRow({
  String exerciseSource = 'official',
  String? catalogVersionSnapshot = '2026.05.0',
}) {
  return WorkoutGroupExerciseAssignmentRow(
    assignmentId: 'assignment-row',
    workoutGroupId: 'group-row',
    exerciseSource: exerciseSource,
    exerciseId: 'exercise-row',
    exerciseDisplayNameSnapshot: 'Exercise Row',
    catalogVersionSnapshot: catalogVersionSnapshot,
    position: 0,
  );
}
