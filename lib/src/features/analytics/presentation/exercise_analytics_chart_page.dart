import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../training_log/domain/training_log_domain.dart';
import 'analytics_metric.dart';
import 'exercise_analytics_chart_loader.dart';
import 'exercise_analytics_chart_range.dart';
import 'exercise_analytics_loader.dart';

enum ExerciseAnalyticsChartUiStatus { loading, empty, error, success }

final class ExerciseAnalyticsChartUiState {
  const ExerciseAnalyticsChartUiState({
    required this.status,
    required this.selectedMetric,
    required this.selectedRange,
    this.model,
    this.selectedPointIndex,
    this.error,
  });

  final ExerciseAnalyticsChartUiStatus status;
  final AnalyticsMetric selectedMetric;
  final ExerciseAnalyticsChartRange selectedRange;
  final ExerciseAnalyticsChartViewModel? model;
  final int? selectedPointIndex;
  final Object? error;

  ExerciseAnalyticsChartPointViewModel? get selectedPoint {
    final model = this.model;
    final index = selectedPointIndex;
    if (model == null ||
        index == null ||
        index < 0 ||
        index >= model.points.length) {
      return null;
    }
    return model.points[index];
  }
}

class ExerciseAnalyticsChartPage extends StatefulWidget {
  const ExerciseAnalyticsChartPage({
    required this.exerciseRef,
    required this.title,
    required this.loader,
    super.key,
    this.initialMetric = AnalyticsMetric.volumeKg,
    this.initialRange = ExerciseAnalyticsChartRange.month,
    this.nowProvider,
  });

  final ExerciseRef exerciseRef;
  final String title;
  final ExerciseAnalyticsChartLoader loader;
  final AnalyticsMetric initialMetric;
  final ExerciseAnalyticsChartRange initialRange;
  final AnalyticsNowProvider? nowProvider;

  @override
  State<ExerciseAnalyticsChartPage> createState() {
    return _ExerciseAnalyticsChartPageState();
  }
}

class _ExerciseAnalyticsChartPageState
    extends State<ExerciseAnalyticsChartPage> {
  var _requestVersion = 0;

  late var _selectedMetric = widget.initialMetric;
  late var _selectedRange = widget.initialRange;
  late ExerciseAnalyticsChartUiState _state = ExerciseAnalyticsChartUiState(
    status: ExerciseAnalyticsChartUiStatus.loading,
    selectedMetric: _selectedMetric,
    selectedRange: _selectedRange,
  );

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void didUpdateWidget(covariant ExerciseAnalyticsChartPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.loader != widget.loader ||
        oldWidget.exerciseRef != widget.exerciseRef) {
      unawaited(_load());
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _state.model?.title ?? widget.title;
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(title: Text(title)),
          AppResponsiveSliverList(
            maxWidth: 840,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: RepForgeSpacing.xs),
              Text(
                localizations.exerciseAnalyticsChartTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: RepForgeColorTokens.textSecondary,
                ),
              ),
              const SizedBox(height: RepForgeSpacing.md),
              _ExerciseAnalyticsMetricSelector(
                selectedMetric: _selectedMetric,
                onSelected: _selectMetric,
              ),
              const SizedBox(height: RepForgeSpacing.md),
              _ExerciseAnalyticsRangeSelector(
                selectedRange: _selectedRange,
                onSelected: _selectRange,
              ),
              const SizedBox(height: RepForgeSpacing.lg),
              _ExerciseAnalyticsChartBody(
                state: _state,
                onRetry: _load,
                onSelectPoint: _selectPoint,
              ),
              const SizedBox(height: RepForgeSpacing.xl),
            ],
          ),
        ],
      ),
    );
  }

  void _selectMetric(AnalyticsMetric metric) {
    setState(() {
      _selectedMetric = metric;
      _state = ExerciseAnalyticsChartUiState(
        status: _state.status,
        selectedMetric: metric,
        selectedRange: _selectedRange,
        model: _state.model,
        selectedPointIndex: _state.selectedPointIndex,
        error: _state.error,
      );
    });
  }

  void _selectRange(ExerciseAnalyticsChartRange range) {
    if (range == _selectedRange) {
      return;
    }
    setState(() {
      _selectedRange = range;
    });
    unawaited(_load());
  }

  void _selectPoint(int index) {
    setState(() {
      _state = ExerciseAnalyticsChartUiState(
        status: _state.status,
        selectedMetric: _selectedMetric,
        selectedRange: _selectedRange,
        model: _state.model,
        selectedPointIndex: index,
        error: _state.error,
      );
    });
  }

  Future<void> _load() async {
    final requestVersion = ++_requestVersion;
    setState(() {
      _state = ExerciseAnalyticsChartUiState(
        status: ExerciseAnalyticsChartUiStatus.loading,
        selectedMetric: _selectedMetric,
        selectedRange: _selectedRange,
      );
    });

    try {
      final model = await widget.loader.load(
        ExerciseAnalyticsChartLoadRequest(
          range: _selectedRange,
          now: (widget.nowProvider ?? DateTime.now)(),
        ),
      );
      if (!mounted || requestVersion != _requestVersion) {
        return;
      }
      final selectedIndex = model.points.isEmpty
          ? null
          : model.points.length - 1;
      setState(() {
        _state = ExerciseAnalyticsChartUiState(
          status: model.hasPoints
              ? ExerciseAnalyticsChartUiStatus.success
              : ExerciseAnalyticsChartUiStatus.empty,
          selectedMetric: _selectedMetric,
          selectedRange: _selectedRange,
          model: model,
          selectedPointIndex: selectedIndex,
        );
      });
    } catch (error) {
      if (!mounted || requestVersion != _requestVersion) {
        return;
      }
      setState(() {
        _state = ExerciseAnalyticsChartUiState(
          status: ExerciseAnalyticsChartUiStatus.error,
          selectedMetric: _selectedMetric,
          selectedRange: _selectedRange,
          error: error,
        );
      });
    }
  }
}

class _ExerciseAnalyticsMetricSelector extends StatelessWidget {
  const _ExerciseAnalyticsMetricSelector({
    required this.selectedMetric,
    required this.onSelected,
  });

  final AnalyticsMetric selectedMetric;
  final ValueChanged<AnalyticsMetric> onSelected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppLocalizations.of(context).exerciseAnalyticsMetricSelectorLabel,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final metric in AnalyticsMetric.values) ...[
              ChoiceChip(
                key: Key('exercise_analytics_metric_${metric.name}'),
                label: Text(_metricLabel(context, metric)),
                selected: metric == selectedMetric,
                onSelected: (_) => onSelected(metric),
              ),
              const SizedBox(width: RepForgeSpacing.sm),
            ],
          ],
        ),
      ),
    );
  }
}

class _ExerciseAnalyticsRangeSelector extends StatelessWidget {
  const _ExerciseAnalyticsRangeSelector({
    required this.selectedRange,
    required this.onSelected,
  });

  final ExerciseAnalyticsChartRange selectedRange;
  final ValueChanged<ExerciseAnalyticsChartRange> onSelected;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.exerciseAnalyticsRangeTitle,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: RepForgeColorTokens.textSecondary,
          ),
        ),
        const SizedBox(height: RepForgeSpacing.sm),
        Semantics(
          label: localizations.exerciseAnalyticsRangeSelectorLabel,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<ExerciseAnalyticsChartRange>(
              key: const Key('exercise_analytics_range_selector'),
              segments: [
                for (final range in ExerciseAnalyticsChartRange.values)
                  ButtonSegment(
                    value: range,
                    label: Text(_rangeLabel(context, range)),
                  ),
              ],
              selected: {selectedRange},
              onSelectionChanged: (selection) => onSelected(selection.single),
            ),
          ),
        ),
      ],
    );
  }
}

class _ExerciseAnalyticsChartBody extends StatelessWidget {
  const _ExerciseAnalyticsChartBody({
    required this.state,
    required this.onRetry,
    required this.onSelectPoint,
  });

  final ExerciseAnalyticsChartUiState state;
  final VoidCallback onRetry;
  final ValueChanged<int> onSelectPoint;

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case ExerciseAnalyticsChartUiStatus.loading:
        return const _ExerciseAnalyticsChartLoadingState();
      case ExerciseAnalyticsChartUiStatus.empty:
        return _ExerciseAnalyticsChartEmptyState(metric: state.selectedMetric);
      case ExerciseAnalyticsChartUiStatus.error:
        return _ExerciseAnalyticsChartErrorState(onRetry: onRetry);
      case ExerciseAnalyticsChartUiStatus.success:
        return _ExerciseAnalyticsChartSuccessState(
          state: state,
          onSelectPoint: onSelectPoint,
        );
    }
  }
}

class _ExerciseAnalyticsChartLoadingState extends StatelessWidget {
  const _ExerciseAnalyticsChartLoadingState();

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
          Expanded(child: Text(localizations.exerciseAnalyticsChartLoading)),
        ],
      ),
    );
  }
}

class _ExerciseAnalyticsChartEmptyState extends StatelessWidget {
  const _ExerciseAnalyticsChartEmptyState({required this.metric});

  final AnalyticsMetric metric;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final title = metric == AnalyticsMetric.estimatedOneRepMaxKg
        ? localizations.exerciseAnalyticsOneRepMaxUnavailableTitle
        : localizations.exerciseAnalyticsChartEmptyTitle;
    final message = metric == AnalyticsMetric.estimatedOneRepMaxKg
        ? localizations.exerciseAnalyticsOneRepMaxUnavailableMessage
        : localizations.exerciseAnalyticsChartEmptyMessage;

    return Semantics(
      label: title,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.insights_outlined),
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
      ),
    );
  }
}

class _ExerciseAnalyticsChartErrorState extends StatelessWidget {
  const _ExerciseAnalyticsChartErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Semantics(
      label: localizations.exerciseAnalyticsChartErrorTitle,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline, color: RepForgeColorTokens.error),
            const SizedBox(height: RepForgeSpacing.md),
            Text(
              localizations.exerciseAnalyticsChartErrorTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: RepForgeSpacing.xs),
            Text(
              localizations.exerciseAnalyticsChartErrorMessage,
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
      ),
    );
  }
}

class _ExerciseAnalyticsChartSuccessState extends StatelessWidget {
  const _ExerciseAnalyticsChartSuccessState({
    required this.state,
    required this.onSelectPoint,
  });

  final ExerciseAnalyticsChartUiState state;
  final ValueChanged<int> onSelectPoint;

  @override
  Widget build(BuildContext context) {
    final model = state.model!;
    final selectedPoint = state.selectedPoint ?? model.points.last;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SelectedPointSummary(
          metric: state.selectedMetric,
          point: selectedPoint,
        ),
        const SizedBox(height: RepForgeSpacing.md),
        _ExerciseAnalyticsChartCard(
          model: model,
          metric: state.selectedMetric,
          selectedPointIndex:
              state.selectedPointIndex ?? model.points.length - 1,
          onSelectPoint: onSelectPoint,
        ),
        if (model.reachedHistoryLimit) ...[
          const SizedBox(height: RepForgeSpacing.md),
          _LimitedHistoryNotice(limit: exerciseAnalyticsChartTimelineLimit),
        ],
      ],
    );
  }
}

class _SelectedPointSummary extends StatelessWidget {
  const _SelectedPointSummary({required this.metric, required this.point});

  final AnalyticsMetric metric;
  final ExerciseAnalyticsChartPointViewModel point;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final metricLabel = _metricLabel(context, metric);
    final metricValue = _formatMetricValue(
      context,
      metric,
      point.valueFor(metric),
    );
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final dateLabel = DateFormat.yMMMd(
      localeName,
    ).add_Hm().format(point.performedAt);
    final setLabel = localizations.exerciseAnalyticsSetSummary(
      point.repetitions,
      _formatKilograms(context, point.loadKg),
    );
    final semantics =
        '${localizations.exerciseAnalyticsSelectedPointSemantics}, '
        '$metricLabel $metricValue, $dateLabel, $setLabel'
        '${point.hasInputWarning ? '. ${localizations.inputGuardWarningSemantics}' : ''}';

    return Semantics(
      label: semantics,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.exerciseAnalyticsSelectedPointTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: RepForgeSpacing.sm),
            Text(
              metricValue,
              style: Theme.of(context).textTheme.metricValue.copyWith(
                color: _metricColor(context, metric),
              ),
            ),
            const SizedBox(height: RepForgeSpacing.sm),
            Wrap(
              spacing: RepForgeSpacing.md,
              runSpacing: RepForgeSpacing.xs,
              children: [
                Text(
                  dateLabel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: RepForgeColorTokens.textSecondary,
                  ),
                ),
                Text(setLabel, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            if (point.hasInputWarning) ...[
              const SizedBox(height: RepForgeSpacing.sm),
              InputChip(
                avatar: const Icon(Icons.warning_amber, size: 18),
                label: Text(localizations.inputGuardWarningBadge),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ExerciseAnalyticsChartCard extends StatelessWidget {
  const _ExerciseAnalyticsChartCard({
    required this.model,
    required this.metric,
    required this.selectedPointIndex,
    required this.onSelectPoint,
  });

  final ExerciseAnalyticsChartViewModel model;
  final AnalyticsMetric metric;
  final int selectedPointIndex;
  final ValueChanged<int> onSelectPoint;

  @override
  Widget build(BuildContext context) {
    final metricLabel = _metricLabel(context, metric);
    final values = [for (final point in model.points) point.valueFor(metric)];
    final maximum = values.fold<double>(
      1,
      (max, value) => value > max ? value : max,
    );
    final localizations = AppLocalizations.of(context);

    return Semantics(
      label:
          '${localizations.exerciseAnalyticsChartSemantics(metricLabel)}, '
          '${model.points.length} ${localizations.exerciseAnalyticsChartPointsLabel}',
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.exerciseAnalyticsChartTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: RepForgeSpacing.md),
            SizedBox(
              height: 220,
              child: _PointChart(
                points: model.points,
                metric: metric,
                maximum: maximum,
                selectedPointIndex: selectedPointIndex,
                onSelectPoint: onSelectPoint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PointChart extends StatelessWidget {
  const _PointChart({
    required this.points,
    required this.metric,
    required this.maximum,
    required this.selectedPointIndex,
    required this.onSelectPoint,
  });

  final List<ExerciseAnalyticsChartPointViewModel> points;
  final AnalyticsMetric metric;
  final double maximum;
  final int selectedPointIndex;
  final ValueChanged<int> onSelectPoint;

  @override
  Widget build(BuildContext context) {
    final color = _metricColor(context, metric);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final pointsLength = points.length;
        final xGap = pointsLength <= 1 ? 0.0 : width / (pointsLength - 1);

        return Stack(
          children: [
            CustomPaint(
              size: Size(width, height),
              painter: _PointChartPainter(
                values: [for (final point in points) point.valueFor(metric)],
                maximum: maximum,
                color: color,
                selectedPointIndex: selectedPointIndex,
              ),
            ),
            for (var index = 0; index < pointsLength; index++)
              Positioned(
                left: pointsLength <= 1
                    ? (width - 48) / 2
                    : (xGap * index - 24).clamp(0, width - 48).toDouble(),
                top: 0,
                width: 48,
                height: height,
                child: GestureDetector(
                  key: Key('exercise_analytics_chart_point_$index'),
                  behavior: HitTestBehavior.translucent,
                  onTap: () => onSelectPoint(index),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PointChartPainter extends CustomPainter {
  const _PointChartPainter({
    required this.values,
    required this.maximum,
    required this.color,
    required this.selectedPointIndex,
  });

  final List<double> values;
  final double maximum;
  final Color color;
  final int selectedPointIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = RepForgeColorTokens.borderSubtle
      ..strokeWidth = 1;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final selectedPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawLine(
      Offset(0, size.height - 16),
      Offset(size.width, size.height - 16),
      axisPaint,
    );

    final offsets = <Offset>[];
    for (var index = 0; index < values.length; index++) {
      final x = values.length == 1
          ? size.width / 2
          : (size.width / (values.length - 1)) * index;
      final fraction = maximum <= 0 ? 0 : values[index] / maximum;
      final y =
          (size.height - 24) - (fraction.clamp(0, 1) * (size.height - 48));
      offsets.add(Offset(x, y));
    }

    if (offsets.length > 1) {
      final path = Path()..moveTo(offsets.first.dx, offsets.first.dy);
      for (final offset in offsets.skip(1)) {
        path.lineTo(offset.dx, offset.dy);
      }
      canvas.drawPath(path, linePaint);
    }

    for (var index = 0; index < offsets.length; index++) {
      final radius = index == selectedPointIndex ? 6.0 : 4.0;
      canvas.drawCircle(offsets[index], radius, pointPaint);
      if (index == selectedPointIndex) {
        canvas.drawCircle(offsets[index], 2.4, selectedPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PointChartPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.maximum != maximum ||
        oldDelegate.color != color ||
        oldDelegate.selectedPointIndex != selectedPointIndex;
  }
}

class _LimitedHistoryNotice extends StatelessWidget {
  const _LimitedHistoryNotice({required this.limit});

  final int limit;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return AppCard(
      child: Row(
        children: [
          const Icon(Icons.history_toggle_off),
          const SizedBox(width: RepForgeSpacing.md),
          Expanded(
            child: Text(
              localizations.exerciseAnalyticsLimitedHistory(limit),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: RepForgeColorTokens.textSecondary,
              ),
            ),
          ),
        ],
      ),
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

String _rangeLabel(BuildContext context, ExerciseAnalyticsChartRange range) {
  final localizations = AppLocalizations.of(context);
  return switch (range) {
    ExerciseAnalyticsChartRange.day => localizations.exerciseAnalyticsRangeDay,
    ExerciseAnalyticsChartRange.week =>
      localizations.exerciseAnalyticsRangeWeek,
    ExerciseAnalyticsChartRange.twoWeeks =>
      localizations.exerciseAnalyticsRangeTwoWeeks,
    ExerciseAnalyticsChartRange.month =>
      localizations.exerciseAnalyticsRangeMonth,
    ExerciseAnalyticsChartRange.threeMonths =>
      localizations.exerciseAnalyticsRangeThreeMonths,
    ExerciseAnalyticsChartRange.sixMonths =>
      localizations.exerciseAnalyticsRangeSixMonths,
    ExerciseAnalyticsChartRange.all => localizations.exerciseAnalyticsRangeAll,
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
  double value,
) {
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

String _formatKilograms(BuildContext context, double value) {
  return '${_formatNumber(value, fractionDigits: 1)} '
      '${AppLocalizations.of(context).analyticsUnitKilograms}';
}

String _formatNumber(double value, {required int fractionDigits}) {
  final formatted = value.toStringAsFixed(fractionDigits);
  if (!formatted.contains('.')) {
    return formatted;
  }
  return formatted.replaceFirst(RegExp(r'\.0$'), '');
}
