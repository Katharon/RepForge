import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:repforge/src/features/exercise_catalog/data/mappers/official_exercise_mapper.dart';
import 'package:repforge/src/features/exercise_catalog/domain/exercise_catalog_domain.dart';
import 'package:repforge/src/features/training_log/domain/value_objects/stable_ids.dart';
import 'package:repforge/src/shared/data/local/repforge_database.dart';

final class DriftExerciseCatalogRepository
    implements ExerciseCatalogRepository, CustomExerciseRepository {
  const DriftExerciseCatalogRepository(this._database);

  final RepForgeDatabase _database;

  @override
  Future<ExerciseCatalogPage> findOfficialExercises(
    ExerciseCatalogQuery query,
  ) async {
    final filter = _CatalogSqlFilter.fromQuery(query);
    final totalCount = await _countMatchingExercises(filter);
    final rows = await _queryMatchingExerciseRows(filter, query);
    final exercises = <OfficialExercise>[];

    for (final row in rows) {
      exercises.add(await _toDomain(row));
    }

    return ExerciseCatalogPage(
      items: List<OfficialExercise>.unmodifiable(exercises),
      totalCount: totalCount,
      limit: query.limit,
      offset: query.offset,
    );
  }

  @override
  Future<OfficialExercise?> findOfficialExerciseById(
    OfficialExerciseId id,
  ) async {
    final row =
        await (_database.select(_database.officialExercises)
              ..where(($OfficialExercisesTable table) {
                return table.catalogId.equals(id.value);
              }))
            .getSingleOrNull();

    return row == null ? null : _toDomain(row);
  }

  @override
  Future<void> saveCustomExercise(CustomExercise exercise) async {
    await _database
        .into(_database.customExercises)
        .insertOnConflictUpdate(_toCustomCompanion(exercise));
  }

  @override
  Future<CustomExercise?> findCustomExerciseById(CustomExerciseId id) async {
    final row =
        await (_database.select(_database.customExercises)
              ..where(($CustomExercisesTable table) {
                return table.customExerciseId.equals(id.value);
              }))
            .getSingleOrNull();

    return row == null ? null : _toCustomDomain(row);
  }

  @override
  Future<CustomExercisePage> listCustomExercises(
    CustomExerciseQuery query,
  ) async {
    final filter = _CustomExerciseSqlFilter.fromQuery(query);
    final count = await _countCustomExercises(filter);
    final rows =
        await (_database.select(_database.customExercises)
              ..where(($CustomExercisesTable table) {
                return filter.expression(table);
              })
              ..orderBy(_customExerciseOrder(query.sort))
              ..limit(query.limit, offset: query.offset))
            .get();

    return CustomExercisePage(
      items: rows.map(_toCustomDomain).toList(growable: false),
      totalCount: count,
      limit: query.limit,
      offset: query.offset,
    );
  }

  @override
  Future<void> archiveCustomExercise(
    CustomExerciseId id,
    DateTime archivedAt,
  ) async {
    await (_database.update(_database.customExercises)
          ..where(($CustomExercisesTable table) {
            return table.customExerciseId.equals(id.value);
          }))
        .write(
          CustomExercisesCompanion(
            archivedAt: Value<DateTime?>(archivedAt.toUtc()),
            updatedAt: Value<DateTime>(archivedAt.toUtc()),
          ),
        );
  }

  Future<int> _countMatchingExercises(_CatalogSqlFilter filter) async {
    final row = await _database
        .customSelect(
          '''
SELECT COUNT(*) AS total_count
FROM official_exercises oe
${filter.whereSql}
''',
          variables: filter.variables,
          readsFrom: <ResultSetImplementation<Table, Object?>>{
            _database.officialExercises,
            _database.officialExerciseEquipmentTags,
            _database.officialExerciseMuscleGroups,
          },
        )
        .getSingle();

    return row.read<int>('total_count');
  }

  Future<int> _countCustomExercises(_CustomExerciseSqlFilter filter) async {
    final row = await _database
        .customSelect(
          '''
SELECT COUNT(*) AS total_count
FROM custom_exercises
${filter.whereSql}
''',
          variables: filter.variables,
          readsFrom: <ResultSetImplementation<Table, Object?>>{
            _database.customExercises,
          },
        )
        .getSingle();

    return row.read<int>('total_count');
  }

  Future<List<OfficialExerciseRow>> _queryMatchingExerciseRows(
    _CatalogSqlFilter filter,
    ExerciseCatalogQuery query,
  ) async {
    final rows = await _database
        .customSelect(
          '''
SELECT
  oe.catalog_id,
  oe.catalog_version,
  oe.schema_version,
  oe.english_name,
  oe.german_name
FROM official_exercises oe
${filter.whereSql}
ORDER BY lower(oe.english_name), oe.catalog_id
LIMIT ? OFFSET ?
''',
          variables: <Variable<Object>>[
            ...filter.variables,
            Variable<int>(query.limit),
            Variable<int>(query.offset),
          ],
          readsFrom: <ResultSetImplementation<Table, Object?>>{
            _database.officialExercises,
            _database.officialExerciseEquipmentTags,
            _database.officialExerciseMuscleGroups,
          },
        )
        .get();

    return rows.map(_rowFromQuery).toList(growable: false);
  }

  OfficialExerciseRow _rowFromQuery(QueryRow row) {
    return OfficialExerciseRow(
      catalogId: row.read<String>('catalog_id'),
      catalogVersion: row.read<String>('catalog_version'),
      schemaVersion: row.read<int>('schema_version'),
      englishName: row.read<String>('english_name'),
      germanName: row.read<String>('german_name'),
    );
  }

  Future<OfficialExercise> _toDomain(OfficialExerciseRow row) async {
    final equipment =
        await (_database.select(_database.officialExerciseEquipmentTags)
              ..where(($OfficialExerciseEquipmentTagsTable table) {
                return table.catalogId.equals(row.catalogId);
              })
              ..orderBy(
                <OrderingTerm Function($OfficialExerciseEquipmentTagsTable)>[
                  ($OfficialExerciseEquipmentTagsTable table) {
                    return OrderingTerm.asc(table.equipmentTag);
                  },
                ],
              ))
            .get();
    final movementPatterns =
        await (_database.select(_database.officialExerciseMovementPatterns)
              ..where(($OfficialExerciseMovementPatternsTable table) {
                return table.catalogId.equals(row.catalogId);
              })
              ..orderBy(
                <OrderingTerm Function($OfficialExerciseMovementPatternsTable)>[
                  ($OfficialExerciseMovementPatternsTable table) {
                    return OrderingTerm.asc(table.movementPattern);
                  },
                ],
              ))
            .get();
    final muscles =
        await (_database.select(_database.officialExerciseMuscleGroups)
              ..where(($OfficialExerciseMuscleGroupsTable table) {
                return table.catalogId.equals(row.catalogId);
              })
              ..orderBy(
                <OrderingTerm Function($OfficialExerciseMuscleGroupsTable)>[
                  ($OfficialExerciseMuscleGroupsTable table) {
                    return OrderingTerm.asc(table.role);
                  },
                  ($OfficialExerciseMuscleGroupsTable table) {
                    return OrderingTerm.asc(table.muscleGroup);
                  },
                ],
              ))
            .get();

    return OfficialExerciseMapper.toDomain(
      row: row,
      equipment: equipment,
      movementPatterns: movementPatterns,
      muscleGroups: muscles,
    );
  }

  CustomExercisesCompanion _toCustomCompanion(CustomExercise exercise) {
    return CustomExercisesCompanion(
      customExerciseId: Value<String>(exercise.id.value),
      name: Value<String>(exercise.name),
      notes: Value<String?>(exercise.notes),
      primaryMusclesJson: Value<String>(
        _encodeValues(exercise.primaryMuscles.map((muscle) => muscle.value)),
      ),
      secondaryMusclesJson: Value<String>(
        _encodeValues(exercise.secondaryMuscles.map((muscle) => muscle.value)),
      ),
      equipmentJson: Value<String>(
        _encodeValues(exercise.equipment.map((tag) => tag.value)),
      ),
      movementPatternsJson: Value<String>(
        _encodeValues(
          exercise.movementPatterns.map((pattern) => pattern.value),
        ),
      ),
      archivedAt: Value<DateTime?>(exercise.archivedAt),
      createdAt: Value<DateTime>(exercise.createdAt),
      updatedAt: Value<DateTime>(exercise.updatedAt),
    );
  }

  CustomExercise _toCustomDomain(CustomExerciseRow row) {
    return CustomExercise(
      id: CustomExerciseId(row.customExerciseId),
      name: row.name,
      notes: row.notes,
      primaryMuscles: _decodeValues(
        row.primaryMusclesJson,
      ).map(MuscleGroup.new),
      secondaryMuscles: _decodeValues(
        row.secondaryMusclesJson,
      ).map(MuscleGroup.new),
      equipment: _decodeValues(row.equipmentJson).map(EquipmentTag.new),
      movementPatterns: _decodeValues(
        row.movementPatternsJson,
      ).map(MovementPattern.new),
      archivedAt: row.archivedAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}

final class _CatalogSqlFilter {
  const _CatalogSqlFilter({required this.whereSql, required this.variables});

  factory _CatalogSqlFilter.fromQuery(ExerciseCatalogQuery query) {
    final clauses = <String>[];
    final variables = <Variable<Object>>[];
    final searchText = query.searchText;

    if (searchText != null) {
      final searchPattern = '%${searchText.toLowerCase()}%';
      clauses.add(
        '('
        'lower(oe.catalog_id) LIKE ? OR '
        'lower(oe.english_name) LIKE ? OR '
        'lower(oe.german_name) LIKE ?'
        ')',
      );
      variables
        ..add(Variable<String>(searchPattern))
        ..add(Variable<String>(searchPattern))
        ..add(Variable<String>(searchPattern));
    }

    for (final tag in query.equipment) {
      clauses.add(
        'EXISTS ('
        'SELECT 1 FROM official_exercise_equipment_tags eet '
        'WHERE eet.catalog_id = oe.catalog_id AND eet.equipment_tag = ?'
        ')',
      );
      variables.add(Variable<String>(tag.value));
    }

    for (final muscle in query.muscles) {
      clauses.add(
        'EXISTS ('
        'SELECT 1 FROM official_exercise_muscle_groups emg '
        'WHERE emg.catalog_id = oe.catalog_id AND emg.muscle_group = ?'
        ')',
      );
      variables.add(Variable<String>(muscle.value));
    }

    return _CatalogSqlFilter(
      whereSql: clauses.isEmpty ? '' : 'WHERE ${clauses.join(' AND ')}',
      variables: List<Variable<Object>>.unmodifiable(variables),
    );
  }

  final String whereSql;
  final List<Variable<Object>> variables;
}

List<OrderingTerm Function($CustomExercisesTable)> _customExerciseOrder(
  CustomExerciseListSort sort,
) {
  return switch (sort) {
    CustomExerciseListSort.name =>
      <OrderingTerm Function($CustomExercisesTable)>[
        ($CustomExercisesTable table) => OrderingTerm.asc(table.name),
        ($CustomExercisesTable table) {
          return OrderingTerm.asc(table.customExerciseId);
        },
      ],
    CustomExerciseListSort.updatedAt =>
      <OrderingTerm Function($CustomExercisesTable)>[
        ($CustomExercisesTable table) {
          return OrderingTerm.desc(table.updatedAt);
        },
        ($CustomExercisesTable table) {
          return OrderingTerm.asc(table.customExerciseId);
        },
      ],
  };
}

final class _CustomExerciseSqlFilter {
  const _CustomExerciseSqlFilter({
    required this.includeArchived,
    required this.searchText,
  });

  factory _CustomExerciseSqlFilter.fromQuery(CustomExerciseQuery query) {
    return _CustomExerciseSqlFilter(
      includeArchived: query.includeArchived,
      searchText: query.searchText,
    );
  }

  final bool includeArchived;
  final String? searchText;

  Expression<bool> expression($CustomExercisesTable table) {
    Expression<bool>? expression;

    if (!includeArchived) {
      expression = table.archivedAt.isNull();
    }

    final searchText = this.searchText;
    if (searchText != null) {
      final normalized = searchText.toLowerCase();
      final searchExpression =
          table.customExerciseId.lower().contains(normalized) |
          table.name.lower().contains(normalized) |
          table.notes.lower().contains(normalized) |
          table.primaryMusclesJson.lower().contains(normalized) |
          table.secondaryMusclesJson.lower().contains(normalized) |
          table.equipmentJson.lower().contains(normalized) |
          table.movementPatternsJson.lower().contains(normalized);
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
      clauses.add(
        '('
        'lower(custom_exercise_id) LIKE ? OR '
        'lower(name) LIKE ? OR '
        'lower(notes) LIKE ? OR '
        'lower(primary_muscles_json) LIKE ? OR '
        'lower(secondary_muscles_json) LIKE ? OR '
        'lower(equipment_json) LIKE ? OR '
        'lower(movement_patterns_json) LIKE ?'
        ')',
      );
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
      for (var index = 0; index < 7; index += 1) Variable<String>(pattern),
    ];
  }
}

String _encodeValues(Iterable<String> values) {
  return jsonEncode(values.toList(growable: false));
}

List<String> _decodeValues(String value) {
  final decoded = jsonDecode(value);
  if (decoded is! List) {
    throw const CatalogValidationException(
      'customExercise.tags',
      'Custom exercise tag storage must be a list.',
    );
  }
  return decoded.cast<String>();
}
