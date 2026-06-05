import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/catalog_patch_validator.dart';

void main() {
  test('current bundled catalog validates successfully', () {
    final result = CatalogPatchValidator().validate();

    expect(result.issues, isEmpty);
  });

  test('manifest reference must point to an existing catalog asset', () {
    final workspace = _CatalogFixture.create();
    addTearDown(workspace.delete);
    workspace.writeManifest(currentCatalogAsset: 'assets/catalog/missing.json');

    final result = workspace.validate();

    expect(result, _hasIssue('catalog.manifest.missingAsset'));
  });

  test('manifest catalogVersion must match current catalog asset', () {
    final workspace = _CatalogFixture.create();
    addTearDown(workspace.delete);
    workspace.writeManifest(catalogVersion: '2026.07.0');

    final result = workspace.validate();

    expect(result, _hasIssue('catalog.manifest.versionMismatch'));
  });

  test('unsupported catalog schema version fails', () {
    final workspace = _CatalogFixture.create();
    addTearDown(workspace.delete);
    workspace.writeCatalog(schemaVersion: 99);

    final result = workspace.validate();

    expect(result, _hasIssue('catalog.asset.invalid'));
  });

  test('duplicate exercise id fails', () {
    final workspace = _CatalogFixture.create();
    addTearDown(workspace.delete);
    workspace.writeCatalog(exercises: [_exercise(), _exercise()]);

    final result = workspace.validate();

    expect(result, _hasIssue('catalog.asset.invalid'));
  });

  test('blank exercise id fails', () {
    final workspace = _CatalogFixture.create();
    addTearDown(workspace.delete);
    workspace.writeCatalog(exercises: [_exercise(catalogId: ' ')]);

    final result = workspace.validate();

    expect(result, _hasIssue('catalog.asset.invalid'));
  });

  test('id naming convention is enforced', () {
    final workspace = _CatalogFixture.create();
    addTearDown(workspace.delete);
    workspace.writeCatalog(exercises: [_exercise(catalogId: 'BenchPress')]);

    final result = workspace.validate();

    expect(result, _hasIssue('catalog.exercise.idFormat'));
  });

  test('missing English name fails', () {
    final workspace = _CatalogFixture.create();
    addTearDown(workspace.delete);
    workspace.writeCatalog(
      exercises: [
        _exercise(localizedNames: {'de': 'Bankdruecken mit Langhantel'}),
      ],
    );

    final result = workspace.validate();

    expect(result, _hasIssue('catalog.asset.invalid'));
  });

  test('missing German name fails', () {
    final workspace = _CatalogFixture.create();
    addTearDown(workspace.delete);
    workspace.writeCatalog(
      exercises: [
        _exercise(localizedNames: {'en': 'Barbell Bench Press'}),
      ],
    );

    final result = workspace.validate();

    expect(result, _hasIssue('catalog.asset.invalid'));
  });

  test('unknown equipment tag fails', () {
    final workspace = _CatalogFixture.create();
    addTearDown(workspace.delete);
    workspace.writeCatalog(
      exercises: [
        _exercise(equipment: ['space_station']),
      ],
    );

    final result = workspace.validate();

    expect(result, _hasIssue('catalog.exercise.unknownEquipment'));
  });

  test('missing equipment fails', () {
    final workspace = _CatalogFixture.create();
    addTearDown(workspace.delete);
    workspace.writeCatalog(exercises: [_exercise(equipment: <String>[])]);

    final result = workspace.validate();

    expect(result, _hasIssue('catalog.asset.invalid'));
  });

  test('unknown movement pattern fails', () {
    final workspace = _CatalogFixture.create();
    addTearDown(workspace.delete);
    workspace.writeCatalog(
      exercises: [
        _exercise(movementPatterns: ['sideways_push']),
      ],
    );

    final result = workspace.validate();

    expect(result, _hasIssue('catalog.exercise.unknownMovementPattern'));
  });

  test('missing primary muscles fails', () {
    final workspace = _CatalogFixture.create();
    addTearDown(workspace.delete);
    workspace.writeCatalog(exercises: [_exercise(primaryMuscles: <String>[])]);

    final result = workspace.validate();

    expect(result, _hasIssue('catalog.asset.invalid'));
  });

  test('unknown muscle id fails', () {
    final workspace = _CatalogFixture.create();
    addTearDown(workspace.delete);
    workspace.writeCatalog(
      exercises: [
        _exercise(primaryMuscles: ['wing']),
      ],
    );

    final result = workspace.validate();

    expect(result, _hasIssue('catalog.exercise.unknownPrimaryMuscle'));
  });

  test('duplicate equipment, movement, and muscle values fail', () {
    final workspace = _CatalogFixture.create();
    addTearDown(workspace.delete);
    workspace.writeCatalog(
      exercises: [
        _exercise(
          equipment: ['barbell', 'barbell'],
          movementPatterns: ['horizontal_push', 'horizontal_push'],
          primaryMuscles: ['chest', 'chest'],
          secondaryMuscles: ['triceps', 'triceps'],
        ),
      ],
    );

    final result = workspace.validate();

    expect(result, _hasIssue('catalog.exercise.duplicateEquipment'));
    expect(result, _hasIssue('catalog.exercise.duplicateMovementPattern'));
    expect(result, _hasIssue('catalog.exercise.duplicatePrimaryMuscle'));
    expect(result, _hasIssue('catalog.exercise.duplicateSecondaryMuscle'));
  });

  test('same muscle cannot appear as primary and secondary', () {
    final workspace = _CatalogFixture.create();
    addTearDown(workspace.delete);
    workspace.writeCatalog(
      exercises: [
        _exercise(primaryMuscles: ['chest'], secondaryMuscles: ['chest']),
      ],
    );

    final result = workspace.validate();

    expect(result, _hasIssue('catalog.exercise.duplicateMuscleAcrossRoles'));
  });

  test('aliases validate when present', () {
    final workspace = _CatalogFixture.create();
    addTearDown(workspace.delete);
    workspace.writeCatalog(
      exercises: [
        _exercise(
          extra: {
            'aliases': {
              'en': ['Bench'],
              'de': ['Bank'],
            },
          },
        ),
      ],
    );

    final result = workspace.validate();

    expect(result.issues, isEmpty);
  });

  test('duplicate alias fails', () {
    final workspace = _CatalogFixture.create();
    addTearDown(workspace.delete);
    workspace.writeCatalog(
      exercises: [
        _exercise(
          extra: {
            'aliases': {
              'en': ['Bench', 'bench'],
            },
          },
        ),
      ],
    );

    final result = workspace.validate();

    expect(result, _hasIssue('catalog.exercise.duplicateAlias'));
  });

  test('activation weights out of range fail when activation fields exist', () {
    final workspace = _CatalogFixture.create();
    addTearDown(workspace.delete);
    workspace.writeCatalog(
      exercises: [
        _exercise(
          extra: {
            'activationProfile': {'chest': 1.2},
          },
        ),
      ],
    );

    final result = workspace.validate();

    expect(result, _hasIssue('catalog.exercise.invalidActivationWeight'));
  });

  test('stable ID baseline detects removed official IDs', () {
    final workspace = _CatalogFixture.create();
    addTearDown(workspace.delete);
    workspace.writeStableIdsBaseline([
      'barbell_bench_press',
      'old_released_id',
    ]);

    final result = workspace.validate();

    expect(result, _hasIssue('catalog.stableIds.removed'));
  });
}

Matcher _hasIssue(String code) {
  return predicate<CatalogPatchValidationResult>(
    (result) => result.issues.any((issue) => issue.code == code),
    'has validation issue $code',
  );
}

final class _CatalogFixture {
  _CatalogFixture._(this.root);

  final Directory root;

  static _CatalogFixture create() {
    final root = Directory.systemTemp.createTempSync('repforge_catalog_test_');
    final fixture = _CatalogFixture._(root);
    Directory('${root.path}/assets/catalog').createSync(recursive: true);
    Directory('${root.path}/tool').createSync(recursive: true);
    fixture.writeManifest();
    fixture.writeCatalog();
    fixture.writeStableIdsBaseline(['barbell_bench_press']);
    return fixture;
  }

  CatalogPatchValidationResult validate() {
    return CatalogPatchValidator(rootDirectory: root).validate();
  }

  void writeManifest({
    String catalogVersion = '2026.06.0',
    int schemaVersion = 1,
    String currentCatalogAsset = 'assets/catalog/official_exercises_v1.json',
  }) {
    _writeJson('assets/catalog/catalog_manifest.json', {
      'catalogVersion': catalogVersion,
      'schemaVersion': schemaVersion,
      'currentCatalogAsset': currentCatalogAsset,
      'contentNotes': ['Fixture catalog patch.'],
    });
  }

  void writeCatalog({
    String catalogVersion = '2026.06.0',
    int schemaVersion = 1,
    List<Map<String, Object?>>? exercises,
  }) {
    _writeJson('assets/catalog/official_exercises_v1.json', {
      'catalogVersion': catalogVersion,
      'schemaVersion': schemaVersion,
      'exercises': exercises ?? [_exercise()],
    });
  }

  void writeStableIdsBaseline(List<String> ids) {
    _writeJson('tool/catalog_stable_ids_baseline.json', {
      'schemaVersion': 1,
      'releasedCatalogVersion': '2026.06.0',
      'stableExerciseIds': ids,
    });
  }

  void delete() {
    if (root.existsSync()) {
      root.deleteSync(recursive: true);
    }
  }

  void _writeJson(String relativePath, Map<String, Object?> json) {
    File(
      '${root.path}/$relativePath',
    ).writeAsStringSync(const JsonEncoder.withIndent('  ').convert(json));
  }
}

Map<String, Object?> _exercise({
  String catalogId = 'barbell_bench_press',
  Map<String, String>? localizedNames,
  List<String> equipment = const ['barbell', 'bench', 'rack'],
  List<String> movementPatterns = const ['horizontal_push'],
  List<String> primaryMuscles = const ['chest'],
  List<String> secondaryMuscles = const ['triceps', 'front_deltoids'],
  Map<String, Object?> extra = const <String, Object?>{},
}) {
  return <String, Object?>{
    'catalogId': catalogId,
    'localizedNames':
        localizedNames ??
        const {
          'en': 'Barbell Bench Press',
          'de': 'Bankdruecken mit Langhantel',
        },
    'equipment': equipment,
    'movementPatterns': movementPatterns,
    'primaryMuscles': primaryMuscles,
    'secondaryMuscles': secondaryMuscles,
    ...extra,
  };
}
