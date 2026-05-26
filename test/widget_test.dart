import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:repforge/main.dart';

void main() {
  testWidgets('starts with English placeholder by default', (tester) async {
    await tester.pumpWidget(const RepForgeApp());

    expect(find.text('RepForge'), findsAtLeastNWidgets(1));
    expect(
      find.text('Local-first workout tracking is being forged.'),
      findsOneWidget,
    );
  });

  testWidgets('supports German localization', (tester) async {
    await tester.pumpWidget(const RepForgeApp(locale: Locale('de')));

    expect(find.text('RepForge'), findsAtLeastNWidgets(1));
    expect(
      find.text('Lokales Workout-Tracking entsteht Schritt fuer Schritt.'),
      findsOneWidget,
    );
  });
}
