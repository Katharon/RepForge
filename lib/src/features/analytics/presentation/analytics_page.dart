import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import 'analytics_metric.dart';
import 'analytics_range.dart';
import 'exercise_analytics_loader.dart';
import 'exercise_analytics_view_model.dart';

enum AnalyticsUiStatus { loading, empty, error, success }

final class AnalyticsUiState {
  const AnalyticsUiState({
    required this.status,
    required this.selectedMetric,
    required this.selectedRange,
    this.viewModel,
    this.error,
  });

  final AnalyticsUiStatus status;
  final AnalyticsMetric selectedMetric;
  final ExerciseAnalyticsRange selectedRange;
  final ExerciseAnalyticsViewModel? viewModel;
  final Object? error;
}

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({required this.loader, super.key, this.nowProvider});

  final ExerciseAnalyticsLoader loader;
  final AnalyticsNowProvider? nowProvider;

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  var _selectedMetric = AnalyticsMetric.volumeKg;
  var _selectedRange = ExerciseAnalyticsRange.thirtyDays;
  var _requestVersion = 0;

  late AnalyticsUiState _state = AnalyticsUiState(
    status: AnalyticsUiStatus.loading,
    selectedMetric: _selectedMetric,
    selectedRange: _selectedRange,
  );

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void didUpdateWidget(covariant AnalyticsPage oldWidget) {
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
        SliverAppBar.large(title: Text(localizations.navAnalytics)),
        AppResponsiveSliverList(
          maxWidth: 840,
          children: [
            _AnalyticsHeader(state: _state),
            const SizedBox(height: RepForgeSpacing.lg),
            _MetricSelector(
              selectedMetric: _selectedMetric,
              onSelected: _selectMetric,
            ),
            const SizedBox(height: RepForgeSpacing.md),
            _RangeSelector(
              selectedRange: _selectedRange,
              onSelected: _selectRange,
            ),
            const SizedBox(height: RepForgeSpacing.lg),
            _AnalyticsStateBody(state: _state, onRetry: _load),
          ],
        ),
      ],
    );
  }

  void _selectMetric(AnalyticsMetric metric) {
    setState(() {
      _selectedMetric = metric;
      _state = AnalyticsUiState(
        status: _state.status,
        selectedMetric: metric,
        selectedRange: _selectedRange,
        viewModel: _state.viewModel,
        error: _state.error,
      );
    });
  }

  void _selectRange(ExerciseAnalyticsRange range) {
    if (range == _selectedRange) {
      return;
    }

    setState(() {
      _selectedRange = range;
    });
    unawaited(_load());
  }

  Future<void> _load() async {
    final requestVersion = ++_requestVersion;
    setState(() {
      _state = AnalyticsUiState(
        status: AnalyticsUiStatus.loading,
        selectedMetric: _selectedMetric,
        selectedRange: _selectedRange,
      );
    });

    try {
      final model = await widget.loader.load(
        ExerciseAnalyticsLoadRequest(
          range: _selectedRange,
          now: (widget.nowProvider ?? DateTime.now)(),
        ),
      );
      if (!mounted || requestVersion != _requestVersion) {
        return;
      }

      final viewModel = ExerciseAnalyticsViewModel.fromReadModel(model);
      setState(() {
        _state = AnalyticsUiState(
          status: model.overview.isEmpty
              ? AnalyticsUiStatus.empty
              : AnalyticsUiStatus.success,
          selectedMetric: _selectedMetric,
          selectedRange: _selectedRange,
          viewModel: viewModel,
        );
      });
    } catch (error) {
      if (!mounted || requestVersion != _requestVersion) {
        return;
      }

      setState(() {
        _state = AnalyticsUiState(
          status: AnalyticsUiStatus.error,
          selectedMetric: _selectedMetric,
          selectedRange: _selectedRange,
          error: error,
        );
      });
    }
  }
}

class _AnalyticsHeader extends StatelessWidget {
  const _AnalyticsHeader({required this.state});

  final AnalyticsUiState state;

  @override
  Widget build(BuildContext context) {
    final exerciseName = state.viewModel?.exerciseName ?? 'Barbell Bench Press';

    return Text(
      exerciseName,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        color: RepForgeColorTokens.textPrimary,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      ),
    );
  }
}

class _MetricSelector extends StatelessWidget {
  const _MetricSelector({
    required this.selectedMetric,
    required this.onSelected,
  });

  final AnalyticsMetric selectedMetric;
  final ValueChanged<AnalyticsMetric> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final metric in AnalyticsMetric.values) ...[
            ChoiceChip(
              key: Key('analytics_metric_${metric.name}'),
              label: Text(_metricLabel(context, metric)),
              selected: metric == selectedMetric,
              onSelected: (_) => onSelected(metric),
            ),
            const SizedBox(width: RepForgeSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _RangeSelector extends StatelessWidget {
  const _RangeSelector({required this.selectedRange, required this.onSelected});

  final ExerciseAnalyticsRange selectedRange;
  final ValueChanged<ExerciseAnalyticsRange> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SegmentedButton<ExerciseAnalyticsRange>(
        key: const Key('analytics_range_selector'),
        segments: [
          for (final range in ExerciseAnalyticsRange.values)
            ButtonSegment(
              value: range,
              label: Text(_rangeLabel(context, range)),
            ),
        ],
        selected: {selectedRange},
        onSelectionChanged: (selection) => onSelected(selection.single),
      ),
    );
  }
}

class _AnalyticsStateBody extends StatelessWidget {
  const _AnalyticsStateBody({required this.state, required this.onRetry});

  final AnalyticsUiState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case AnalyticsUiStatus.loading:
        return const _AnalyticsLoadingState();
      case AnalyticsUiStatus.empty:
        return const _AnalyticsEmptyState();
      case AnalyticsUiStatus.error:
        return _AnalyticsErrorState(onRetry: onRetry);
      case AnalyticsUiStatus.success:
        return _AnalyticsSuccessState(state: state);
    }
  }
}

class _AnalyticsLoadingState extends StatelessWidget {
  const _AnalyticsLoadingState();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AppCard(
      child: Row(
        children: [
          const SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(width: RepForgeSpacing.md),
          Expanded(child: Text(localizations.analyticsLoading)),
        ],
      ),
    );
  }
}

class _AnalyticsEmptyState extends StatelessWidget {
  const _AnalyticsEmptyState();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.insights_outlined),
          const SizedBox(height: RepForgeSpacing.md),
          Text(
            localizations.analyticsEmptyTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: RepForgeSpacing.xs),
          Text(
            localizations.analyticsEmptyMessage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: RepForgeColorTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsErrorState extends StatelessWidget {
  const _AnalyticsErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: RepForgeColorTokens.error),
          const SizedBox(height: RepForgeSpacing.md),
          Text(
            localizations.analyticsErrorTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: RepForgeSpacing.xs),
          Text(
            localizations.analyticsErrorMessage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: RepForgeColorTokens.textSecondary,
            ),
          ),
          const SizedBox(height: RepForgeSpacing.md),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(localizations.analyticsRetry),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsSuccessState extends StatelessWidget {
  const _AnalyticsSuccessState({required this.state});

  final AnalyticsUiState state;

  @override
  Widget build(BuildContext context) {
    final viewModel = state.viewModel!;
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _EstimatedOneRepMaxCard(viewModel: viewModel.estimatedOneRepMax),
        const SizedBox(height: RepForgeSpacing.lg),
        Text(
          localizations.analyticsSummaryTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: RepForgeSpacing.md),
        _SummaryMetricCards(viewModel: viewModel),
        const SizedBox(height: RepForgeSpacing.lg),
        _AnalyticsChartCard(card: viewModel.cardFor(state.selectedMetric)),
      ],
    );
  }
}

class _EstimatedOneRepMaxCard extends StatelessWidget {
  const _EstimatedOneRepMaxCard({required this.viewModel});

  final EstimatedOneRepMaxViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final metricColor = _metricColor(
      context,
      AnalyticsMetric.estimatedOneRepMaxKg,
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: RepForgeSpacing.sm,
            runSpacing: RepForgeSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 180, maxWidth: 460),
                child: Text(
                  localizations.analyticsEstimatedOneRepMaxTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              _FormulaIdentityPill(viewModel: viewModel),
            ],
          ),
          const SizedBox(height: RepForgeSpacing.lg),
          if (viewModel.isAvailable) ...[
            Text(
              localizations.analyticsEstimatedOneRepMaxCurrentLabel,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: RepForgeColorTokens.textSecondary,
              ),
            ),
            const SizedBox(height: RepForgeSpacing.xs),
            Text(
              _formatKilograms(context, viewModel.currentValueKg),
              style: Theme.of(
                context,
              ).textTheme.metricValue.copyWith(color: metricColor),
            ),
            const SizedBox(height: RepForgeSpacing.md),
            _PreviousOneRepMaxValue(viewModel: viewModel),
          ] else ...[
            Text(
              localizations.analyticsEstimatedOneRepMaxUnavailableTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: RepForgeSpacing.xs),
            Text(
              localizations.analyticsEstimatedOneRepMaxUnavailableMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: RepForgeColorTokens.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FormulaIdentityPill extends StatelessWidget {
  const _FormulaIdentityPill({required this.viewModel});

  final EstimatedOneRepMaxViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: RepForgeColorTokens.surfaceCardElevated,
        borderRadius: BorderRadius.circular(RepForgeRadius.sm),
        border: Border.all(color: RepForgeColorTokens.borderSubtle),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: RepForgeSpacing.sm,
          vertical: RepForgeSpacing.xs,
        ),
        child: Text(
          '${localizations.analyticsFormulaLabel}: '
          '${_formulaDisplayName(context, viewModel)}',
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
    );
  }
}

class _PreviousOneRepMaxValue extends StatelessWidget {
  const _PreviousOneRepMaxValue({required this.viewModel});

  final EstimatedOneRepMaxViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Wrap(
      spacing: RepForgeSpacing.md,
      runSpacing: RepForgeSpacing.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 180, maxWidth: 420),
          child: Text(
            localizations.analyticsEstimatedOneRepMaxPreviousLabel,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: RepForgeColorTokens.textSecondary,
            ),
          ),
        ),
        Text(
          _formatKilograms(context, viewModel.previousValueKg),
          style: Theme.of(context).textTheme.metricUnit,
        ),
      ],
    );
  }
}

class _SummaryMetricCards extends StatelessWidget {
  const _SummaryMetricCards({required this.viewModel});

  final ExerciseAnalyticsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = RepForgeSpacing.md;
        final cardWidth = constraints.maxWidth >= 520
            ? (constraints.maxWidth - spacing) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final card in viewModel.metricCards)
              SizedBox(
                width: cardWidth,
                child: AppCard(child: _MetricCardContent(card: card)),
              ),
          ],
        );
      },
    );
  }
}

class _MetricCardContent extends StatelessWidget {
  const _MetricCardContent({required this.card});

  final AnalyticsMetricCardViewModel card;

  @override
  Widget build(BuildContext context) {
    final color = _metricColor(context, card.metric);
    final label = _metricLabel(context, card.metric);
    final value = _formatMetricValue(
      context,
      card.metric,
      card.currentValue,
      card,
    );

    return Semantics(
      label: '$label, $value',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: RepForgeColorTokens.textSecondary,
            ),
          ),
          const SizedBox(height: RepForgeSpacing.sm),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.metricValue.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsChartCard extends StatelessWidget {
  const _AnalyticsChartCard({required this.card});

  final AnalyticsMetricCardViewModel card;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final metricColor = _metricColor(context, card.metric);
    final previousValue = card.previousValue;
    final metricLabel = _metricLabel(context, card.metric);
    final currentLabel = _formatMetricValue(
      context,
      card.metric,
      card.currentValue,
      card,
    );
    final previousLabel = previousValue == null
        ? '--'
        : _formatMetricValue(context, card.metric, previousValue, card);

    return Semantics(
      label:
          '${localizations.analyticsChartTitle(metricLabel)}, '
          '${localizations.analyticsCurrentPeriod} $currentLabel, '
          '${localizations.analyticsPreviousPeriod} $previousLabel',
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.analyticsChartTitle(metricLabel),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: RepForgeSpacing.lg),
            SizedBox(
              height: 160,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: _AnalyticsChartBar(
                      key: const Key('analytics_chart_current_bar'),
                      label: localizations.analyticsCurrentPeriod,
                      valueLabel: currentLabel,
                      fraction: _chartFraction(
                        value: card.currentValue,
                        maximum: card.chartMaximum,
                      ),
                      color: metricColor,
                    ),
                  ),
                  const SizedBox(width: RepForgeSpacing.md),
                  Expanded(
                    child: _AnalyticsChartBar(
                      key: const Key('analytics_chart_previous_bar'),
                      label: localizations.analyticsPreviousPeriod,
                      valueLabel: previousLabel,
                      fraction: _chartFraction(
                        value: previousValue,
                        maximum: card.chartMaximum,
                      ),
                      color: RepForgeColorTokens.surfaceCardElevated,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalyticsChartBar extends StatelessWidget {
  const _AnalyticsChartBar({
    required this.label,
    required this.valueLabel,
    required this.fraction,
    required this.color,
    super.key,
  });

  final String label;
  final String valueLabel;
  final double fraction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          valueLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: RepForgeSpacing.sm),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: fraction,
              widthFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(RepForgeRadius.sm),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: RepForgeSpacing.sm),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: RepForgeColorTokens.textSecondary,
          ),
        ),
      ],
    );
  }
}

String _metricLabel(BuildContext context, AnalyticsMetric metric) {
  final localizations = AppLocalizations.of(context);

  return switch (metric) {
    AnalyticsMetric.sets => localizations.analyticsMetricSets,
    AnalyticsMetric.repetitions => localizations.analyticsMetricRepetitions,
    AnalyticsMetric.volumeKg => localizations.analyticsMetricVolume,
    AnalyticsMetric.kgPerRep => localizations.analyticsMetricKgPerRep,
    AnalyticsMetric.estimatedOneRepMaxKg =>
      localizations.analyticsMetricEstimatedOneRepMax,
  };
}

String _rangeLabel(BuildContext context, ExerciseAnalyticsRange range) {
  final localizations = AppLocalizations.of(context);

  return switch (range) {
    ExerciseAnalyticsRange.sevenDays => localizations.analyticsRangeSevenDays,
    ExerciseAnalyticsRange.thirtyDays => localizations.analyticsRangeThirtyDays,
    ExerciseAnalyticsRange.ninetyDays => localizations.analyticsRangeNinetyDays,
  };
}

Color _metricColor(BuildContext context, AnalyticsMetric metric) {
  final colors =
      Theme.of(context).extension<RepForgeMetricColors>() ??
      const RepForgeMetricColors.dark();

  return switch (metric) {
    AnalyticsMetric.sets => colors.sets,
    AnalyticsMetric.repetitions => colors.repetitions,
    AnalyticsMetric.volumeKg => colors.volume,
    AnalyticsMetric.kgPerRep => colors.kgPerRep,
    AnalyticsMetric.estimatedOneRepMaxKg => colors.oneRepMax,
  };
}

String _formatMetricValue(
  BuildContext context,
  AnalyticsMetric metric,
  double? value,
  AnalyticsMetricCardViewModel card,
) {
  if (!card.isAvailable || value == null) {
    return '--';
  }

  final localizations = AppLocalizations.of(context);

  return switch (metric) {
    AnalyticsMetric.sets ||
    AnalyticsMetric.repetitions => _formatNumber(value, fractionDigits: 0),
    AnalyticsMetric.volumeKg ||
    AnalyticsMetric.estimatedOneRepMaxKg => _formatKilograms(context, value),
    AnalyticsMetric.kgPerRep =>
      '${_formatNumber(value, fractionDigits: 1)} '
          '${localizations.analyticsUnitKilogramsPerRep}',
  };
}

String _formatKilograms(BuildContext context, double? value) {
  if (value == null) {
    return '--';
  }

  final localizations = AppLocalizations.of(context);

  return '${_formatNumber(value, fractionDigits: 1)} '
      '${localizations.analyticsUnitKilograms}';
}

String _formulaDisplayName(
  BuildContext context,
  EstimatedOneRepMaxViewModel viewModel,
) {
  final localizations = AppLocalizations.of(context);

  if (viewModel.formulaName == 'epley_one_rep_max') {
    return localizations.analyticsFormulaEpley(viewModel.formulaVersion);
  }

  return '${viewModel.formulaName}/v${viewModel.formulaVersion}';
}

String _formatNumber(double value, {required int fractionDigits}) {
  final formatted = value.toStringAsFixed(fractionDigits);
  if (!formatted.contains('.')) {
    return formatted;
  }

  return formatted.replaceFirst(RegExp(r'\.0$'), '');
}

double _chartFraction({required double? value, required double maximum}) {
  if (value == null || value <= 0) {
    return 0.04;
  }

  final fraction = value / maximum;
  if (fraction < 0.04) {
    return 0.04;
  }
  if (fraction > 1) {
    return 1;
  }

  return fraction;
}
