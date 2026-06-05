import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import 'workout_group_list_loader.dart';

enum WorkoutGroupUiStatus { loading, empty, error, success }

final class WorkoutGroupUiState {
  const WorkoutGroupUiState({required this.status, this.model, this.error});

  final WorkoutGroupUiStatus status;
  final WorkoutGroupListViewModel? model;
  final Object? error;
}

class GroupsPage extends StatefulWidget {
  const GroupsPage({required this.loader, super.key});

  final WorkoutGroupListLoader loader;

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  var _requestVersion = 0;
  WorkoutGroupUiState _state = const WorkoutGroupUiState(
    status: WorkoutGroupUiStatus.loading,
  );

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void didUpdateWidget(covariant GroupsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.loader != widget.loader) {
      unawaited(_load());
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(title: Text(localizations.navGroups)),
        AppResponsiveSliverList(
          maxWidth: 840,
          children: [_WorkoutGroupStateBody(state: _state, onRetry: _load)],
        ),
      ],
    );
  }

  Future<void> _load() async {
    final requestVersion = ++_requestVersion;
    setState(() {
      _state = const WorkoutGroupUiState(status: WorkoutGroupUiStatus.loading);
    });

    try {
      final model = await widget.loader.load();
      if (!mounted || requestVersion != _requestVersion) {
        return;
      }

      setState(() {
        _state = WorkoutGroupUiState(
          status: model.groups.isEmpty
              ? WorkoutGroupUiStatus.empty
              : WorkoutGroupUiStatus.success,
          model: model,
        );
      });
    } catch (error) {
      if (!mounted || requestVersion != _requestVersion) {
        return;
      }

      setState(() {
        _state = WorkoutGroupUiState(
          status: WorkoutGroupUiStatus.error,
          error: error,
        );
      });
    }
  }
}

class _WorkoutGroupStateBody extends StatelessWidget {
  const _WorkoutGroupStateBody({required this.state, required this.onRetry});

  final WorkoutGroupUiState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    switch (state.status) {
      case WorkoutGroupUiStatus.loading:
        return AppCard(
          child: Row(
            children: [
              const SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(width: RepForgeSpacing.md),
              Expanded(child: Text(localizations.groupsLoading)),
            ],
          ),
        );
      case WorkoutGroupUiStatus.empty:
        return _GroupInfoCard(
          icon: Icons.view_list_outlined,
          title: localizations.groupsEmptyTitle,
          message: localizations.groupsEmptyMessage,
        );
      case WorkoutGroupUiStatus.error:
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline, color: RepForgeColorTokens.error),
              const SizedBox(height: RepForgeSpacing.md),
              Text(
                localizations.groupsErrorTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: RepForgeSpacing.xs),
              Text(
                localizations.groupsErrorMessage,
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
      case WorkoutGroupUiStatus.success:
        return _GroupList(model: state.model!);
    }
  }
}

class _GroupList extends StatelessWidget {
  const _GroupList({required this.model});

  final WorkoutGroupListViewModel model;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          localizations.groupsCount(model.totalCount),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: RepForgeColorTokens.textSecondary,
          ),
        ),
        const SizedBox(height: RepForgeSpacing.md),
        for (final group in model.groups) ...[
          _GroupCard(group: group),
          const SizedBox(height: RepForgeSpacing.md),
        ],
        _GroupInfoCard(
          icon: Icons.auto_awesome_outlined,
          title: localizations.groupsCoachPreviewTitle,
          message: localizations.groupsCoachPreviewMessage,
        ),
      ],
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.group});

  final WorkoutGroupListItemViewModel group;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final preview = group.exerciseNames.take(3).join(', ');

    return Semantics(
      label: localizations.groupsSemanticsLabel(
        group.name,
        group.exerciseCount,
      ),
      child: AppCard(
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
      ),
    );
  }
}

class _GroupInfoCard extends StatelessWidget {
  const _GroupInfoCard({
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
