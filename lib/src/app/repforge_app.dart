import 'package:flutter/material.dart';

import '../core/theme/theme.dart';
import 'composition_root.dart';
import 'localization/app_localizations.dart';
import 'navigation/app_router.dart';

class RepForgeApp extends StatelessWidget {
  const RepForgeApp({required this.dependencies, super.key});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      locale: dependencies.configuration.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: RepForgeTheme.dark(),
      darkTheme: RepForgeTheme.dark(),
      themeMode: ThemeMode.dark,
      routerConfig: createAppRouter(),
    );
  }
}
