import 'package:drift/drift.dart';
import 'package:repforge/src/features/exercise_catalog/data/mappers/official_exercise_mapper.dart';
import 'package:repforge/src/features/exercise_catalog/domain/exercise_catalog_domain.dart';
import 'package:repforge/src/features/training_log/domain/value_objects/stable_ids.dart';
import 'package:repforge/src/shared/data/local/repforge_database.dart';

final class DriftExerciseCatalogRepository
    implements ExerciseCatalogRepository {
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
