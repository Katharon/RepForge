import 'dart:convert';

import '../../domain/onboarding_domain.dart';

final class StarterTemplateParser {
  const StarterTemplateParser();

  StarterTemplateCatalog parseString(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, Object?>) {
      throw const OnboardingValidationException(
        'root',
        'Starter template root must be an object.',
      );
    }
    return parseMap(decoded);
  }

  StarterTemplateCatalog parseMap(Map<String, Object?> map) {
    return StarterTemplateCatalog(
      templateVersion: _requiredString(map, 'templateVersion'),
      groups: _requiredList(map, 'groups').map(_group),
    );
  }

  StarterGroupTemplate _group(Object? value) {
    final map = _requiredMap(value, 'group');
    return StarterGroupTemplate(
      id: _requiredString(map, 'id'),
      name: _requiredString(map, 'name'),
      exercises: _requiredList(map, 'exercises').map(_exercise),
    );
  }

  StarterExerciseTemplate _exercise(Object? value) {
    final map = _requiredMap(value, 'exercise');
    return StarterExerciseTemplate(
      catalogId: _requiredString(map, 'catalogId'),
      displayNameSnapshot: _requiredString(map, 'displayNameSnapshot'),
      catalogVersionSnapshot: _requiredString(map, 'catalogVersionSnapshot'),
    );
  }
}

String _requiredString(Map<String, Object?> map, String key) {
  final value = map[key];
  if (value is! String || value.trim().isEmpty) {
    throw OnboardingValidationException(key, 'Must be a non-empty string.');
  }
  return value.trim();
}

List<Object?> _requiredList(Map<String, Object?> map, String key) {
  final value = map[key];
  if (value is! List<Object?> || value.isEmpty) {
    throw OnboardingValidationException(key, 'Must be a non-empty list.');
  }
  return value;
}

Map<String, Object?> _requiredMap(Object? value, String key) {
  if (value is! Map<String, Object?>) {
    throw OnboardingValidationException(key, 'Must be an object.');
  }
  return value;
}
