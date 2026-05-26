import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:repforge/src/app/composition_root.dart';
import 'package:repforge/src/app/repforge_app.dart';
import 'package:repforge/src/core/theme/theme.dart';
import 'package:repforge/src/core/widgets/widgets.dart';

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
    expect(find.byType(AppCard), findsOneWidget);
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

  testWidgets('applies the dark RepForge theme', (tester) async {
    final dependencies = const CompositionRoot().compose();

    await tester.pumpWidget(RepForgeApp(dependencies: dependencies));

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    final theme = materialApp.theme;
    final metricColors = theme?.extension<RepForgeMetricColors>();

    expect(materialApp.themeMode, ThemeMode.dark);
    expect(theme?.brightness, Brightness.dark);
    expect(
      theme?.scaffoldBackgroundColor,
      RepForgeColorTokens.backgroundPrimary,
    );
    expect(theme?.colorScheme.primary, RepForgeColorTokens.accentPrimaryGreen);
    expect(metricColors?.volume, RepForgeColorTokens.metricVolumeBlue);
  });

  testWidgets('AppCard renders themed card styling', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: RepForgeTheme.dark(),
        home: const Scaffold(body: AppCard(child: Text('Card content'))),
      ),
    );

    expect(find.byType(AppCard), findsOneWidget);
    expect(find.text('Card content'), findsOneWidget);

    final decoratedBox = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(AppCard),
        matching: find.byType(DecoratedBox),
      ),
    );
    final decoration = decoratedBox.decoration as BoxDecoration;

    expect(decoration.color, RepForgeColorTokens.surfaceCard);
    expect(decoration.borderRadius, BorderRadius.circular(RepForgeRadius.lg));
  });
}
