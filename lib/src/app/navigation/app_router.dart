import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../localization/app_localizations.dart';
import 'app_route.dart';
import 'navigation_shell.dart';
import 'placeholder_destination_page.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoute.initial.path,
    routes: [
      GoRoute(path: '/', redirect: (_, _) => AppRoute.initial.path),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return NavigationShell(navigationShell: navigationShell);
        },
        branches: [
          _branch(
            route: AppRoute.today,
            builder: (context, state) {
              final localizations = AppLocalizations.of(context);
              return PlaceholderDestinationPage(
                title: localizations.navToday,
                message: localizations.todayPlaceholderMessage,
              );
            },
          ),
          _branch(
            route: AppRoute.groups,
            builder: (context, state) {
              final localizations = AppLocalizations.of(context);
              return PlaceholderDestinationPage(
                title: localizations.navGroups,
                message: localizations.groupsPlaceholderMessage,
              );
            },
          ),
          _branch(
            route: AppRoute.exercises,
            builder: (context, state) {
              final localizations = AppLocalizations.of(context);
              return PlaceholderDestinationPage(
                title: localizations.navExercises,
                message: localizations.exercisesPlaceholderMessage,
              );
            },
          ),
          _branch(
            route: AppRoute.analytics,
            builder: (context, state) {
              final localizations = AppLocalizations.of(context);
              return PlaceholderDestinationPage(
                title: localizations.navAnalytics,
                message: localizations.analyticsPlaceholderMessage,
              );
            },
          ),
          _branch(
            route: AppRoute.settings,
            builder: (context, state) {
              final localizations = AppLocalizations.of(context);
              return PlaceholderDestinationPage(
                title: localizations.navSettings,
                message: localizations.settingsPlaceholderMessage,
              );
            },
          ),
        ],
      ),
    ],
  );
}

StatefulShellBranch _branch({
  required AppRoute route,
  required Widget Function(BuildContext, GoRouterState) builder,
}) {
  return StatefulShellBranch(
    routes: [GoRoute(name: route.name, path: route.path, builder: builder)],
  );
}
