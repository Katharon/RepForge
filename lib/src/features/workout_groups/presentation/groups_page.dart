import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../exercise_catalog/presentation/exercise_catalog_presentation.dart';
import '../../training_log/application/training_log_application.dart';
import '../../training_log/domain/training_log_domain.dart';
import '../../training_log/presentation/training_log_presentation.dart';
import 'workout_group_list_loader.dart';

enum TrainUiStatus { loading, empty, error, success }

final class TrainUiState {
  const TrainUiState({required this.status, this.model, this.error});

  final TrainUiStatus status;
  final TrainLandingViewModel? model;
  final Object? error;
}

class GroupsPage extends StatefulWidget {
  const GroupsPage({
    required this.loader,
    super.key,
    this.workoutSessionController,
    this.onOpenExercise,
  });

  final TrainPageLoader loader;
  final WorkoutSessionController? workoutSessionController;
  final ValueChanged<ExerciseRef>? onOpenExercise;

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final TextEditingController _searchController = TextEditingController();
  var _requestVersion = 0;
  TrainCategoryId? _selectedCategoryId;
  String _categorySearchText = '';
  TrainUiState _state = const TrainUiState(status: TrainUiStatus.loading);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(_load());
      }
    });
  }

  @override
  void didUpdateWidget(covariant GroupsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.loader != widget.loader) {
      unawaited(_load());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final selectedCategory = _selectedCategory(_state.model);

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: Text(
            selectedCategory == null
                ? localizations.navGroups
                : _categoryTitle(context, selectedCategory.id),
          ),
        ),
        AppResponsiveSliverList(
          maxWidth: 840,
          children: [
            _TrainStateBody(
              state: _state,
              selectedCategory: selectedCategory,
              searchController: _searchController,
              searchText: _categorySearchText,
              onRetry: _load,
              onOpenCategory: _openCategory,
              onBackToCategories: _backToCategories,
              onSearch: _applyCategorySearch,
              workoutSessionController: widget.workoutSessionController,
              onStartSession: _startSession,
              onOpenExercise: widget.onOpenExercise,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _load() async {
    final requestVersion = ++_requestVersion;
    setState(() {
      _state = const TrainUiState(status: TrainUiStatus.loading);
    });

    try {
      final model = await widget.loader.load(
        locale: Localizations.localeOf(context),
      );
      if (!mounted || requestVersion != _requestVersion) {
        return;
      }

      setState(() {
        _state = TrainUiState(
          status: model.isEmpty ? TrainUiStatus.empty : TrainUiStatus.success,
          model: model,
        );
      });
    } catch (error) {
      if (!mounted || requestVersion != _requestVersion) {
        return;
      }

      setState(() {
        _state = TrainUiState(status: TrainUiStatus.error, error: error);
      });
    }
  }

  void _openCategory(TrainCategoryId id) {
    setState(() {
      _selectedCategoryId = id;
      _categorySearchText = '';
      _searchController.clear();
    });
  }

  void _backToCategories() {
    setState(() {
      _selectedCategoryId = null;
      _categorySearchText = '';
      _searchController.clear();
    });
  }

  void _applyCategorySearch() {
    setState(() {
      _categorySearchText = _searchController.text.trim();
    });
  }

  TrainCategoryViewModel? _selectedCategory(TrainLandingViewModel? model) {
    final selectedCategoryId = _selectedCategoryId;
    if (model == null || selectedCategoryId == null) {
      return null;
    }

    for (final category in model.categories) {
      if (category.id == selectedCategoryId) {
        return category;
      }
    }
    return null;
  }

  Future<void> _startSession(TrainCategoryViewModel category) async {
    final controller = widget.workoutSessionController;
    if (controller == null) {
      return;
    }
    await controller.start(
      sourceName: _categoryTitle(context, category.id),
      exerciseRefs: category.exercises.map(_exerciseRefFor),
    );
  }
}

class _TrainStateBody extends StatelessWidget {
  const _TrainStateBody({
    required this.state,
    required this.selectedCategory,
    required this.searchController,
    required this.searchText,
    required this.onRetry,
    required this.onOpenCategory,
    required this.onBackToCategories,
    required this.onSearch,
    required this.workoutSessionController,
    required this.onStartSession,
    required this.onOpenExercise,
  });

  final TrainUiState state;
  final TrainCategoryViewModel? selectedCategory;
  final TextEditingController searchController;
  final String searchText;
  final VoidCallback onRetry;
  final ValueChanged<TrainCategoryId> onOpenCategory;
  final VoidCallback onBackToCategories;
  final VoidCallback onSearch;
  final WorkoutSessionController? workoutSessionController;
  final ValueChanged<TrainCategoryViewModel> onStartSession;
  final ValueChanged<ExerciseRef>? onOpenExercise;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    switch (state.status) {
      case TrainUiStatus.loading:
        return AppCard(
          child: Row(
            children: [
              const SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(width: RepForgeSpacing.md),
              Expanded(child: Text(localizations.trainLoading)),
            ],
          ),
        );
      case TrainUiStatus.empty:
        return _TrainInfoCard(
          icon: Icons.fitness_center_outlined,
          title: localizations.trainEmptyTitle,
          message: localizations.trainEmptyMessage,
        );
      case TrainUiStatus.error:
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline, color: RepForgeColorTokens.error),
              const SizedBox(height: RepForgeSpacing.md),
              Text(
                localizations.trainErrorTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: RepForgeSpacing.xs),
              Text(
                localizations.trainErrorMessage,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: RepForgeColorTokens.textSecondary,
                ),
              ),
              const SizedBox(height: RepForgeSpacing.md),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(localizations.todayRetry),
              ),
            ],
          ),
        );
      case TrainUiStatus.success:
        final category = selectedCategory;
        if (category != null) {
          return _TrainCategoryExerciseList(
            category: category,
            searchController: searchController,
            searchText: searchText,
            onBack: onBackToCategories,
            onSearch: onSearch,
            workoutSessionController: workoutSessionController,
            onStartSession: onStartSession,
            onOpenExercise: onOpenExercise,
          );
        }
        return _TrainLanding(
          model: state.model!,
          onOpenCategory: onOpenCategory,
        );
    }
  }
}

class _TrainLanding extends StatelessWidget {
  const _TrainLanding({required this.model, required this.onOpenCategory});

  final TrainLandingViewModel model;
  final ValueChanged<TrainCategoryId> onOpenCategory;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _NewWorkoutCard(),
        const SizedBox(height: RepForgeSpacing.lg),
        Text(
          localizations.trainSplitsTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: RepForgeSpacing.md),
        for (final category in model.categories) ...[
          _TrainCategoryCard(
            category: category,
            onTap: () => onOpenCategory(category.id),
          ),
          const SizedBox(height: RepForgeSpacing.md),
        ],
        if (model.groups.isNotEmpty) ...[
          const SizedBox(height: RepForgeSpacing.sm),
          Text(
            localizations.trainStarterGroupsTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: RepForgeSpacing.md),
          for (final group in model.groups.take(4)) ...[
            _StarterGroupCard(group: group),
            const SizedBox(height: RepForgeSpacing.md),
          ],
        ],
      ],
    );
  }
}

class _NewWorkoutCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilledButton.icon(
            onPressed: null,
            icon: const Icon(Icons.add),
            label: Text(localizations.trainNewWorkout),
          ),
          const SizedBox(height: RepForgeSpacing.sm),
          Text(
            localizations.trainNewWorkoutUnavailable,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: RepForgeColorTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrainCategoryCard extends StatelessWidget {
  const _TrainCategoryCard({required this.category, required this.onTap});

  final TrainCategoryViewModel category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final title = _categoryTitle(context, category.id);

    return Semantics(
      button: true,
      label: localizations.trainCategorySemanticsLabel(
        title,
        category.exerciseCount,
      ),
      child: AppCard(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(RepForgeRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(RepForgeSpacing.xs),
            child: Row(
              children: [
                _CategoryIcon(id: category.id),
                const SizedBox(width: RepForgeSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: RepForgeSpacing.xs),
                      Text(
                        _categoryDescription(context, category.id),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: RepForgeColorTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: RepForgeSpacing.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      localizations.trainExerciseCount(category.exerciseCount),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: RepForgeSpacing.xs),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({required this.id});

  final TrainCategoryId id;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: RepForgeColorTokens.accentPrimaryGreen.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(RepForgeRadius.md),
        border: Border.all(color: RepForgeColorTokens.borderSubtle),
      ),
      child: Icon(
        _categoryIcon(id),
        color: RepForgeColorTokens.accentPrimaryGreen,
      ),
    );
  }
}

class _TrainCategoryExerciseList extends StatelessWidget {
  const _TrainCategoryExerciseList({
    required this.category,
    required this.searchController,
    required this.searchText,
    required this.onBack,
    required this.onSearch,
    required this.workoutSessionController,
    required this.onStartSession,
    required this.onOpenExercise,
  });

  final TrainCategoryViewModel category;
  final TextEditingController searchController;
  final String searchText;
  final VoidCallback onBack;
  final VoidCallback onSearch;
  final WorkoutSessionController? workoutSessionController;
  final ValueChanged<TrainCategoryViewModel> onStartSession;
  final ValueChanged<ExerciseRef>? onOpenExercise;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final normalizedSearch = searchText.toLowerCase();
    final exercises = normalizedSearch.isEmpty
        ? category.exercises
        : category.exercises
              .where((exercise) {
                return exercise.name.toLowerCase().contains(normalizedSearch) ||
                    exercise.equipment.any(
                      (tag) => tag.toLowerCase().contains(normalizedSearch),
                    ) ||
                    exercise.movementPatterns.any(
                      (tag) => tag.toLowerCase().contains(normalizedSearch),
                    ) ||
                    exercise.primaryMuscles.any(
                      (tag) => tag.toLowerCase().contains(normalizedSearch),
                    ) ||
                    exercise.secondaryMuscles.any(
                      (tag) => tag.toLowerCase().contains(normalizedSearch),
                    );
              })
              .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
            label: Text(localizations.trainBackToSplits),
          ),
        ),
        const SizedBox(height: RepForgeSpacing.md),
        if (workoutSessionController != null) ...[
          _TrainSessionCard(
            category: category,
            controller: workoutSessionController!,
            onStart: () => onStartSession(category),
          ),
          const SizedBox(height: RepForgeSpacing.md),
        ],
        _TrainCategorySearchBar(
          controller: searchController,
          onSearch: onSearch,
        ),
        const SizedBox(height: RepForgeSpacing.lg),
        Text(
          localizations.trainExerciseCount(exercises.length),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: RepForgeColorTokens.textSecondary,
          ),
        ),
        const SizedBox(height: RepForgeSpacing.md),
        if (exercises.isEmpty)
          _TrainInfoCard(
            icon: Icons.search_off,
            title: localizations.trainCategoryEmptyTitle,
            message: localizations.trainCategoryEmptyMessage,
          )
        else
          for (final exercise in exercises) ...[
            _TrainExerciseCard(
              exercise: exercise,
              onOpenExercise: onOpenExercise,
            ),
            const SizedBox(height: RepForgeSpacing.md),
          ],
      ],
    );
  }
}

class _TrainSessionCard extends StatelessWidget {
  const _TrainSessionCard({
    required this.category,
    required this.controller,
    required this.onStart,
  });

  final TrainCategoryViewModel category;
  final WorkoutSessionController controller;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return StreamBuilder<WorkoutSessionSnapshot>(
      stream: controller.changes,
      initialData: controller.snapshot,
      builder: (context, snapshot) {
        final sessionState = snapshot.data ?? const WorkoutSessionSnapshot();
        if (sessionState.active != null ||
            sessionState.completedSummary != null) {
          return WorkoutSessionStatusCard(controller: controller);
        }

        final title = _categoryTitle(context, category.id);
        return Semantics(
          label: localizations.workoutSessionStartSemantics(title),
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.workoutSessionNoActiveTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: RepForgeSpacing.xs),
                Text(
                  localizations.workoutSessionStartMessage(
                    title,
                    category.exerciseCount,
                  ),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: RepForgeColorTokens.textSecondary,
                  ),
                ),
                const SizedBox(height: RepForgeSpacing.md),
                FilledButton.icon(
                  key: const Key('train_start_workout_button'),
                  onPressed: onStart,
                  icon: const Icon(Icons.play_arrow),
                  label: Text(localizations.workoutSessionStart),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TrainCategorySearchBar extends StatelessWidget {
  const _TrainCategorySearchBar({
    required this.controller,
    required this.onSearch,
  });

  final TextEditingController controller;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              key: const Key('train_category_search_field'),
              controller: controller,
              decoration: InputDecoration(
                labelText: localizations.trainSearchLabel,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => onSearch(),
            ),
          ),
          const SizedBox(width: RepForgeSpacing.md),
          IconButton.filled(
            key: const Key('train_category_search_button'),
            onPressed: onSearch,
            icon: const Icon(Icons.search),
            tooltip: localizations.trainSearchTooltip,
          ),
        ],
      ),
    );
  }
}

class _TrainExerciseCard extends StatelessWidget {
  const _TrainExerciseCard({
    required this.exercise,
    required this.onOpenExercise,
  });

  final ExerciseListItemViewModel exercise;
  final ValueChanged<ExerciseRef>? onOpenExercise;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Semantics(
      label: localizations.trainExerciseSemanticsLabel(exercise.name),
      button: onOpenExercise != null,
      child: AppCard(
        child: InkWell(
          onTap: onOpenExercise == null
              ? null
              : () => onOpenExercise!(_exerciseRefFor(exercise)),
          borderRadius: BorderRadius.circular(RepForgeRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(RepForgeSpacing.xs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        exercise.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(width: RepForgeSpacing.md),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                const SizedBox(height: RepForgeSpacing.sm),
                Wrap(
                  spacing: RepForgeSpacing.sm,
                  runSpacing: RepForgeSpacing.sm,
                  children: [
                    for (final tag in [
                      ...exercise.equipment.take(2),
                      ...exercise.movementPatterns.take(1),
                      ...exercise.primaryMuscles.take(2),
                    ])
                      InputChip(label: Text(_formatTag(tag))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

ExerciseRef _exerciseRefFor(ExerciseListItemViewModel exercise) {
  return ExerciseRef.official(
    id: OfficialExerciseId(exercise.id),
    displayNameSnapshot: exercise.name,
    catalogVersionSnapshot: exercise.catalogVersionSnapshot,
  );
}

class _StarterGroupCard extends StatelessWidget {
  const _StarterGroupCard({required this.group});

  final WorkoutGroupListItemViewModel group;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final preview = group.exerciseNames.take(3).join(', ');

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(group.name, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: RepForgeSpacing.xs),
          Text(
            localizations.groupsExerciseCount(group.exerciseCount),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: RepForgeColorTokens.textSecondary,
            ),
          ),
          if (preview.isNotEmpty) ...[
            const SizedBox(height: RepForgeSpacing.sm),
            Text(preview, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}

class _TrainInfoCard extends StatelessWidget {
  const _TrainInfoCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(height: RepForgeSpacing.md),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: RepForgeSpacing.xs),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: RepForgeColorTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

String _categoryTitle(BuildContext context, TrainCategoryId id) {
  final localizations = AppLocalizations.of(context);
  return switch (id) {
    TrainCategoryId.myExercises => localizations.trainCategoryMyExercises,
    TrainCategoryId.fullBody => localizations.trainCategoryFullBody,
    TrainCategoryId.upperBody => localizations.trainCategoryUpperBody,
    TrainCategoryId.lowerBody => localizations.trainCategoryLowerBody,
    TrainCategoryId.push => localizations.trainCategoryPush,
    TrainCategoryId.pull => localizations.trainCategoryPull,
    TrainCategoryId.legs => localizations.trainCategoryLegs,
    TrainCategoryId.core => localizations.trainCategoryCore,
  };
}

String _categoryDescription(BuildContext context, TrainCategoryId id) {
  final localizations = AppLocalizations.of(context);
  return switch (id) {
    TrainCategoryId.myExercises =>
      localizations.trainCategoryMyExercisesDescription,
    TrainCategoryId.fullBody => localizations.trainCategoryFullBodyDescription,
    TrainCategoryId.upperBody =>
      localizations.trainCategoryUpperBodyDescription,
    TrainCategoryId.lowerBody =>
      localizations.trainCategoryLowerBodyDescription,
    TrainCategoryId.push => localizations.trainCategoryPushDescription,
    TrainCategoryId.pull => localizations.trainCategoryPullDescription,
    TrainCategoryId.legs => localizations.trainCategoryLegsDescription,
    TrainCategoryId.core => localizations.trainCategoryCoreDescription,
  };
}

IconData _categoryIcon(TrainCategoryId id) {
  return switch (id) {
    TrainCategoryId.myExercises => Icons.fitness_center,
    TrainCategoryId.fullBody => Icons.grid_view,
    TrainCategoryId.upperBody => Icons.keyboard_double_arrow_up,
    TrainCategoryId.lowerBody => Icons.keyboard_double_arrow_down,
    TrainCategoryId.push => Icons.north_east,
    TrainCategoryId.pull => Icons.south_west,
    TrainCategoryId.legs => Icons.directions_run,
    TrainCategoryId.core => Icons.hexagon_outlined,
  };
}

String _formatTag(String tag) {
  return tag
      .replaceAll('_', ' ')
      .split(' ')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}
