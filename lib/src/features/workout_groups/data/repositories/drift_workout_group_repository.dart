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
    final filter = _WorkoutGroupSqlFilter.fromQuery(query);
    final count = await _countGroups(filter);
    final rows =
        await (_database.select(_database.workoutGroups)
              ..where(($WorkoutGroupsTable table) {
                return filter.expression(table);
              })
              ..orderBy(_groupOrder(query.sort))
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
  Future<void> archiveGroup(WorkoutGroupId id, DateTime archivedAt) async {
    await (_database.update(_database.workoutGroups)
          ..where(($WorkoutGroupsTable table) {
            return table.workoutGroupId.equals(id.value);
          }))
        .write(
          WorkoutGroupsCompanion(
            archivedAt: Value<DateTime?>(archivedAt.toUtc()),
          ),
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

  Future<int> _countGroups(_WorkoutGroupSqlFilter filter) async {
    final row = await _database
        .customSelect(
          '''
SELECT COUNT(*) AS total_count
FROM workout_groups
${filter.whereSql}
''',
          variables: filter.variables,
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

List<OrderingTerm Function($WorkoutGroupsTable)> _groupOrder(
  WorkoutGroupListSort sort,
) {
  return switch (sort) {
    WorkoutGroupListSort.sortOrder =>
      <OrderingTerm Function($WorkoutGroupsTable)>[
        ($WorkoutGroupsTable table) => OrderingTerm.asc(table.sortOrder),
        ($WorkoutGroupsTable table) => OrderingTerm.asc(table.name),
        ($WorkoutGroupsTable table) => OrderingTerm.asc(table.workoutGroupId),
      ],
    WorkoutGroupListSort.name => <OrderingTerm Function($WorkoutGroupsTable)>[
      ($WorkoutGroupsTable table) => OrderingTerm.asc(table.name),
      ($WorkoutGroupsTable table) => OrderingTerm.asc(table.sortOrder),
      ($WorkoutGroupsTable table) => OrderingTerm.asc(table.workoutGroupId),
    ],
  };
}

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

final class _WorkoutGroupSqlFilter {
  const _WorkoutGroupSqlFilter({
    required this.includeArchived,
    required this.searchText,
  });

  factory _WorkoutGroupSqlFilter.fromQuery(WorkoutGroupQuery query) {
    return _WorkoutGroupSqlFilter(
      includeArchived: query.includeArchived,
      searchText: query.searchText,
    );
  }

  final bool includeArchived;
  final String? searchText;

  Expression<bool> expression($WorkoutGroupsTable table) {
    Expression<bool>? expression;

    if (!includeArchived) {
      expression = table.archivedAt.isNull();
    }

    final searchText = this.searchText;
    if (searchText != null) {
      final searchExpression =
          table.workoutGroupId.lower().contains(searchText.toLowerCase()) |
          table.name.lower().contains(searchText.toLowerCase());
      expression = expression == null
          ? searchExpression
          : expression & searchExpression;
    }

    return expression ?? const Constant<bool>(true);
  }

  String get whereSql {
    final clauses = <String>[];

    if (!includeArchived) {
      clauses.add('archived_at IS NULL');
    }
    if (searchText != null) {
      clauses.add('(lower(workout_group_id) LIKE ? OR lower(name) LIKE ?)');
    }

    return clauses.isEmpty ? '' : 'WHERE ${clauses.join(' AND ')}';
  }

  List<Variable<Object>> get variables {
    final searchText = this.searchText;
    if (searchText == null) {
      return const <Variable<Object>>[];
    }

    final pattern = '%${searchText.toLowerCase()}%';
    return <Variable<Object>>[
      Variable<String>(pattern),
      Variable<String>(pattern),
    ];
  }
}
