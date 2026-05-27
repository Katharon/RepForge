import 'dart:convert';

import '../../../training_log/domain/value_objects/stable_ids.dart';
import '../../domain/exercise_catalog_domain.dart';
import '../../domain/value_objects/catalog_validation.dart';

final class OfficialExerciseCatalogParser {
  const OfficialExerciseCatalogParser();

  static const int supportedSchemaVersion = 1;

  OfficialExerciseCatalog parseString(String source) {
    final Object? decoded;
    try {
      decoded = jsonDecode(source);
    } on FormatException catch (error) {
      throw CatalogValidationException(
        'catalogJson',
        'Invalid JSON: ${error.message}',
      );
    }

    return parseDecoded(decoded);
  }

  OfficialExerciseCatalog parseDecoded(Object? decoded) {
    final root = _requireObject('catalog', decoded);
    final catalogVersion = CatalogVersion(
      _requireString(root, 'catalogVersion'),
    );
    final schemaVersion = _requireInt(root, 'schemaVersion');

    if (schemaVersion != supportedSchemaVersion) {
      throw CatalogValidationException(
        'schemaVersion',
        'Unsupported catalog schema version: $schemaVersion.',
      );
    }

    final exerciseMaps = _requireObjectList(root, 'exercises');
    final seenIds = <String>{};
    final exercises = <OfficialExercise>[];

    for (var index = 0; index < exerciseMaps.length; index += 1) {
      final exercise = _parseExercise(
        exerciseMaps[index],
        catalogVersion,
        index,
      );
      if (!seenIds.add(exercise.id.value)) {
        throw CatalogValidationException(
          'exercises[$index].catalogId',
          'Duplicate official exercise id: ${exercise.id.value}.',
        );
      }

      exercises.add(exercise);
    }

    return OfficialExerciseCatalog(
      catalogVersion: catalogVersion,
      schemaVersion: schemaVersion,
      exercises: exercises,
    );
  }

  OfficialExercise _parseExercise(
    Map<String, Object?> map,
    CatalogVersion catalogVersion,
    int index,
  ) {
    final names = _requireObject(
      'exercises[$index].localizedNames',
      map['localizedNames'],
    );

    return OfficialExercise(
      id: OfficialExerciseId(_requireString(map, 'catalogId')),
      catalogVersion: catalogVersion,
      englishName: _requireString(names, 'en'),
      germanName: _requireString(names, 'de'),
      equipment: _requireStringList(map, 'equipment').map(EquipmentTag.new),
      movementPatterns: _requireStringList(
        map,
        'movementPatterns',
      ).map(MovementPattern.new),
      primaryMuscles: _requireStringList(
        map,
        'primaryMuscles',
      ).map(MuscleGroup.new),
      secondaryMuscles: _optionalStringList(
        map,
        'secondaryMuscles',
      ).map(MuscleGroup.new),
    );
  }
}

Map<String, Object?> _requireObject(String field, Object? value) {
  if (value is Map<String, Object?>) {
    return value;
  }

  throw CatalogValidationException(field, 'Expected a JSON object.');
}

String _requireString(Map<String, Object?> map, String key) {
  final value = map[key];
  if (value is String) {
    return requireCatalogText(key, value);
  }

  throw CatalogValidationException(key, 'Expected a string value.');
}

int _requireInt(Map<String, Object?> map, String key) {
  final value = map[key];
  if (value is int) {
    return value;
  }

  throw CatalogValidationException(key, 'Expected an integer value.');
}

List<Map<String, Object?>> _requireObjectList(
  Map<String, Object?> map,
  String key,
) {
  final value = map[key];
  if (value is! List<Object?>) {
    throw CatalogValidationException(key, 'Expected a JSON array.');
  }

  if (value.isEmpty) {
    throw CatalogValidationException(key, 'At least one value is required.');
  }

  return List<Map<String, Object?>>.unmodifiable(
    value.indexed.map((entry) {
      final index = entry.$1;
      final item = entry.$2;
      return _requireObject('$key[$index]', item);
    }),
  );
}

List<String> _requireStringList(Map<String, Object?> map, String key) {
  final values = _optionalStringList(map, key);
  if (values.isEmpty) {
    throw CatalogValidationException(key, 'At least one value is required.');
  }

  return values;
}

List<String> _optionalStringList(Map<String, Object?> map, String key) {
  final value = map[key];
  if (value == null) {
    return const <String>[];
  }

  if (value is! List<Object?>) {
    throw CatalogValidationException(key, 'Expected a JSON string array.');
  }

  return List<String>.unmodifiable(
    value.indexed.map((entry) {
      final index = entry.$1;
      final item = entry.$2;
      if (item is! String) {
        throw CatalogValidationException(
          '$key[$index]',
          'Expected a string value.',
        );
      }

      return requireCatalogText('$key[$index]', item);
    }),
  );
}
