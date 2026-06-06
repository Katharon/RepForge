import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/analytics/presentation/analytics_presentation.dart';
import '../../features/exercise_catalog/domain/exercise_catalog_domain.dart';
import '../../features/exercise_catalog/presentation/exercise_catalog_presentation.dart';
import '../../features/onboarding/presentation/onboarding_presentation.dart';
import '../../features/settings/presentation/settings_presentation.dart';
import '../../features/today/presentation/today_presentation.dart';
import '../../features/training_log/domain/training_log_domain.dart';
import '../../features/training_log/presentation/training_log_presentation.dart';
import '../../features/workout_groups/domain/workout_groups_domain.dart';
import '../../features/workout_groups/presentation/workout_groups_presentation.dart';
import '../composition_root.dart';
import '../localization/app_localizations.dart';
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
                  workoutSessionController:
                      dependencies.workoutSessionController,
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
                    customExerciseRepository:
                        dependencies.customExerciseRepository,
                    ensureCatalogImported:
                        dependencies.ensureOfficialCatalogImported,
                  ),
                ),
                workoutSessionController: dependencies.workoutSessionController,
                onCreateWorkoutGroup: (availableExercises) {
                  return _createWorkoutGroup(
                    context,
                    dependencies,
                    availableExercises,
                  );
                },
                onEditWorkoutGroup: (group, availableExercises) {
                  return _editWorkoutGroup(
                    context,
                    dependencies,
                    group,
                    availableExercises,
                  );
                },
                onArchiveWorkoutGroup: (group, availableExercises) {
                  return _archiveWorkoutGroup(context, dependencies, group);
                },
                onOpenExercise: (exerciseRef) {
                  context.push(
                    _exerciseDetailLocation(AppRoute.groups, exerciseRef),
                  );
                },
              );
            },
            routes: [_exerciseDetailRoute(dependencies, AppRoute.groups)],
          ),
          _branch(
            route: AppRoute.exercises,
            builder: (context, state) {
              return ExercisesPage(
                loader: RepositoryExerciseCatalogListLoader(
                  repository: dependencies.exerciseCatalogRepository,
                  customExerciseRepository:
                      dependencies.customExerciseRepository,
                  ensureCatalogImported:
                      dependencies.ensureOfficialCatalogImported,
                ),
                onOpenExercise: (exerciseRef) {
                  context.push(
                    _exerciseDetailLocation(AppRoute.exercises, exerciseRef),
                  );
                },
                onCreateCustomExercise: () {
                  return _createCustomExercise(context, dependencies);
                },
                onEditCustomExercise: (exercise) {
                  return _editCustomExercise(context, dependencies, exercise);
                },
                onArchiveCustomExercise: (exercise) {
                  return _archiveCustomExercise(
                    context,
                    dependencies,
                    exercise,
                  );
                },
              );
            },
            routes: [_exerciseDetailRoute(dependencies, AppRoute.exercises)],
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

Future<bool> _createWorkoutGroup(
  BuildContext context,
  AppDependencies dependencies,
  List<ExerciseListItemViewModel> availableExercises,
) async {
  final draft = await showWorkoutGroupDialog(
    context: context,
    availableExercises: availableExercises,
  );
  if (draft == null) {
    return false;
  }
  final now = DateTime.now().toUtc();
  final groupId = WorkoutGroupId('group_${now.microsecondsSinceEpoch}');
  await dependencies.workoutGroupRepository.saveGroup(
    WorkoutGroup(
      id: groupId,
      name: WorkoutGroupName(draft.name),
      sortOrder: WorkoutGroupSortOrder(1000),
    ),
  );
  await _replaceWorkoutGroupAssignments(dependencies, groupId, draft.exercises);
  return true;
}

Future<bool> _editWorkoutGroup(
  BuildContext context,
  AppDependencies dependencies,
  WorkoutGroupListItemViewModel group,
  List<ExerciseListItemViewModel> availableExercises,
) async {
  final groupId = WorkoutGroupId(group.id);
  final existing = await dependencies.workoutGroupRepository.findGroupById(
    groupId,
  );
  if (existing == null || existing.archivedAt != null) {
    return false;
  }
  if (!context.mounted) {
    return false;
  }
  final draft = await showWorkoutGroupDialog(
    context: context,
    availableExercises: availableExercises,
    initialGroup: group,
  );
  if (draft == null) {
    return false;
  }
  await dependencies.workoutGroupRepository.saveGroup(
    WorkoutGroup(
      id: existing.id,
      name: WorkoutGroupName(draft.name),
      sortOrder: existing.sortOrder,
      archivedAt: existing.archivedAt,
    ),
  );
  await _replaceWorkoutGroupAssignments(
    dependencies,
    existing.id,
    draft.exercises,
  );
  return true;
}

Future<bool> _archiveWorkoutGroup(
  BuildContext context,
  AppDependencies dependencies,
  WorkoutGroupListItemViewModel group,
) async {
  final localizations = AppLocalizations.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(localizations.customFolderArchiveTitle),
        content: Text(localizations.customFolderArchiveMessage(group.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(localizations.customFolderCancel),
          ),
          FilledButton.icon(
            key: const Key('custom_folder_archive_confirm_button'),
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.archive_outlined),
            label: Text(localizations.customFolderArchiveConfirm),
          ),
        ],
      );
    },
  );
  if (confirmed != true) {
    return false;
  }
  await dependencies.workoutGroupRepository.archiveGroup(
    WorkoutGroupId(group.id),
    DateTime.now().toUtc(),
  );
  return true;
}

Future<void> _replaceWorkoutGroupAssignments(
  AppDependencies dependencies,
  WorkoutGroupId groupId,
  List<ExerciseListItemViewModel> exercises,
) async {
  final existing = await dependencies.workoutGroupRepository.listAssignments(
    groupId,
    WorkoutGroupAssignmentQuery(limit: 100, offset: 0),
  );
  for (final assignment in existing.items) {
    await dependencies.workoutGroupRepository.removeAssignment(assignment.id);
  }
  for (var index = 0; index < exercises.length; index += 1) {
    final exercise = exercises[index];
    await dependencies.workoutGroupRepository.saveAssignment(
      WorkoutGroupExerciseAssignment(
        id: WorkoutGroupExerciseAssignmentId('${groupId.value}_$index'),
        workoutGroupId: groupId,
        exerciseRef: exercise.toExerciseRef(),
        position: AssignmentPosition(index),
      ),
    );
  }
}

Future<bool> _createCustomExercise(
  BuildContext context,
  AppDependencies dependencies,
) async {
  final draft = await showCustomExerciseDialog(context: context);
  if (draft == null) {
    return false;
  }
  final now = DateTime.now().toUtc();
  await dependencies.customExerciseRepository.saveCustomExercise(
    _customExerciseFromDraft(
      id: CustomExerciseId('custom_${now.microsecondsSinceEpoch}'),
      draft: draft,
      createdAt: now,
      updatedAt: now,
    ),
  );
  return true;
}

Future<bool> _editCustomExercise(
  BuildContext context,
  AppDependencies dependencies,
  ExerciseListItemViewModel exercise,
) async {
  if (!exercise.isCustom) {
    return false;
  }
  final id = CustomExerciseId(exercise.id);
  final existing = await dependencies.customExerciseRepository
      .findCustomExerciseById(id);
  if (existing == null || existing.isArchived) {
    return false;
  }
  if (!context.mounted) {
    return false;
  }
  final draft = await showCustomExerciseDialog(
    context: context,
    initialExercise: existing,
  );
  if (draft == null) {
    return false;
  }
  await dependencies.customExerciseRepository.saveCustomExercise(
    _customExerciseFromDraft(
      id: id,
      draft: draft,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now().toUtc(),
      archivedAt: existing.archivedAt,
    ),
  );
  return true;
}

Future<bool> _archiveCustomExercise(
  BuildContext context,
  AppDependencies dependencies,
  ExerciseListItemViewModel exercise,
) async {
  if (!exercise.isCustom) {
    return false;
  }
  final localizations = AppLocalizations.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(localizations.customExerciseArchiveTitle),
        content: Text(
          localizations.customExerciseArchiveMessage(exercise.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(localizations.customExerciseCancel),
          ),
          FilledButton.icon(
            key: const Key('custom_exercise_archive_confirm_button'),
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.archive_outlined),
            label: Text(localizations.customExerciseArchiveConfirm),
          ),
        ],
      );
    },
  );
  if (confirmed != true) {
    return false;
  }
  await dependencies.customExerciseRepository.archiveCustomExercise(
    CustomExerciseId(exercise.id),
    DateTime.now().toUtc(),
  );
  return true;
}

CustomExercise _customExerciseFromDraft({
  required CustomExerciseId id,
  required CustomExerciseDraft draft,
  required DateTime createdAt,
  required DateTime updatedAt,
  DateTime? archivedAt,
}) {
  return CustomExercise(
    id: id,
    name: draft.name,
    notes: draft.notes,
    primaryMuscles: draft.primaryMuscles.map(MuscleGroup.new),
    secondaryMuscles: draft.secondaryMuscles.map(MuscleGroup.new),
    equipment: draft.equipment.map(EquipmentTag.new),
    movementPatterns: draft.movementPatterns.map(MovementPattern.new),
    archivedAt: archivedAt,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

QuickLogSetController _quickLogController(AppDependencies dependencies) {
  return QuickLogSetController(
    exerciseCatalogRepository: dependencies.exerciseCatalogRepository,
    customExerciseRepository: dependencies.customExerciseRepository,
    saveWorkoutSet: dependencies.saveWorkoutSet,
    ensureCatalogImported: dependencies.ensureOfficialCatalogImported,
    workoutSessionController: dependencies.workoutSessionController,
  );
}

GoRoute _exerciseDetailRoute(
  AppDependencies dependencies,
  AppRoute parentRoute,
) {
  return GoRoute(
    path: 'exercise/:source/:id',
    builder: (context, state) {
      final exerciseRef = _exerciseRefFromRoute(state);
      return ExerciseDetailPage(
        exerciseRef: exerciseRef,
        loader: RepositoryExerciseDetailLoader(
          exerciseCatalogRepository: dependencies.exerciseCatalogRepository,
          customExerciseRepository: dependencies.customExerciseRepository,
          workoutSetRepository: dependencies.workoutSetRepository,
          getExerciseAnalytics: dependencies.getExerciseAnalytics,
          ensureCatalogImported: dependencies.ensureOfficialCatalogImported,
        ),
        adaptiveSuggestionLoader:
            RepositoryExerciseDetailAdaptiveSuggestionLoader(
              workoutSetRepository: dependencies.workoutSetRepository,
              exerciseCatalogRepository: dependencies.exerciseCatalogRepository,
              loadTodayReadiness: dependencies.getTodayReadiness.call,
              loadSettingsProfile: dependencies.loadSettingsProfile.call,
              ensureCatalogImported: dependencies.ensureOfficialCatalogImported,
            ),
        workoutSessionController: dependencies.workoutSessionController,
        onLogSet: (exerciseRef) {
          return _quickLogController(dependencies).show(context, exerciseRef);
        },
        onOpenAnalytics: (exerciseRef, initialMetric) {
          context.push(
            _exerciseAnalyticsLocation(parentRoute, exerciseRef, initialMetric),
          );
        },
      );
    },
    routes: [
      GoRoute(
        path: 'analytics',
        builder: (context, state) {
          final exerciseRef = _exerciseRefFromRoute(state);
          final initialMetric = _analyticsMetricFromRoute(state);
          return ExerciseAnalyticsChartPage(
            exerciseRef: exerciseRef,
            title: exerciseRef.displayNameSnapshot,
            initialMetric: initialMetric,
            loader: RepositoryExerciseAnalyticsChartLoader(
              workoutSetRepository: dependencies.workoutSetRepository,
              exerciseRef: exerciseRef,
              title: exerciseRef.displayNameSnapshot,
            ),
          );
        },
      ),
    ],
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

String _exerciseAnalyticsLocation(
  AppRoute parent,
  ExerciseRef exerciseRef,
  AnalyticsMetric initialMetric,
) {
  return Uri(
    path:
        '${parent.path}/exercise/${exerciseRef.source.name}/${exerciseRef.id}'
        '/analytics',
    queryParameters: {
      'name': exerciseRef.displayNameSnapshot,
      'metric': initialMetric.name,
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

AnalyticsMetric _analyticsMetricFromRoute(GoRouterState state) {
  final metricName = state.uri.queryParameters['metric'];
  return AnalyticsMetric.values.firstWhere(
    (metric) => metric.name == metricName,
    orElse: () => AnalyticsMetric.volumeKg,
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
