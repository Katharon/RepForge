import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';
import 'package:repforge/src/features/workout_groups/domain/workout_groups_domain.dart';

void main() {
  group('workout group value objects', () {
    test('reject invalid ids, names, positions, and query bounds', () {
      expect(
        () => WorkoutGroupId(' '),
        throwsA(isA<WorkoutGroupValidationException>()),
      );
      expect(
        () => WorkoutGroupExerciseAssignmentId(''),
        throwsA(isA<WorkoutGroupValidationException>()),
      );
      expect(
        () => WorkoutGroupName(' '),
        throwsA(isA<WorkoutGroupValidationException>()),
      );
      expect(
        () => WorkoutGroupName('x' * 81),
        throwsA(isA<WorkoutGroupValidationException>()),
      );
      expect(
        () => WorkoutGroupSortOrder(-1),
        throwsA(isA<WorkoutGroupValidationException>()),
      );
      expect(
        () => AssignmentPosition(-1),
        throwsA(isA<WorkoutGroupValidationException>()),
      );
      expect(
        () => WorkoutGroupQuery(limit: 0, offset: 0),
        throwsA(isA<WorkoutGroupValidationException>()),
      );
      expect(
        () => WorkoutGroupAssignmentQuery(limit: 1, offset: -1),
        throwsA(isA<WorkoutGroupValidationException>()),
      );
    });

    test('normalizes text values and archivedAt to UTC', () {
      final archivedAt = DateTime(2026, 5, 27, 18);
      final group = WorkoutGroup(
        id: WorkoutGroupId(' group-1 '),
        name: WorkoutGroupName(' Push Day '),
        sortOrder: WorkoutGroupSortOrder(1),
        archivedAt: archivedAt,
      );

      expect(group.id.value, 'group-1');
      expect(group.name.value, 'Push Day');
      expect(group.archivedAt, archivedAt.toUtc());
    });
  });

  group('workout group exercise assignment', () {
    test('supports official references with catalog snapshots', () {
      final assignment = WorkoutGroupExerciseAssignment(
        id: WorkoutGroupExerciseAssignmentId('assignment-1'),
        workoutGroupId: WorkoutGroupId('push-day'),
        exerciseRef: ExerciseRef.official(
          id: OfficialExerciseId('barbell_bench_press'),
          displayNameSnapshot: 'Barbell Bench Press',
          catalogVersionSnapshot: '2026.05.0',
        ),
        position: AssignmentPosition(0),
      );

      expect(assignment.exerciseRef.source, ExerciseSource.official);
      expect(assignment.exerciseRef.id, 'barbell_bench_press');
      expect(assignment.exerciseRef.catalogVersionSnapshot, '2026.05.0');
    });

    test('supports future custom references without catalog snapshots', () {
      final assignment = WorkoutGroupExerciseAssignment(
        id: WorkoutGroupExerciseAssignmentId('assignment-custom-1'),
        workoutGroupId: WorkoutGroupId('pull-day'),
        exerciseRef: ExerciseRef.custom(
          id: CustomExerciseId('custom-row-1'),
          displayNameSnapshot: 'Home Row',
        ),
        position: AssignmentPosition(1),
      );

      expect(assignment.exerciseRef.source, ExerciseSource.custom);
      expect(assignment.exerciseRef.id, 'custom-row-1');
      expect(assignment.exerciseRef.catalogVersionSnapshot, isNull);
    });

    test('custom assignment references cannot carry catalog snapshots', () {
      final customRef = ExerciseRef.custom(
        id: CustomExerciseId('custom-1'),
        displayNameSnapshot: 'Custom Row',
      );
      final assignment = WorkoutGroupExerciseAssignment(
        id: WorkoutGroupExerciseAssignmentId('assignment-custom-2'),
        workoutGroupId: WorkoutGroupId('pull-day'),
        exerciseRef: customRef,
        position: AssignmentPosition(0),
      );

      expect(assignment.exerciseRef.catalogVersionSnapshot, isNull);
    });
  });

  test('WorkoutGroupRepository contract compiles against domain types', () {
    final repository = _InMemoryWorkoutGroupRepository();
    final group = WorkoutGroup(
      id: WorkoutGroupId('push-day'),
      name: WorkoutGroupName('Push Day'),
      sortOrder: WorkoutGroupSortOrder(0),
    );

    expect(repository.saveGroup(group), completes);
    expect(
      repository.findGroupById(WorkoutGroupId('push-day')),
      completion(group),
    );
    expect(
      repository.listGroups(WorkoutGroupQuery(limit: 10, offset: 0)),
      completion(isA<WorkoutGroupPage>()),
    );
    expect(
      repository.archiveGroup(
        WorkoutGroupId('push-day'),
        DateTime.utc(2026, 5, 28),
      ),
      completes,
    );
  });
}

final class _InMemoryWorkoutGroupRepository implements WorkoutGroupRepository {
  final Map<WorkoutGroupId, WorkoutGroup> _groups =
      <WorkoutGroupId, WorkoutGroup>{};
  final Map<WorkoutGroupExerciseAssignmentId, WorkoutGroupExerciseAssignment>
  _assignments =
      <WorkoutGroupExerciseAssignmentId, WorkoutGroupExerciseAssignment>{};

  @override
  Future<WorkoutGroup?> findGroupById(WorkoutGroupId id) async => _groups[id];

  @override
  Future<WorkoutGroupPage> listGroups(WorkoutGroupQuery query) async {
    final items = _groups.values
        .where((group) => query.includeArchived || group.archivedAt == null)
        .toList(growable: false);
    return WorkoutGroupPage(
      items: items,
      totalCount: items.length,
      limit: query.limit,
      offset: query.offset,
    );
  }

  @override
  Future<void> archiveGroup(WorkoutGroupId id, DateTime archivedAt) async {
    final group = _groups[id];
    if (group == null) {
      return;
    }

    _groups[id] = WorkoutGroup(
      id: group.id,
      name: group.name,
      sortOrder: group.sortOrder,
      archivedAt: archivedAt,
    );
  }

  @override
  Future<void> removeAssignment(WorkoutGroupExerciseAssignmentId id) async {
    _assignments.remove(id);
  }

  @override
  Future<void> saveAssignment(WorkoutGroupExerciseAssignment assignment) async {
    _assignments[assignment.id] = assignment;
  }

  @override
  Future<void> saveGroup(WorkoutGroup group) async {
    _groups[group.id] = group;
  }

  @override
  Future<WorkoutGroupAssignmentPage> listAssignments(
    WorkoutGroupId groupId,
    WorkoutGroupAssignmentQuery query,
  ) async {
    final items = _assignments.values
        .where((assignment) => assignment.workoutGroupId == groupId)
        .toList(growable: false);
    return WorkoutGroupAssignmentPage(
      items: items,
      totalCount: items.length,
      limit: query.limit,
      offset: query.offset,
    );
  }
}
