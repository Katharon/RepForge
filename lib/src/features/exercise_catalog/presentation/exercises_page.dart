import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../training_log/domain/training_log_domain.dart';
import 'exercise_catalog_loader.dart';

enum ExerciseCatalogUiStatus { loading, empty, error, success }

final class ExerciseCatalogUiState {
  const ExerciseCatalogUiState({
    required this.status,
    this.model,
    this.error,
    this.searchText,
  });

  final ExerciseCatalogUiStatus status;
  final ExerciseCatalogListViewModel? model;
  final Object? error;
  final String? searchText;
}

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({required this.loader, super.key, this.onOpenExercise});

  final ExerciseCatalogListLoader loader;
  final ValueChanged<ExerciseRef>? onOpenExercise;

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  final TextEditingController _searchController = TextEditingController();
  var _requestVersion = 0;
  ExerciseCatalogUiState _state = const ExerciseCatalogUiState(
    status: ExerciseCatalogUiStatus.loading,
  );

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
  void didUpdateWidget(covariant ExercisesPage oldWidget) {
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

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(title: Text(localizations.navExercises)),
        AppResponsiveSliverList(
          maxWidth: 840,
          children: [
            _ExerciseSearchBar(
              controller: _searchController,
              onSearch: () => _load(searchText: _searchController.text),
            ),
            const SizedBox(height: RepForgeSpacing.lg),
            _ExerciseCatalogStateBody(
              state: _state,
              onRetry: _load,
              onOpenExercise: widget.onOpenExercise,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _load({String? searchText}) async {
    final requestVersion = ++_requestVersion;
    final normalizedSearch = searchText?.trim();
    setState(() {
      _state = ExerciseCatalogUiState(
        status: ExerciseCatalogUiStatus.loading,
        searchText: normalizedSearch,
      );
    });

    try {
      final model = await widget.loader.load(
        searchText: normalizedSearch,
        locale: Localizations.localeOf(context),
      );
      if (!mounted || requestVersion != _requestVersion) {
        return;
      }

      setState(() {
        _state = ExerciseCatalogUiState(
          status: model.exercises.isEmpty
              ? ExerciseCatalogUiStatus.empty
              : ExerciseCatalogUiStatus.success,
          model: model,
          searchText: normalizedSearch,
        );
      });
    } catch (error) {
      if (!mounted || requestVersion != _requestVersion) {
        return;
      }

      setState(() {
        _state = ExerciseCatalogUiState(
          status: ExerciseCatalogUiStatus.error,
          error: error,
          searchText: normalizedSearch,
        );
      });
    }
  }
}

class _ExerciseSearchBar extends StatelessWidget {
  const _ExerciseSearchBar({required this.controller, required this.onSearch});

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
              key: const Key('exercise_catalog_search_field'),
              controller: controller,
              decoration: InputDecoration(
                labelText: localizations.exercisesSearchLabel,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => onSearch(),
            ),
          ),
          const SizedBox(width: RepForgeSpacing.md),
          IconButton.filled(
            key: const Key('exercise_catalog_search_button'),
            onPressed: onSearch,
            icon: const Icon(Icons.search),
            tooltip: localizations.exercisesSearchTooltip,
          ),
        ],
      ),
    );
  }
}

class _ExerciseCatalogStateBody extends StatelessWidget {
  const _ExerciseCatalogStateBody({
    required this.state,
    required this.onRetry,
    required this.onOpenExercise,
  });

  final ExerciseCatalogUiState state;
  final VoidCallback onRetry;
  final ValueChanged<ExerciseRef>? onOpenExercise;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    switch (state.status) {
      case ExerciseCatalogUiStatus.loading:
        return AppCard(
          child: Row(
            children: [
              const SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(width: RepForgeSpacing.md),
              Expanded(child: Text(localizations.exercisesLoading)),
            ],
          ),
        );
      case ExerciseCatalogUiStatus.empty:
        return _ExerciseInfoCard(
          icon: Icons.fitness_center_outlined,
          title: localizations.exercisesEmptyTitle,
          message: localizations.exercisesEmptyMessage,
        );
      case ExerciseCatalogUiStatus.error:
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline, color: RepForgeColorTokens.error),
              const SizedBox(height: RepForgeSpacing.md),
              Text(
                localizations.exercisesErrorTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: RepForgeSpacing.xs),
              Text(
                localizations.exercisesErrorMessage,
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
      case ExerciseCatalogUiStatus.success:
        return _ExerciseList(
          model: state.model!,
          onOpenExercise: onOpenExercise,
        );
    }
  }
}

class _ExerciseList extends StatelessWidget {
  const _ExerciseList({required this.model, required this.onOpenExercise});

  final ExerciseCatalogListViewModel model;
  final ValueChanged<ExerciseRef>? onOpenExercise;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          localizations.exercisesCount(model.totalCount),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: RepForgeColorTokens.textSecondary,
          ),
        ),
        const SizedBox(height: RepForgeSpacing.md),
        for (final exercise in model.exercises) ...[
          _ExerciseCard(exercise: exercise, onOpenExercise: onOpenExercise),
          const SizedBox(height: RepForgeSpacing.md),
        ],
        if (model.hasMore)
          _ExerciseInfoCard(
            icon: Icons.more_horiz,
            title: localizations.exercisesMoreTitle,
            message: localizations.exercisesMoreMessage,
          ),
      ],
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({required this.exercise, required this.onOpenExercise});

  final ExerciseListItemViewModel exercise;
  final ValueChanged<ExerciseRef>? onOpenExercise;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: exercise.name,
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
                Text(
                  exercise.name,
                  style: Theme.of(context).textTheme.titleMedium,
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

class _ExerciseInfoCard extends StatelessWidget {
  const _ExerciseInfoCard({
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

String _formatTag(String tag) {
  return tag
      .replaceAll('_', ' ')
      .split(' ')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}
