import 'dart:convert';
import 'dart:io';

import 'package:repforge/src/features/exercise_catalog/data/parsers/official_exercise_catalog_manifest_parser.dart';
import 'package:repforge/src/features/exercise_catalog/data/parsers/official_exercise_catalog_parser.dart';
import 'package:repforge/src/features/exercise_catalog/domain/exercise_catalog_domain.dart';

final class CatalogPatchValidationIssue {
  const CatalogPatchValidationIssue({
    required this.code,
    required this.path,
    required this.message,
  });

  final String code;
  final String path;
  final String message;

  @override
  String toString() => '$code at $path: $message';
}

final class CatalogPatchValidationResult {
  const CatalogPatchValidationResult(this.issues);

  final List<CatalogPatchValidationIssue> issues;

  bool get isValid => issues.isEmpty;
}

final class CatalogPatchValidator {
  CatalogPatchValidator({
    Directory? rootDirectory,
    this.manifestPath = 'assets/catalog/catalog_manifest.json',
    this.stableIdsBaselinePath = 'tool/catalog_stable_ids_baseline.json',
    OfficialExerciseCatalogManifestParser? manifestParser,
    OfficialExerciseCatalogParser? catalogParser,
  }) : rootDirectory = rootDirectory ?? Directory.current,
       _manifestParser =
           manifestParser ?? const OfficialExerciseCatalogManifestParser(),
       _catalogParser = catalogParser ?? const OfficialExerciseCatalogParser();

  static const Set<String> knownEquipmentTags = <String>{
    'barbell',
    'bench',
    'cable_machine',
    'dumbbells',
    'lat_pulldown_station',
    'pull_up_bar',
    'rack',
  };

  static const Set<String> knownMovementPatterns = <String>{
    'accessory_pull',
    'accessory_push',
    'elbow_extension',
    'elbow_flexion',
    'hinge',
    'horizontal_pull',
    'horizontal_push',
    'knee_dominant',
    'lunge',
    'squat',
    'vertical_pull',
    'vertical_push',
  };

  static const Set<String> knownMuscleIds = <String>{
    'biceps',
    'chest',
    'core',
    'erector_spinae',
    'forearms',
    'front_deltoids',
    'glutes',
    'hamstrings',
    'lats',
    'quadriceps',
    'rear_deltoids',
    'shoulders',
    'traps',
    'triceps',
    'upper_back',
    'upper_chest',
  };

  static final RegExp catalogIdPattern = RegExp(
    r'^[a-z][a-z0-9]*(?:_[a-z0-9]+)*$',
  );

  final Directory rootDirectory;
  final String manifestPath;
  final String stableIdsBaselinePath;
  final OfficialExerciseCatalogManifestParser _manifestParser;
  final OfficialExerciseCatalogParser _catalogParser;

  CatalogPatchValidationResult validate() {
    final issues = <CatalogPatchValidationIssue>[];
    final manifestFile = _file(manifestPath);
    final manifest = _parseManifest(manifestFile, issues);
    if (manifest == null) {
      return CatalogPatchValidationResult(List.unmodifiable(issues));
    }

    final catalogFiles = _catalogFiles();
    if (catalogFiles.isEmpty) {
      issues.add(
        const CatalogPatchValidationIssue(
          code: 'catalog.assets.empty',
          path: 'assets/catalog',
          message:
              'At least one bundled official exercise catalog is required.',
        ),
      );
    }

    final currentCatalogFile = _file(manifest.currentCatalogAsset);
    if (!currentCatalogFile.existsSync()) {
      issues.add(
        CatalogPatchValidationIssue(
          code: 'catalog.manifest.missingAsset',
          path: manifest.currentCatalogAsset,
          message: 'Manifest currentCatalogAsset does not exist.',
        ),
      );
    }

    final parsedCatalogs = <String, OfficialExerciseCatalog>{};
    for (final file in catalogFiles) {
      final relativePath = _relativePath(file);
      final catalog = _parseCatalog(file, issues);
      if (catalog == null) {
        continue;
      }
      parsedCatalogs[relativePath] = catalog;
      _validateCatalogContent(file, catalog, issues);
      _validateRawCatalogContent(file, issues);
    }

    final currentCatalog = parsedCatalogs[manifest.currentCatalogAsset];
    if (currentCatalog != null) {
      if (manifest.catalogVersion != currentCatalog.catalogVersion) {
        issues.add(
          CatalogPatchValidationIssue(
            code: 'catalog.manifest.versionMismatch',
            path: manifest.currentCatalogAsset,
            message:
                'Manifest catalogVersion ${manifest.catalogVersion.value} '
                'does not match catalogVersion '
                '${currentCatalog.catalogVersion.value}.',
          ),
        );
      }
      if (manifest.schemaVersion != currentCatalog.schemaVersion) {
        issues.add(
          CatalogPatchValidationIssue(
            code: 'catalog.manifest.schemaMismatch',
            path: manifest.currentCatalogAsset,
            message:
                'Manifest schemaVersion ${manifest.schemaVersion} does not '
                'match catalog schemaVersion ${currentCatalog.schemaVersion}.',
          ),
        );
      }
      _validateStableIds(currentCatalog, issues);
    }

    return CatalogPatchValidationResult(List.unmodifiable(issues));
  }

  OfficialExerciseCatalogManifest? _parseManifest(
    File file,
    List<CatalogPatchValidationIssue> issues,
  ) {
    if (!file.existsSync()) {
      issues.add(
        CatalogPatchValidationIssue(
          code: 'catalog.manifest.missing',
          path: manifestPath,
          message: 'Catalog manifest is required.',
        ),
      );
      return null;
    }

    try {
      return _manifestParser.parseString(file.readAsStringSync());
    } on CatalogValidationException catch (error) {
      issues.add(
        CatalogPatchValidationIssue(
          code: 'catalog.manifest.invalid',
          path: manifestPath,
          message: '${error.field}: ${error.message}',
        ),
      );
      return null;
    }
  }

  OfficialExerciseCatalog? _parseCatalog(
    File file,
    List<CatalogPatchValidationIssue> issues,
  ) {
    final relativePath = _relativePath(file);
    try {
      return _catalogParser.parseString(file.readAsStringSync());
    } on CatalogValidationException catch (error) {
      issues.add(
        CatalogPatchValidationIssue(
          code: 'catalog.asset.invalid',
          path: relativePath,
          message: '${error.field}: ${error.message}',
        ),
      );
      return null;
    }
  }

  void _validateCatalogContent(
    File file,
    OfficialExerciseCatalog catalog,
    List<CatalogPatchValidationIssue> issues,
  ) {
    final relativePath = _relativePath(file);
    for (final exercise in catalog.exercises) {
      final exercisePath = '$relativePath#${exercise.id.value}';
      if (!catalogIdPattern.hasMatch(exercise.id.value)) {
        issues.add(
          CatalogPatchValidationIssue(
            code: 'catalog.exercise.idFormat',
            path: exercisePath,
            message:
                'Exercise id must be lowercase snake_case with digits allowed.',
          ),
        );
      }

      _validateKnownValues(
        code: 'catalog.exercise.unknownEquipment',
        path: '$exercisePath.equipment',
        values: exercise.equipment.map((tag) => tag.value),
        allowedValues: knownEquipmentTags,
        issues: issues,
      );
      _validateKnownValues(
        code: 'catalog.exercise.unknownMovementPattern',
        path: '$exercisePath.movementPatterns',
        values: exercise.movementPatterns.map((pattern) => pattern.value),
        allowedValues: knownMovementPatterns,
        issues: issues,
      );
      _validateKnownValues(
        code: 'catalog.exercise.unknownPrimaryMuscle',
        path: '$exercisePath.primaryMuscles',
        values: exercise.primaryMuscles.map((muscle) => muscle.value),
        allowedValues: knownMuscleIds,
        issues: issues,
      );
      _validateKnownValues(
        code: 'catalog.exercise.unknownSecondaryMuscle',
        path: '$exercisePath.secondaryMuscles',
        values: exercise.secondaryMuscles.map((muscle) => muscle.value),
        allowedValues: knownMuscleIds,
        issues: issues,
      );

      _validateNoDuplicates(
        code: 'catalog.exercise.duplicateEquipment',
        path: '$exercisePath.equipment',
        values: exercise.equipment.map((tag) => tag.value),
        issues: issues,
      );
      _validateNoDuplicates(
        code: 'catalog.exercise.duplicateMovementPattern',
        path: '$exercisePath.movementPatterns',
        values: exercise.movementPatterns.map((pattern) => pattern.value),
        issues: issues,
      );
      _validateNoDuplicates(
        code: 'catalog.exercise.duplicatePrimaryMuscle',
        path: '$exercisePath.primaryMuscles',
        values: exercise.primaryMuscles.map((muscle) => muscle.value),
        issues: issues,
      );
      _validateNoDuplicates(
        code: 'catalog.exercise.duplicateSecondaryMuscle',
        path: '$exercisePath.secondaryMuscles',
        values: exercise.secondaryMuscles.map((muscle) => muscle.value),
        issues: issues,
      );

      final primaryMuscles = exercise.primaryMuscles
          .map((muscle) => muscle.value)
          .toSet();
      for (final muscle in exercise.secondaryMuscles) {
        if (primaryMuscles.contains(muscle.value)) {
          issues.add(
            CatalogPatchValidationIssue(
              code: 'catalog.exercise.duplicateMuscleAcrossRoles',
              path: '$exercisePath.secondaryMuscles',
              message:
                  'Muscle ${muscle.value} appears in both primary and '
                  'secondary muscles.',
            ),
          );
        }
      }
    }
  }

  void _validateRawCatalogContent(
    File file,
    List<CatalogPatchValidationIssue> issues,
  ) {
    final relativePath = _relativePath(file);
    final Object? decoded;
    try {
      decoded = jsonDecode(file.readAsStringSync());
    } on FormatException catch (error) {
      issues.add(
        CatalogPatchValidationIssue(
          code: 'catalog.asset.invalidJson',
          path: relativePath,
          message: error.message,
        ),
      );
      return;
    }

    if (decoded is! Map<String, Object?>) {
      return;
    }
    final exercises = decoded['exercises'];
    if (exercises is! List<Object?>) {
      return;
    }

    for (var index = 0; index < exercises.length; index += 1) {
      final exercise = exercises[index];
      if (exercise is! Map<String, Object?>) {
        continue;
      }
      final id = exercise['catalogId'];
      final exercisePath = id is String && id.trim().isNotEmpty
          ? '$relativePath#${id.trim()}'
          : '$relativePath#exercises[$index]';

      _validateAliasField(exercise, 'aliases', exercisePath, issues);
      _validateAliasField(exercise, 'synonyms', exercisePath, issues);
      _validateActivationFields(exercise, exercisePath, issues);
    }
  }

  void _validateAliasField(
    Map<String, Object?> exercise,
    String field,
    String exercisePath,
    List<CatalogPatchValidationIssue> issues,
  ) {
    final value = exercise[field];
    if (value == null) {
      return;
    }
    if (value is! Map<String, Object?>) {
      issues.add(
        CatalogPatchValidationIssue(
          code: 'catalog.exercise.invalidAliases',
          path: '$exercisePath.$field',
          message: 'Aliases must be localized as en/de string arrays.',
        ),
      );
      return;
    }

    for (final locale in <String>['en', 'de']) {
      final aliases = value[locale];
      if (aliases == null) {
        continue;
      }
      if (aliases is! List<Object?>) {
        issues.add(
          CatalogPatchValidationIssue(
            code: 'catalog.exercise.invalidAliases',
            path: '$exercisePath.$field.$locale',
            message: 'Alias locale values must be string arrays.',
          ),
        );
        continue;
      }
      final normalized = <String>[];
      for (var index = 0; index < aliases.length; index += 1) {
        final alias = aliases[index];
        if (alias is! String || alias.trim().isEmpty) {
          issues.add(
            CatalogPatchValidationIssue(
              code: 'catalog.exercise.invalidAliases',
              path: '$exercisePath.$field.$locale[$index]',
              message: 'Alias values must be non-blank strings.',
            ),
          );
          continue;
        }
        normalized.add(alias.trim().toLowerCase());
      }
      _validateNoDuplicates(
        code: 'catalog.exercise.duplicateAlias',
        path: '$exercisePath.$field.$locale',
        values: normalized,
        issues: issues,
      );
    }
  }

  void _validateActivationFields(
    Map<String, Object?> exercise,
    String exercisePath,
    List<CatalogPatchValidationIssue> issues,
  ) {
    _validateActivationMap(exercise['activationProfile'], exercisePath, issues);
    _validateActivationMap(exercise['activationWeights'], exercisePath, issues);
    _validateActivationList(
      exercise['muscleActivations'],
      exercisePath,
      issues,
    );
  }

  void _validateActivationMap(
    Object? value,
    String exercisePath,
    List<CatalogPatchValidationIssue> issues,
  ) {
    if (value == null) {
      return;
    }
    if (value is! Map<String, Object?>) {
      issues.add(
        CatalogPatchValidationIssue(
          code: 'catalog.exercise.invalidActivation',
          path: '$exercisePath.activation',
          message: 'Activation weights must be a muscleId-to-number map.',
        ),
      );
      return;
    }
    for (final entry in value.entries) {
      _validateActivationEntry(
        muscleId: entry.key,
        weight: entry.value,
        path: '$exercisePath.activation.${entry.key}',
        issues: issues,
      );
    }
  }

  void _validateActivationList(
    Object? value,
    String exercisePath,
    List<CatalogPatchValidationIssue> issues,
  ) {
    if (value == null) {
      return;
    }
    if (value is! List<Object?>) {
      issues.add(
        CatalogPatchValidationIssue(
          code: 'catalog.exercise.invalidActivation',
          path: '$exercisePath.muscleActivations',
          message: 'muscleActivations must be an array.',
        ),
      );
      return;
    }
    final muscleIds = <String>[];
    for (var index = 0; index < value.length; index += 1) {
      final entry = value[index];
      if (entry is! Map<String, Object?>) {
        issues.add(
          CatalogPatchValidationIssue(
            code: 'catalog.exercise.invalidActivation',
            path: '$exercisePath.muscleActivations[$index]',
            message: 'Activation entries must be JSON objects.',
          ),
        );
        continue;
      }
      final muscleId = entry['muscleId'];
      final weight = entry['activationWeight'];
      if (muscleId is! String || muscleId.trim().isEmpty) {
        issues.add(
          CatalogPatchValidationIssue(
            code: 'catalog.exercise.invalidActivation',
            path: '$exercisePath.muscleActivations[$index].muscleId',
            message: 'Activation muscleId must be a non-blank string.',
          ),
        );
        continue;
      }
      muscleIds.add(muscleId.trim());
      _validateActivationEntry(
        muscleId: muscleId.trim(),
        weight: weight,
        path: '$exercisePath.muscleActivations[$index].activationWeight',
        issues: issues,
      );
    }
    _validateNoDuplicates(
      code: 'catalog.exercise.duplicateActivationMuscle',
      path: '$exercisePath.muscleActivations',
      values: muscleIds,
      issues: issues,
    );
  }

  void _validateActivationEntry({
    required String muscleId,
    required Object? weight,
    required String path,
    required List<CatalogPatchValidationIssue> issues,
  }) {
    if (!knownMuscleIds.contains(muscleId)) {
      issues.add(
        CatalogPatchValidationIssue(
          code: 'catalog.exercise.unknownActivationMuscle',
          path: path,
          message: 'Unknown activation muscle id: $muscleId.',
        ),
      );
    }
    if (weight is! num) {
      issues.add(
        CatalogPatchValidationIssue(
          code: 'catalog.exercise.invalidActivationWeight',
          path: path,
          message: 'Activation weight must be numeric.',
        ),
      );
      return;
    }
    if (weight < 0 || weight > 1) {
      issues.add(
        CatalogPatchValidationIssue(
          code: 'catalog.exercise.invalidActivationWeight',
          path: path,
          message: 'Activation weight must be within 0.0..1.0.',
        ),
      );
    }
  }

  void _validateStableIds(
    OfficialExerciseCatalog currentCatalog,
    List<CatalogPatchValidationIssue> issues,
  ) {
    final baselineFile = _file(stableIdsBaselinePath);
    if (!baselineFile.existsSync()) {
      return;
    }

    final Object? decoded;
    try {
      decoded = jsonDecode(baselineFile.readAsStringSync());
    } on FormatException catch (error) {
      issues.add(
        CatalogPatchValidationIssue(
          code: 'catalog.stableIds.invalidJson',
          path: stableIdsBaselinePath,
          message: error.message,
        ),
      );
      return;
    }
    if (decoded is! Map<String, Object?>) {
      issues.add(
        CatalogPatchValidationIssue(
          code: 'catalog.stableIds.invalid',
          path: stableIdsBaselinePath,
          message: 'Stable ID baseline must be a JSON object.',
        ),
      );
      return;
    }
    final ids = decoded['stableExerciseIds'];
    if (ids is! List<Object?>) {
      issues.add(
        CatalogPatchValidationIssue(
          code: 'catalog.stableIds.invalid',
          path: stableIdsBaselinePath,
          message: 'stableExerciseIds must be a JSON array.',
        ),
      );
      return;
    }

    final currentIds = currentCatalog.exercises
        .map((exercise) => exercise.id.value)
        .toSet();
    for (final id in ids) {
      if (id is! String || id.trim().isEmpty) {
        issues.add(
          CatalogPatchValidationIssue(
            code: 'catalog.stableIds.invalid',
            path: stableIdsBaselinePath,
            message: 'Stable exercise ids must be non-blank strings.',
          ),
        );
        continue;
      }
      if (!currentIds.contains(id.trim())) {
        issues.add(
          CatalogPatchValidationIssue(
            code: 'catalog.stableIds.removed',
            path: stableIdsBaselinePath,
            message:
                'Released official exercise id ${id.trim()} is missing from '
                'the current catalog. Deprecate instead of deleting/renaming.',
          ),
        );
      }
    }
  }

  void _validateKnownValues({
    required String code,
    required String path,
    required Iterable<String> values,
    required Set<String> allowedValues,
    required List<CatalogPatchValidationIssue> issues,
  }) {
    for (final value in values) {
      if (!allowedValues.contains(value)) {
        issues.add(
          CatalogPatchValidationIssue(
            code: code,
            path: path,
            message: 'Unsupported value: $value.',
          ),
        );
      }
    }
  }

  void _validateNoDuplicates({
    required String code,
    required String path,
    required Iterable<String> values,
    required List<CatalogPatchValidationIssue> issues,
  }) {
    final seen = <String>{};
    for (final value in values) {
      if (!seen.add(value)) {
        issues.add(
          CatalogPatchValidationIssue(
            code: code,
            path: path,
            message: 'Duplicate value: $value.',
          ),
        );
      }
    }
  }

  List<File> _catalogFiles() {
    final directory = Directory(_file('assets/catalog').path);
    if (!directory.existsSync()) {
      return const <File>[];
    }

    final files = directory.listSync().whereType<File>().where((file) {
      final path = _relativePath(file);
      return path.endsWith('.json') && path != manifestPath;
    }).toList();
    files.sort(
      (left, right) => _relativePath(left).compareTo(_relativePath(right)),
    );
    return List<File>.unmodifiable(files);
  }

  File _file(String relativePath) {
    return File('${rootDirectory.path}/$relativePath');
  }

  String _relativePath(File file) {
    final rootPath = rootDirectory.absolute.path;
    final filePath = file.absolute.path;
    if (filePath.startsWith('$rootPath/')) {
      return filePath.substring(rootPath.length + 1);
    }
    return file.path;
  }
}
