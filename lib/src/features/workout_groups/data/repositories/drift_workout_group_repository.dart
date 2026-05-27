import 'package:drift/drift.dart';
import 'package:repforge/src/features/workout_groups/data/mappers/workout_group_mapper.dart';
import 'package:repforge/src/features/workout_groups/domain/workout_groups_domain.dart';
import 'package:repforge/src/shared/data/local/repforge_database.dart';

final class DriftWorkoutGroupRepository implements WorkoutGroupRepository {
  const DriftWorkoutGroupRepository(this._database);

  final RepForgeDatabase _database;

  @override
  Future<void> saveGroup(WorkoutGroup group) async {
    await _database
        .into(_database.workoutGroups)
        .insertOnConflictUpdate(WorkoutGroupMapper.toGroupCompanion(group));
  }

  @override
  Future<WorkoutGroup?> findGroupById(WorkoutGroupId id) async {
    final row =
        await (_database.select(_database.workoutGroups)
              ..where(($WorkoutGroupsTable table) {
                return table.workoutGroupId.equals(id.value);
              }))
            .getSingleOrNull();

    return row == null ? null : WorkoutGroupMapper.toGroupDomain(row);
  }

  @override
  Future<WorkoutGroupPage> listGroups(WorkoutGroupQuery query) async {
    final count = await _countGroups();
    final rows =
        await (_database.select(_database.workoutGroups)
              ..orderBy(_groupOrder)
              ..limit(query.limit, offset: query.offset))
            .get();

    return WorkoutGroupPage(
      items: rows.map(WorkoutGroupMapper.toGroupDomain).toList(growable: false),
      totalCount: count,
      limit: query.limit,
      offset: query.offset,
    );
  }

  @override
  Future<void> saveAssignment(WorkoutGroupExerciseAssignment assignment) async {
    await _database
        .into(_database.workoutGroupExerciseAssignments)
        .insertOnConflictUpdate(
          WorkoutGroupMapper.toAssignmentCompanion(assignment),
        );
  }

  @override
  Future<void> removeAssignment(WorkoutGroupExerciseAssignmentId id) async {
    await (_database.delete(_database.workoutGroupExerciseAssignments)
          ..where(($WorkoutGroupExerciseAssignmentsTable table) {
            return table.assignmentId.equals(id.value);
          }))
        .go();
  }

  @override
  Future<WorkoutGroupAssignmentPage> listAssignments(
    WorkoutGroupId groupId,
    WorkoutGroupAssignmentQuery query,
  ) async {
    final count = await _countAssignments(groupId);
    final rows =
        await (_database.select(_database.workoutGroupExerciseAssignments)
              ..where(($WorkoutGroupExerciseAssignmentsTable table) {
                return table.workoutGroupId.equals(groupId.value);
              })
              ..orderBy(_assignmentOrder)
              ..limit(query.limit, offset: query.offset))
            .get();

    return WorkoutGroupAssignmentPage(
      items: rows
          .map(WorkoutGroupMapper.toAssignmentDomain)
          .toList(growable: false),
      totalCount: count,
      limit: query.limit,
      offset: query.offset,
    );
  }

  Future<int> _countGroups() async {
    final row = await _database
        .customSelect(
          'SELECT COUNT(*) AS total_count FROM workout_groups',
          readsFrom: <ResultSetImplementation<Table, Object?>>{
            _database.workoutGroups,
          },
        )
        .getSingle();

    return row.read<int>('total_count');
  }

  Future<int> _countAssignments(WorkoutGroupId groupId) async {
    final row = await _database
        .customSelect(
          '''
SELECT COUNT(*) AS total_count
FROM workout_group_exercise_assignments
WHERE workout_group_id = ?
''',
          variables: <Variable<String>>[Variable<String>(groupId.value)],
          readsFrom: <ResultSetImplementation<Table, Object?>>{
            _database.workoutGroupExerciseAssignments,
          },
        )
        .getSingle();

    return row.read<int>('total_count');
  }
}

final List<OrderingTerm Function($WorkoutGroupsTable)> _groupOrder =
    <OrderingTerm Function($WorkoutGroupsTable)>[
      ($WorkoutGroupsTable table) => OrderingTerm.asc(table.sortOrder),
      ($WorkoutGroupsTable table) => OrderingTerm.asc(table.name),
      ($WorkoutGroupsTable table) => OrderingTerm.asc(table.workoutGroupId),
    ];

final List<OrderingTerm Function($WorkoutGroupExerciseAssignmentsTable)>
_assignmentOrder =
    <OrderingTerm Function($WorkoutGroupExerciseAssignmentsTable)>[
      ($WorkoutGroupExerciseAssignmentsTable table) {
        return OrderingTerm.asc(table.position);
      },
      ($WorkoutGroupExerciseAssignmentsTable table) {
        return OrderingTerm.asc(table.assignmentId);
      },
    ];
