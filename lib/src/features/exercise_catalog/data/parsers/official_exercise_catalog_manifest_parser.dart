import 'dart:convert';

import '../../domain/exercise_catalog_domain.dart';
import '../../domain/value_objects/catalog_validation.dart';

final class OfficialExerciseCatalogManifest {
  OfficialExerciseCatalogManifest({
    required this.catalogVersion,
    required this.schemaVersion,
    required String currentCatalogAsset,
    Iterable<String> contentNotes = const <String>[],
  }) : currentCatalogAsset = _requireCatalogAssetPath(currentCatalogAsset),
       contentNotes = List<String>.unmodifiable(
         contentNotes.map((note) => requireCatalogText('contentNotes[]', note)),
       );

  final CatalogVersion catalogVersion;
  final int schemaVersion;
  final String currentCatalogAsset;
  final List<String> contentNotes;
}

final class OfficialExerciseCatalogManifestParser {
  const OfficialExerciseCatalogManifestParser();

  static const int supportedSchemaVersion = 1;

  OfficialExerciseCatalogManifest parseString(String source) {
    final Object? decoded;
    try {
      decoded = jsonDecode(source);
    } on FormatException catch (error) {
      throw CatalogValidationException(
        'catalogManifestJson',
        'Invalid JSON: ${error.message}',
      );
    }

    return parseDecoded(decoded);
  }

  OfficialExerciseCatalogManifest parseDecoded(Object? decoded) {
    final root = _requireObject('catalogManifest', decoded);
    final schemaVersion = _requireInt(root, 'schemaVersion');

    if (schemaVersion != supportedSchemaVersion) {
      throw CatalogValidationException(
        'schemaVersion',
        'Unsupported catalog manifest schema version: $schemaVersion.',
      );
    }

    return OfficialExerciseCatalogManifest(
      catalogVersion: CatalogVersion(_requireString(root, 'catalogVersion')),
      schemaVersion: schemaVersion,
      currentCatalogAsset: _requireString(root, 'currentCatalogAsset'),
      contentNotes: _optionalStringList(root, 'contentNotes'),
    );
  }
}

String _requireCatalogAssetPath(String value) {
  final path = requireCatalogText('currentCatalogAsset', value);
  if (!path.startsWith('assets/catalog/') || !path.endsWith('.json')) {
    throw CatalogValidationException(
      'currentCatalogAsset',
      'Catalog asset must reference a JSON file under assets/catalog/.',
    );
  }

  return path;
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
