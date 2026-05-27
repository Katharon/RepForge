import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/theme.dart';
import 'composition_root.dart';
import 'localization/app_localizations.dart';
import 'navigation/app_router.dart';

class RepForgeApp extends StatefulWidget {
  const RepForgeApp({required this.dependencies, super.key});

  final AppDependencies dependencies;

  @override
  State<RepForgeApp> createState() => _RepForgeAppState();
}

class _RepForgeAppState extends State<RepForgeApp> {
  late final GoRouter _router = createAppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      locale: widget.dependencies.configuration.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: RepForgeTheme.dark(),
      darkTheme: RepForgeTheme.dark(),
      themeMode: ThemeMode.dark,
      routerConfig: _router,
    );
  }

  @override
  void dispose() {
    _router.dispose();
    unawaited(widget.dependencies.close());
    super.dispose();
  }
}
