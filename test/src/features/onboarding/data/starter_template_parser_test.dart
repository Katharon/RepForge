import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:repforge/src/features/onboarding/data/templates/starter_template_parser.dart';
import 'package:repforge/src/features/onboarding/domain/onboarding_domain.dart';

void main() {
  test('accepts bundled starter group template data', () {
    final catalog = const StarterTemplateParser().parseString(
      File('assets/templates/starter_groups_v1.json').readAsStringSync(),
    );

    expect(catalog.templateVersion, '2026.06.0');
    expect(catalog.groups, hasLength(2));
    expect(
      catalog.groups.first.exercises.first.catalogId,
      'barbell_back_squat',
    );
  });

  test('rejects invalid starter template data deterministically', () {
    expect(
      () => const StarterTemplateParser().parseString('{"groups": []}'),
      throwsA(
        isA<OnboardingValidationException>().having(
          (error) => error.field,
          'field',
          'templateVersion',
        ),
      ),
    );
  });
}
