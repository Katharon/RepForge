import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:repforge/src/app/composition_root.dart';
import 'package:repforge/src/app/repforge_app.dart';

void main() {
  test('composition root creates app dependencies', () {
    const compositionRoot = CompositionRoot();

    final dependencies = compositionRoot.compose();

    expect(dependencies.configuration.locale, isNull);
  });

  testWidgets('starts with English placeholder by default', (tester) async {
    final dependencies = const CompositionRoot().compose();

    await tester.pumpWidget(RepForgeApp(dependencies: dependencies));

    expect(find.text('RepForge'), findsAtLeastNWidgets(1));
    expect(
      find.text('Local-first workout tracking is being forged.'),
      findsOneWidget,
    );
  });

  testWidgets('supports German localization', (tester) async {
    final dependencies = const CompositionRoot(
      configuration: AppConfiguration(locale: Locale('de')),
    ).compose();

    await tester.pumpWidget(RepForgeApp(dependencies: dependencies));

    expect(find.text('RepForge'), findsAtLeastNWidgets(1));
    expect(
      find.text('Lokales Workout-Tracking entsteht Schritt fuer Schritt.'),
      findsOneWidget,
    );
  });
}
