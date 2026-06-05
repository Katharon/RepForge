import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../training_log/domain/training_log_domain.dart';
import 'exercise_detail_loader.dart';

typedef ExerciseDetailLogSetAction =
    Future<bool> Function(ExerciseRef exerciseRef);

enum ExerciseDetailUiStatus { loading, empty, error, success }

final class ExerciseDetailUiState {
  const ExerciseDetailUiState({required this.status, this.model, this.error});

  final ExerciseDetailUiStatus status;
  final ExerciseDetailViewModel? model;
  final Object? error;
}

class ExerciseDetailPage extends StatefulWidget {
  const ExerciseDetailPage({
    required this.exerciseRef,
    required this.loader,
    required this.onLogSet,
    super.key,
  });

  final ExerciseRef exerciseRef;
  final ExerciseDetailLoader loader;
  final ExerciseDetailLogSetAction onLogSet;

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  var _requestVersion = 0;
  ExerciseDetailUiState _state = const ExerciseDetailUiState(
    status: ExerciseDetailUiStatus.loading,
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
  void didUpdateWidget(covariant ExerciseDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.loader != widget.loader ||
        oldWidget.exerciseRef != widget.exerciseRef) {
      unawaited(_load());
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final title = _state.model?.title ?? widget.exerciseRef.displayNameSnapshot;

    return Scaffold(
      floatingActionButton: _state.model == null
          ? null
          : Semantics(
              label: localizations.exerciseDetailLogSetSemantics(title),
              button: true,
              child: FloatingActionButton.extended(
                key: const Key('exercise_detail_log_set_button'),
                onPressed: _logSet,
                icon: const Icon(Icons.add),
                label: Text(localizations.todayQuickActionLogSet),
              ),
            ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(title: Text(title)),
          AppResponsiveSliverList(
            maxWidth: 840,
            children: [_ExerciseDetailStateBody(state: _state, onRetry: _load)],
          ),
        ],
      ),
    );
  }

  Future<void> _load() async {
    final requestVersion = ++_requestVersion;
    setState(() {
      _state = const ExerciseDetailUiState(
        status: ExerciseDetailUiStatus.loading,
      );
    });

    try {
      final model = await widget.loader.load(
        widget.exerciseRef,
        locale: Localizations.localeOf(context),
      );
      if (!mounted || requestVersion != _requestVersion) {
        return;
      }

      setState(() {
        _state = ExerciseDetailUiState(
          status: model.hasHistory
              ? ExerciseDetailUiStatus.success
              : ExerciseDetailUiStatus.empty,
          model: model,
        );
      });
    } catch (error) {
      if (!mounted || requestVersion != _requestVersion) {
        return;
      }

      setState(() {
        _state = ExerciseDetailUiState(
          status: ExerciseDetailUiStatus.error,
          error: error,
        );
      });
    }
  }

  Future<void> _logSet() async {
    final exerciseRef = _state.model?.exerciseRef ?? widget.exerciseRef;
    final saved = await widget.onLogSet(exerciseRef);
    if (!mounted || !saved) {
      return;
    }
    await _load();
  }
}

class _ExerciseDetailStateBody extends StatelessWidget {
  const _ExerciseDetailStateBody({required this.state, required this.onRetry});

  final ExerciseDetailUiState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    switch (state.status) {
      case ExerciseDetailUiStatus.loading:
        return AppCard(
          child: Row(
            children: [
              const SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(width: RepForgeSpacing.md),
              Expanded(child: Text(localizations.exerciseDetailLoading)),
            ],
          ),
        );
      case ExerciseDetailUiStatus.error:
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline, color: RepForgeColorTokens.error),
              const SizedBox(height: RepForgeSpacing.md),
              Text(
                localizations.exerciseDetailErrorTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: RepForgeSpacing.xs),
              Text(
                localizations.exerciseDetailErrorMessage,
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
      case ExerciseDetailUiStatus.empty:
      case ExerciseDetailUiStatus.success:
        final model = state.model!;
        return _ExerciseDetailContent(model: model);
    }
  }
}

class _ExerciseDetailContent extends StatelessWidget {
  const _ExerciseDetailContent({required this.model});

  final ExerciseDetailViewModel model;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ExerciseHeaderCard(model: model),
        const SizedBox(height: RepForgeSpacing.md),
        _ExerciseDetailEntryCards(title: model.title),
        const SizedBox(height: RepForgeSpacing.md),
        _ExerciseSummaryCard(model: model.summary),
        const SizedBox(height: RepForgeSpacing.md),
        Text(
          localizations.exerciseDetailHistoryTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: RepForgeSpacing.md),
        if (!model.hasHistory)
          _ExerciseDetailInfoCard(
            icon: Icons.history,
            title: localizations.exerciseDetailEmptyTitle,
            message: localizations.exerciseDetailEmptyMessage,
          )
        else ...[
          for (final group in model.historyGroups) ...[
            _HistoryDateGroup(group: group),
            const SizedBox(height: RepForgeSpacing.md),
          ],
          if (model.hasMoreHistory)
            _ExerciseDetailInfoCard(
              icon: Icons.more_horiz,
              title: localizations.exerciseDetailMoreHistoryTitle,
              message: localizations.exerciseDetailMoreHistoryMessage(
                model.historyLimit,
              ),
            ),
        ],
        const SizedBox(height: 96),
      ],
    );
  }
}

class _ExerciseHeaderCard extends StatelessWidget {
  const _ExerciseHeaderCard({required this.model});

  final ExerciseDetailViewModel model;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(model.title, style: Theme.of(context).textTheme.headlineSmall),
          if (model.tags.isNotEmpty) ...[
            const SizedBox(height: RepForgeSpacing.md),
            Wrap(
              spacing: RepForgeSpacing.sm,
              runSpacing: RepForgeSpacing.sm,
              children: [
                for (final tag in model.tags)
                  InputChip(label: Text(_formatTag(tag))),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ExerciseDetailEntryCards extends StatelessWidget {
  const _ExerciseDetailEntryCards({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: _EntryCard(
            icon: Icons.query_stats,
            title: localizations.exerciseDetailAnalyticsTitle,
            message: localizations.exerciseDetailAnalyticsMessage,
            semanticsLabel: localizations.exerciseDetailAnalyticsSemantics(
              title,
            ),
          ),
        ),
        const SizedBox(width: RepForgeSpacing.md),
        Expanded(
          child: _EntryCard(
            icon: Icons.speed,
            title: localizations.exerciseDetailOneRepMaxTitle,
            message: localizations.exerciseDetailOneRepMaxMessage,
            semanticsLabel: localizations.exerciseDetailOneRepMaxSemantics(
              title,
            ),
          ),
        ),
      ],
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.semanticsLabel,
  });

  final IconData icon;
  final String title;
  final String message;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      button: true,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: RepForgeColorTokens.accentPrimaryGreen),
            const SizedBox(height: RepForgeSpacing.sm),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: RepForgeSpacing.xs),
            Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: RepForgeColorTokens.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseSummaryCard extends StatelessWidget {
  const _ExerciseSummaryCard({required this.model});

  final ExerciseDetailSummaryViewModel model;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.exerciseDetailComparedTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: RepForgeSpacing.xs),
          Text(
            model.previousAvailable
                ? localizations.exerciseDetailComparedAvailable
                : localizations.exerciseDetailComparedUnavailable,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: RepForgeColorTokens.textSecondary,
            ),
          ),
          const SizedBox(height: RepForgeSpacing.md),
          Wrap(
            spacing: RepForgeSpacing.md,
            runSpacing: RepForgeSpacing.md,
            children: [
              for (final metric in model.metrics)
                _MetricTile(
                  metric: metric,
                  unavailableText: localizations.exerciseDetailUnavailable,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.metric, required this.unavailableText});

  final ExerciseDetailMetricViewModel metric;
  final String unavailableText;

  @override
  Widget build(BuildContext context) {
    final delta = metric.delta;
    final localizations = AppLocalizations.of(context);
    final value = metric.value == 'Unavailable'
        ? localizations.exerciseDetailUnavailable
        : metric.value;

    return SizedBox(
      width: 132,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: RepForgeColorTokens.borderSubtle),
          borderRadius: BorderRadius.circular(RepForgeRadius.md),
        ),
        child: Padding(
          padding: const EdgeInsets.all(RepForgeSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _metricLabel(localizations, metric.label),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: RepForgeColorTokens.textSecondary,
                ),
              ),
              const SizedBox(height: RepForgeSpacing.xs),
              Text(value, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: RepForgeSpacing.xs),
              Text(
                delta ?? unavailableText,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: delta == null
                      ? RepForgeColorTokens.textSecondary
                      : RepForgeColorTokens.accentPrimaryGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryDateGroup extends StatelessWidget {
  const _HistoryDateGroup({required this.group});

  final ExerciseDetailHistoryGroupViewModel group;

  @override
  Widget build(BuildContext context) {
    final localeName = Localizations.localeOf(context).toLanguageTag();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          DateFormat.yMMMMd(localeName).format(group.localDate),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: RepForgeSpacing.sm),
        for (final set in group.sets) ...[
          _HistorySetCard(set: set),
          const SizedBox(height: RepForgeSpacing.sm),
        ],
      ],
    );
  }
}

class _HistorySetCard extends StatelessWidget {
  const _HistorySetCard({required this.set});

  final ExerciseDetailSetViewModel set;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final loadText = _formatKg(set.loadKg, localeName);
    final title = localizations.exerciseDetailSetLine(
      set.repetitions,
      loadText,
    );

    return Semantics(
      label: localizations.exerciseDetailSetSemantics(
        set.repetitions,
        loadText,
      ),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  DateFormat.Hm(localeName).format(set.performedAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: RepForgeColorTokens.textSecondary,
                  ),
                ),
              ],
            ),
            if (set.label != WorkoutSetLabel.none) ...[
              const SizedBox(height: RepForgeSpacing.sm),
              InputChip(label: Text(_labelText(localizations, set.label))),
            ],
            if (set.comment != null) ...[
              const SizedBox(height: RepForgeSpacing.sm),
              Text(set.comment!, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}

class _ExerciseDetailInfoCard extends StatelessWidget {
  const _ExerciseDetailInfoCard({
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

String _formatKg(double value, String localeName) {
  final formatter = NumberFormat.decimalPattern(localeName)
    ..maximumFractionDigits = value.truncateToDouble() == value ? 0 : 1;
  return '${formatter.format(value)} kg';
}

String _labelText(AppLocalizations localizations, WorkoutSetLabel label) {
  return switch (label) {
    WorkoutSetLabel.none => localizations.quickLogLabelNone,
    WorkoutSetLabel.warmup => localizations.quickLogLabelWarmup,
    WorkoutSetLabel.failure => localizations.quickLogLabelFailure,
    WorkoutSetLabel.personalRecord => localizations.quickLogLabelPersonalRecord,
    WorkoutSetLabel.dropSet => localizations.quickLogLabelDropSet,
    WorkoutSetLabel.pain => localizations.quickLogLabelPain,
  };
}

String _metricLabel(AppLocalizations localizations, String label) {
  return switch (label) {
    'Sets' => localizations.analyticsMetricSets,
    'Repetitions' => localizations.analyticsMetricRepetitions,
    'Volume' => localizations.analyticsMetricVolume,
    'kg/rep' => localizations.analyticsMetricKgPerRep,
    'Estimated 1RM' => localizations.analyticsEstimatedOneRepMaxTitle,
    _ => label,
  };
}
