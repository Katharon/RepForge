import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/analytics/presentation/analytics_presentation.dart';
import '../../features/onboarding/presentation/onboarding_presentation.dart';
import '../../features/settings/presentation/settings_presentation.dart';
import '../../features/today/presentation/today_presentation.dart';
import '../../features/training_log/domain/training_log_domain.dart';
import '../composition_root.dart';
import '../localization/app_localizations.dart';
import 'app_route.dart';
import 'navigation_shell.dart';
import 'placeholder_destination_page.dart';

GoRouter createAppRouter({required AppDependencies dependencies}) {
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
              return OnboardingGate(
                loadOnboardingStatus: dependencies.loadOnboardingStatus,
                skipOnboarding: dependencies.skipOnboarding,
                completeOnboarding: dependencies.completeOnboarding,
                child: TodayPage(
                  loader: RestTimerTodayDashboardLoader(
                    restTimerNotifications: dependencies.restTimerNotifications,
                  ),
                ),
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
              return AnalyticsPage(
                loader: UseCaseExerciseAnalyticsLoader(
                  getExerciseAnalytics: dependencies.getExerciseAnalytics,
                  exerciseRef: _defaultAnalyticsExerciseRef(),
                ),
              );
            },
          ),
          _branch(
            route: AppRoute.settings,
            builder: (context, state) {
              return SettingsPage(
                loadSettings: dependencies.loadSettingsProfile,
                saveSettings: dependencies.saveSettingsProfile,
                resetSettings: dependencies.resetSettingsProfile,
              );
            },
          ),
        ],
      ),
    ],
  );
}

ExerciseRef _defaultAnalyticsExerciseRef() {
  return ExerciseRef.official(
    id: OfficialExerciseId('barbell_bench_press'),
    displayNameSnapshot: 'Barbell Bench Press',
    catalogVersionSnapshot: '1.0.0',
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
