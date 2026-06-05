import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/analytics/presentation/analytics_presentation.dart';
import '../../features/exercise_catalog/presentation/exercise_catalog_presentation.dart';
import '../../features/onboarding/presentation/onboarding_presentation.dart';
import '../../features/settings/presentation/settings_presentation.dart';
import '../../features/today/presentation/today_presentation.dart';
import '../../features/training_log/domain/training_log_domain.dart';
import '../../features/training_log/presentation/training_log_presentation.dart';
import '../../features/workout_groups/presentation/workout_groups_presentation.dart';
import '../composition_root.dart';
import 'app_route.dart';
import 'navigation_shell.dart';

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
                    workoutSetRepository: dependencies.workoutSetRepository,
                    getTodayReadiness: dependencies.getTodayReadiness,
                  ),
                  logSetAction: (context) {
                    return _quickLogController(dependencies).show(context);
                  },
                ),
              );
            },
          ),
          _branch(
            route: AppRoute.groups,
            builder: (context, state) {
              return GroupsPage(
                loader: RepositoryTrainPageLoader(
                  groupLoader: RepositoryWorkoutGroupListLoader(
                    repository: dependencies.workoutGroupRepository,
                  ),
                  exerciseLoader: RepositoryExerciseCatalogListLoader(
                    repository: dependencies.exerciseCatalogRepository,
                    ensureCatalogImported:
                        dependencies.ensureOfficialCatalogImported,
                  ),
                ),
                onOpenExercise: (exerciseRef) {
                  context.push(
                    _exerciseDetailLocation(AppRoute.groups, exerciseRef),
                  );
                },
              );
            },
            routes: [_exerciseDetailRoute(dependencies)],
          ),
          _branch(
            route: AppRoute.exercises,
            builder: (context, state) {
              return ExercisesPage(
                loader: RepositoryExerciseCatalogListLoader(
                  repository: dependencies.exerciseCatalogRepository,
                  ensureCatalogImported:
                      dependencies.ensureOfficialCatalogImported,
                ),
                onOpenExercise: (exerciseRef) {
                  context.push(
                    _exerciseDetailLocation(AppRoute.exercises, exerciseRef),
                  );
                },
              );
            },
            routes: [_exerciseDetailRoute(dependencies)],
          ),
          _branch(
            route: AppRoute.analytics,
            builder: (context, state) {
              return AnalyticsPage(
                loader: UseCaseExerciseAnalyticsLoader(
                  getExerciseAnalytics: dependencies.getExerciseAnalytics,
                  exerciseRef: _defaultAnalyticsExerciseRef(),
                ),
                muscleLoadDashboardLoader: UseCaseMuscleLoadDashboardLoader(
                  getMuscleLoadDashboard: dependencies.getMuscleLoadDashboard,
                  ensureCatalogImported:
                      dependencies.ensureOfficialCatalogImported,
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

QuickLogSetController _quickLogController(AppDependencies dependencies) {
  return QuickLogSetController(
    exerciseCatalogRepository: dependencies.exerciseCatalogRepository,
    saveWorkoutSet: dependencies.saveWorkoutSet,
    ensureCatalogImported: dependencies.ensureOfficialCatalogImported,
  );
}

GoRoute _exerciseDetailRoute(AppDependencies dependencies) {
  return GoRoute(
    path: 'exercise/:source/:id',
    builder: (context, state) {
      final exerciseRef = _exerciseRefFromRoute(state);
      return ExerciseDetailPage(
        exerciseRef: exerciseRef,
        loader: RepositoryExerciseDetailLoader(
          exerciseCatalogRepository: dependencies.exerciseCatalogRepository,
          workoutSetRepository: dependencies.workoutSetRepository,
          getExerciseAnalytics: dependencies.getExerciseAnalytics,
          ensureCatalogImported: dependencies.ensureOfficialCatalogImported,
        ),
        onLogSet: (exerciseRef) {
          return _quickLogController(dependencies).show(context, exerciseRef);
        },
      );
    },
  );
}

String _exerciseDetailLocation(AppRoute parent, ExerciseRef exerciseRef) {
  return Uri(
    path:
        '${parent.path}/exercise/${exerciseRef.source.name}/${exerciseRef.id}',
    queryParameters: {
      'name': exerciseRef.displayNameSnapshot,
      if (exerciseRef.catalogVersionSnapshot != null)
        'catalogVersion': exerciseRef.catalogVersionSnapshot!,
    },
  ).toString();
}

ExerciseRef _exerciseRefFromRoute(GoRouterState state) {
  final source = state.pathParameters['source'];
  final id = state.pathParameters['id'];
  final displayName = state.uri.queryParameters['name'];
  if (source == null || id == null || displayName == null) {
    throw StateError('Exercise detail route is missing exercise reference.');
  }

  if (source == ExerciseSource.official.name) {
    return ExerciseRef.official(
      id: OfficialExerciseId(id),
      displayNameSnapshot: displayName,
      catalogVersionSnapshot: state.uri.queryParameters['catalogVersion'],
    );
  }

  return ExerciseRef.custom(
    id: CustomExerciseId(id),
    displayNameSnapshot: displayName,
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
  List<RouteBase> routes = const <RouteBase>[],
}) {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        name: route.name,
        path: route.path,
        builder: builder,
        routes: routes,
      ),
    ],
  );
}
