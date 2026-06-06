import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../analytics/presentation/analytics_presentation.dart';
import '../../recommendations/domain/recommendations_domain.dart';
import '../../training_log/domain/training_log_domain.dart';
import 'exercise_detail_adaptive_suggestion_loader.dart';
import 'exercise_detail_loader.dart';

typedef ExerciseDetailLogSetAction =
    Future<bool> Function(ExerciseRef exerciseRef);
typedef ExerciseDetailAnalyticsAction =
    void Function(ExerciseRef exerciseRef, AnalyticsMetric initialMetric);

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
    this.onOpenAnalytics,
    this.adaptiveSuggestionLoader,
  });

  final ExerciseRef exerciseRef;
  final ExerciseDetailLoader loader;
  final ExerciseDetailLogSetAction onLogSet;
  final ExerciseDetailAnalyticsAction? onOpenAnalytics;
  final ExerciseDetailAdaptiveSuggestionLoader? adaptiveSuggestionLoader;

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  var _requestVersion = 0;
  ExerciseDetailAdaptiveSuggestionViewModel? _adaptiveSuggestion;
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
      _adaptiveSuggestion = null;
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
            children: [
              _ExerciseDetailStateBody(
                state: _state,
                adaptiveSuggestion: _adaptiveSuggestion,
                onRetry: _load,
                onOpenAnalytics: _openAnalytics,
                onDismissAdaptiveSuggestion: _dismissAdaptiveSuggestion,
              ),
            ],
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
    final refreshedExerciseRef = _state.model?.exerciseRef ?? exerciseRef;
    await _loadAdaptiveSuggestion(refreshedExerciseRef);
  }

  Future<void> _loadAdaptiveSuggestion(ExerciseRef exerciseRef) async {
    final loader = widget.adaptiveSuggestionLoader;
    if (loader == null) {
      return;
    }

    final requestVersion = _requestVersion;
    try {
      final suggestion = await loader.load(
        exerciseRef,
        locale: Localizations.localeOf(context),
      );
      if (!mounted || requestVersion != _requestVersion) {
        return;
      }
      setState(() {
        _adaptiveSuggestion = suggestion;
      });
    } catch (_) {
      if (!mounted || requestVersion != _requestVersion) {
        return;
      }
      setState(() {
        _adaptiveSuggestion = null;
      });
    }
  }

  void _openAnalytics(AnalyticsMetric initialMetric) {
    final exerciseRef = _state.model?.exerciseRef ?? widget.exerciseRef;
    widget.onOpenAnalytics?.call(exerciseRef, initialMetric);
  }

  void _dismissAdaptiveSuggestion() {
    setState(() {
      _adaptiveSuggestion = null;
    });
  }
}

class _ExerciseDetailStateBody extends StatelessWidget {
  const _ExerciseDetailStateBody({
    required this.state,
    required this.adaptiveSuggestion,
    required this.onRetry,
    required this.onOpenAnalytics,
    required this.onDismissAdaptiveSuggestion,
  });

  final ExerciseDetailUiState state;
  final ExerciseDetailAdaptiveSuggestionViewModel? adaptiveSuggestion;
  final VoidCallback onRetry;
  final ValueChanged<AnalyticsMetric> onOpenAnalytics;
  final VoidCallback onDismissAdaptiveSuggestion;

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
        return _ExerciseDetailContent(
          model: model,
          adaptiveSuggestion: adaptiveSuggestion,
          onOpenAnalytics: onOpenAnalytics,
          onDismissAdaptiveSuggestion: onDismissAdaptiveSuggestion,
        );
    }
  }
}

class _ExerciseDetailContent extends StatelessWidget {
  const _ExerciseDetailContent({
    required this.model,
    required this.adaptiveSuggestion,
    required this.onOpenAnalytics,
    required this.onDismissAdaptiveSuggestion,
  });

  final ExerciseDetailViewModel model;
  final ExerciseDetailAdaptiveSuggestionViewModel? adaptiveSuggestion;
  final ValueChanged<AnalyticsMetric> onOpenAnalytics;
  final VoidCallback onDismissAdaptiveSuggestion;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ExerciseHeaderCard(model: model),
        const SizedBox(height: RepForgeSpacing.md),
        _ExerciseDetailEntryCards(
          title: model.title,
          onOpenAnalytics: onOpenAnalytics,
        ),
        if (adaptiveSuggestion != null) ...[
          const SizedBox(height: RepForgeSpacing.md),
          _AdaptiveSuggestionCard(
            suggestion: adaptiveSuggestion!,
            onDismiss: onDismissAdaptiveSuggestion,
          ),
        ],
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
  const _ExerciseDetailEntryCards({
    required this.title,
    required this.onOpenAnalytics,
  });

  final String title;
  final ValueChanged<AnalyticsMetric> onOpenAnalytics;

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
            onTap: () => onOpenAnalytics(AnalyticsMetric.volumeKg),
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
            onTap: () => onOpenAnalytics(AnalyticsMetric.estimatedOneRepMaxKg),
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
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String message;
  final String semanticsLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(RepForgeRadius.md),
        onTap: onTap,
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
      ),
    );
  }
}

class _AdaptiveSuggestionCard extends StatelessWidget {
  const _AdaptiveSuggestionCard({
    required this.suggestion,
    required this.onDismiss,
  });

  final ExerciseDetailAdaptiveSuggestionViewModel suggestion;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final directionText = _adaptiveDirectionText(localizations, suggestion);
    final detailText = _adaptiveDetailText(
      localizations,
      suggestion,
      localeName,
    );
    final reasonText = _adaptiveReasonText(localizations, suggestion);

    return Semantics(
      label: localizations.exerciseDetailAdaptiveSuggestionSemantics(
        directionText,
        detailText,
      ),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _adaptiveIcon(suggestion.direction),
                  color: _adaptiveColor(suggestion.direction),
                ),
                const SizedBox(width: RepForgeSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.exerciseDetailAdaptiveSuggestionTitle,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: RepForgeColorTokens.textSecondary,
                        ),
                      ),
                      const SizedBox(height: RepForgeSpacing.xs),
                      Text(
                        directionText,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: localizations.exerciseDetailAdaptiveSuggestionIgnore,
                  onPressed: onDismiss,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: RepForgeSpacing.md),
            Text(detailText, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: RepForgeSpacing.sm),
            Text(
              reasonText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: RepForgeColorTokens.textSecondary,
              ),
            ),
            const SizedBox(height: RepForgeSpacing.sm),
            Text(
              localizations.exerciseDetailAdaptiveSuggestionAdvisory,
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

String _adaptiveDirectionText(
  AppLocalizations localizations,
  ExerciseDetailAdaptiveSuggestionViewModel suggestion,
) {
  return switch (suggestion.direction) {
    AdaptiveSetDirection.addWeight =>
      localizations.exerciseDetailAdaptiveSuggestionAddWeight,
    AdaptiveSetDirection.addReps =>
      localizations.exerciseDetailAdaptiveSuggestionAddReps,
    AdaptiveSetDirection.maintain =>
      localizations.exerciseDetailAdaptiveSuggestionMaintain,
    AdaptiveSetDirection.backoff =>
      localizations.exerciseDetailAdaptiveSuggestionBackoff,
    AdaptiveSetDirection.stop =>
      localizations.exerciseDetailAdaptiveSuggestionStop,
    AdaptiveSetDirection.chooseAlternative =>
      localizations.exerciseDetailAdaptiveSuggestionAlternative,
    AdaptiveSetDirection.noSuggestion =>
      localizations.exerciseDetailAdaptiveSuggestionNone,
  };
}

String _adaptiveDetailText(
  AppLocalizations localizations,
  ExerciseDetailAdaptiveSuggestionViewModel suggestion,
  String localeName,
) {
  final load = _formatKg(
    suggestion.suggestedLoadKg ?? suggestion.currentLoadKg,
    localeName,
  );
  final repetitions =
      suggestion.suggestedRepetitions ?? suggestion.currentRepetitions;

  return switch (suggestion.direction) {
    AdaptiveSetDirection.addWeight || AdaptiveSetDirection.addReps =>
      localizations.exerciseDetailAdaptiveSuggestionNextTarget(
        repetitions,
        load,
      ),
    AdaptiveSetDirection.maintain =>
      localizations.exerciseDetailAdaptiveSuggestionMaintainTarget(
        repetitions,
        load,
      ),
    AdaptiveSetDirection.backoff =>
      localizations.exerciseDetailAdaptiveSuggestionBackoffTarget(
        repetitions,
        load,
      ),
    AdaptiveSetDirection.stop =>
      localizations.exerciseDetailAdaptiveSuggestionStopDetail,
    AdaptiveSetDirection.chooseAlternative =>
      localizations.exerciseDetailAdaptiveSuggestionAlternativeDetail,
    AdaptiveSetDirection.noSuggestion =>
      localizations.exerciseDetailAdaptiveSuggestionNoSignalDetail,
  };
}

String _adaptiveReasonText(
  AppLocalizations localizations,
  ExerciseDetailAdaptiveSuggestionViewModel suggestion,
) {
  final reasons = suggestion.reasons;
  if (!suggestion.hasComparableBaseline ||
      suggestion.inputQuality == AdaptiveSetInputQuality.partial ||
      reasons.contains(AdaptiveSetReasonCode.noBaseline)) {
    return localizations.exerciseDetailAdaptiveSuggestionReasonLimitedHistory;
  }
  if (reasons.contains(AdaptiveSetReasonCode.veryLowReadiness) ||
      reasons.contains(AdaptiveSetReasonCode.lowReadiness) ||
      reasons.contains(AdaptiveSetReasonCode.highSoreness)) {
    return localizations.exerciseDetailAdaptiveSuggestionReasonReadiness;
  }
  if (reasons.contains(AdaptiveSetReasonCode.baselineExceeded) ||
      reasons.contains(AdaptiveSetReasonCode.loadIncrementApplied)) {
    return localizations.exerciseDetailAdaptiveSuggestionReasonProgress;
  }
  if (reasons.contains(AdaptiveSetReasonCode.repProgressionAvailable) ||
      reasons.contains(AdaptiveSetReasonCode.loadIncreaseUnavailable) ||
      reasons.contains(AdaptiveSetReasonCode.equipmentMaxLoadReached)) {
    return localizations.exerciseDetailAdaptiveSuggestionReasonReps;
  }
  if (reasons.contains(AdaptiveSetReasonCode.strengthDown) ||
      reasons.contains(AdaptiveSetReasonCode.baselineBelow)) {
    return localizations.exerciseDetailAdaptiveSuggestionReasonConservative;
  }
  if (reasons.contains(AdaptiveSetReasonCode.baselineMatched)) {
    return localizations.exerciseDetailAdaptiveSuggestionReasonMatched;
  }
  return localizations.exerciseDetailAdaptiveSuggestionReasonLocalHistory;
}

IconData _adaptiveIcon(AdaptiveSetDirection direction) {
  return switch (direction) {
    AdaptiveSetDirection.addWeight => Icons.fitness_center,
    AdaptiveSetDirection.addReps => Icons.add_chart,
    AdaptiveSetDirection.maintain => Icons.trending_flat,
    AdaptiveSetDirection.backoff => Icons.south_west,
    AdaptiveSetDirection.stop => Icons.pause_circle_outline,
    AdaptiveSetDirection.chooseAlternative => Icons.swap_horiz,
    AdaptiveSetDirection.noSuggestion => Icons.info_outline,
  };
}

Color _adaptiveColor(AdaptiveSetDirection direction) {
  return switch (direction) {
    AdaptiveSetDirection.addWeight ||
    AdaptiveSetDirection.addReps => RepForgeColorTokens.accentPrimaryGreen,
    AdaptiveSetDirection.maintain ||
    AdaptiveSetDirection.noSuggestion => RepForgeColorTokens.metricVolumeBlue,
    AdaptiveSetDirection.backoff ||
    AdaptiveSetDirection.stop ||
    AdaptiveSetDirection.chooseAlternative => RepForgeColorTokens.warning,
  };
}
