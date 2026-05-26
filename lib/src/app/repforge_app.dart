import 'package:flutter/material.dart';

import '../core/theme/theme.dart';
import '../core/widgets/widgets.dart';
import 'composition_root.dart';
import 'localization/app_localizations.dart';

class RepForgeApp extends StatelessWidget {
  const RepForgeApp({required this.dependencies, super.key});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      locale: dependencies.configuration.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: RepForgeTheme.dark(),
      darkTheme: RepForgeTheme.dark(),
      themeMode: ThemeMode.dark,
      home: const HomePlaceholderPage(),
    );
  }
}

class HomePlaceholderPage extends StatelessWidget {
  const HomePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.appTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(RepForgeSpacing.xl),
          child: AppCard(
            padding: const EdgeInsets.all(RepForgeSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  localizations.homePlaceholderTitle,
                  style: Theme.of(context).textTheme.metricValue,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: RepForgeSpacing.md),
                Text(
                  localizations.homePlaceholderMessage,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
