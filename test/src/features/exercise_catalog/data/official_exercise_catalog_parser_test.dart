import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/exercise_catalog/data/parsers/official_exercise_catalog_parser.dart';
import 'package:repforge/src/features/exercise_catalog/domain/exercise_catalog_domain.dart';

void main() {
  const parser = OfficialExerciseCatalogParser();

  test('parses the bundled official exercise catalog', () {
    final catalog = parser.parseString(
      File('assets/catalog/official_exercises_v1.json').readAsStringSync(),
    );

    expect(catalog.catalogVersion.value, '2026.05.0');
    expect(catalog.schemaVersion, 1);
    expect(catalog.exercises, hasLength(6));
    expect(catalog.exercises.first.id.value, 'barbell_back_squat');
    expect(catalog.exercises.first.englishName, 'Barbell Back Squat');
    expect(catalog.exercises.first.germanName, 'Kniebeuge mit Langhantel');
  });

  test('rejects duplicate official exercise ids', () {
    expect(
      () => parser.parseString(
        _catalogJson('''
          ${_exerciseJson(catalogId: 'duplicate_id')},
          ${_exerciseJson(catalogId: 'duplicate_id')}
          '''),
      ),
      throwsA(isA<CatalogValidationException>()),
    );
  });

  test('rejects missing or blank official exercise ids', () {
    expect(
      () => parser.parseString(_catalogJson(_exerciseJson(catalogId: '   '))),
      throwsA(isA<CatalogValidationException>()),
    );

    expect(
      () => parser.parseString(
        _catalogJson('''
          {
            "localizedNames": {"en": "Bench Press", "de": "Bankdruecken"},
            "equipment": ["barbell"],
            "movementPatterns": ["horizontal_push"],
            "primaryMuscles": ["chest"],
            "secondaryMuscles": ["triceps"]
          }
          '''),
      ),
      throwsA(isA<CatalogValidationException>()),
    );
  });

  test('rejects missing or blank localized names', () {
    expect(
      () => parser.parseString(_catalogJson(_exerciseJson(englishName: ''))),
      throwsA(isA<CatalogValidationException>()),
    );

    expect(
      () => parser.parseString(
        _catalogJson('''
          {
            "catalogId": "missing_german_name",
            "localizedNames": {"en": "Bench Press"},
            "equipment": ["barbell"],
            "movementPatterns": ["horizontal_push"],
            "primaryMuscles": ["chest"],
            "secondaryMuscles": ["triceps"]
          }
          '''),
      ),
      throwsA(isA<CatalogValidationException>()),
    );
  });

  test('validates catalog version and schema version', () {
    expect(
      () => parser.parseString('''
        {
          "schemaVersion": 1,
          "exercises": [${_exerciseJson()}]
        }
        '''),
      throwsA(isA<CatalogValidationException>()),
    );

    expect(
      () => parser.parseString('''
        {
          "catalogVersion": "2026.05.0",
          "schemaVersion": 99,
          "exercises": [${_exerciseJson()}]
        }
        '''),
      throwsA(isA<CatalogValidationException>()),
    );
  });

  test('rejects empty equipment and muscle metadata', () {
    expect(
      () =>
          parser.parseString(_catalogJson(_exerciseJson(equipmentJson: '[]'))),
      throwsA(isA<CatalogValidationException>()),
    );

    expect(
      () => parser.parseString(
        _catalogJson(_exerciseJson(primaryMusclesJson: '[]')),
      ),
      throwsA(isA<CatalogValidationException>()),
    );
  });
}

String _catalogJson(String exercisesJson) {
  return '''
  {
    "catalogVersion": "2026.05.0",
    "schemaVersion": 1,
    "exercises": [$exercisesJson]
  }
  ''';
}

String _exerciseJson({
  String catalogId = 'barbell_bench_press',
  String englishName = 'Barbell Bench Press',
  String germanName = 'Bankdruecken mit Langhantel',
  String equipmentJson = '["barbell", "bench"]',
  String primaryMusclesJson = '["chest"]',
}) {
  return '''
  {
    "catalogId": "$catalogId",
    "localizedNames": {
      "en": "$englishName",
      "de": "$germanName"
    },
    "equipment": $equipmentJson,
    "movementPatterns": ["horizontal_push"],
    "primaryMuscles": $primaryMusclesJson,
    "secondaryMuscles": ["triceps"]
  }
  ''';
}
