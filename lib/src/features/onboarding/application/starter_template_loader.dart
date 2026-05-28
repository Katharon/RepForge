import '../domain/onboarding_domain.dart';

abstract interface class StarterTemplateLoader {
  Future<StarterTemplateCatalog> load();
}
