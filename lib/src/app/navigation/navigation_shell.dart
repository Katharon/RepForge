import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../localization/app_localizations.dart';

class NavigationShell extends StatelessWidget {
  const NavigationShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.today_outlined,
              semanticLabel: localizations.navToday,
            ),
            selectedIcon: Icon(
              Icons.today,
              semanticLabel: localizations.navToday,
            ),
            label: localizations.navToday,
          ),
          NavigationDestination(
            icon: Icon(
              Icons.view_list_outlined,
              semanticLabel: localizations.navGroups,
            ),
            selectedIcon: Icon(
              Icons.view_list,
              semanticLabel: localizations.navGroups,
            ),
            label: localizations.navGroups,
          ),
          NavigationDestination(
            icon: Icon(
              Icons.fitness_center_outlined,
              semanticLabel: localizations.navExercises,
            ),
            selectedIcon: Icon(
              Icons.fitness_center,
              semanticLabel: localizations.navExercises,
            ),
            label: localizations.navExercises,
          ),
          NavigationDestination(
            icon: Icon(
              Icons.insights_outlined,
              semanticLabel: localizations.navAnalytics,
            ),
            selectedIcon: Icon(
              Icons.insights,
              semanticLabel: localizations.navAnalytics,
            ),
            label: localizations.navAnalytics,
          ),
          NavigationDestination(
            icon: Icon(
              Icons.settings_outlined,
              semanticLabel: localizations.navSettings,
            ),
            selectedIcon: Icon(
              Icons.settings,
              semanticLabel: localizations.navSettings,
            ),
            label: localizations.navSettings,
          ),
        ],
      ),
    );
  }
}
