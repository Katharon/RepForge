import 'package:flutter/services.dart';

import '../../application/starter_template_loader.dart';
import '../../domain/onboarding_domain.dart';
import 'starter_template_parser.dart';

final class AssetStarterTemplateLoader implements StarterTemplateLoader {
  AssetStarterTemplateLoader({
    this.assetPath = 'assets/templates/starter_groups_v1.json',
    AssetBundle? assetBundle,
    this.parser = const StarterTemplateParser(),
  }) : assetBundle = assetBundle ?? rootBundle;

  final String assetPath;
  final AssetBundle assetBundle;
  final StarterTemplateParser parser;

  @override
  Future<StarterTemplateCatalog> load() async {
    final source = await assetBundle.loadString(assetPath);
    return parser.parseString(source);
  }
}
