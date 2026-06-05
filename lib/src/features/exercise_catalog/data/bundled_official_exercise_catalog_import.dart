import 'package:flutter/services.dart';

import 'importers/official_exercise_catalog_importer.dart';
import 'parsers/official_exercise_catalog_manifest_parser.dart';
import 'parsers/official_exercise_catalog_parser.dart';

final class BundledOfficialExerciseCatalogImport {
  BundledOfficialExerciseCatalogImport({
    required this.importer,
    AssetBundle? assetBundle,
    this.manifestAssetPath = 'assets/catalog/catalog_manifest.json',
    this.manifestParser = const OfficialExerciseCatalogManifestParser(),
    this.catalogParser = const OfficialExerciseCatalogParser(),
  }) : assetBundle = assetBundle ?? rootBundle;

  final OfficialExerciseCatalogImporter importer;
  final AssetBundle assetBundle;
  final String manifestAssetPath;
  final OfficialExerciseCatalogManifestParser manifestParser;
  final OfficialExerciseCatalogParser catalogParser;

  Future<void> call() async {
    final manifestSource = await assetBundle.loadString(manifestAssetPath);
    final manifest = manifestParser.parseString(manifestSource);
    final catalogSource = await assetBundle.loadString(
      manifest.currentCatalogAsset,
    );
    final catalog = catalogParser.parseString(catalogSource);

    await importer.importCatalog(catalog);
  }
}
