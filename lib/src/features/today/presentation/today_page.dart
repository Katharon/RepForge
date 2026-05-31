import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../rest_timer/domain/rest_timer_domain.dart';
import 'today_dashboard_loader.dart';
import 'today_dashboard_models.dart';

enum TodayDashboardStatus { loading, empty, error, success }

final class TodayDashboardState {
  const TodayDashboardState({required this.status, this.dashboard, this.error});

  final TodayDashboardStatus status;
  final TodayDashboardReadModel? dashboard;
  final Object? error;
}

class TodayPage extends StatefulWidget {
  const TodayPage({required this.loader, super.key});

  final TodayDashboardLoader loader;

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  var _requestVersion = 0;
  TodayDashboardState _state = const TodayDashboardState(
    status: TodayDashboardStatus.loading,
  );

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void didUpdateWidget(covariant TodayPage oldWidget) {
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
        SliverAppBar.large(title: Text(localizations.todayDashboardTitle)),
        AppResponsiveSliverList(
          children: [_TodayStateBody(state: _state, onRetry: _load)],
        ),
      ],
    );
  }

  Future<void> _load() async {
    final requestVersion = ++_requestVersion;
    setState(() {
      _state = const TodayDashboardState(status: TodayDashboardStatus.loading);
    });

    try {
      final dashboard = await widget.loader.load();
      if (!mounted || requestVersion != _requestVersion) {
        return;
      }

      setState(() {
        _state = TodayDashboardState(
          status: dashboard.hasLoggedSets || dashboard.hasVisibleRestTimer
              ? TodayDashboardStatus.success
              : TodayDashboardStatus.empty,
          dashboard: dashboard,
        );
      });
    } catch (error) {
      if (!mounted || requestVersion != _requestVersion) {
        return;
      }

      setState(() {
        _state = TodayDashboardState(
          status: TodayDashboardStatus.error,
          error: error,
        );
      });
    }
  }
}

class _TodayStateBody extends StatelessWidget {
  const _TodayStateBody({required this.state, required this.onRetry});

  final TodayDashboardState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case TodayDashboardStatus.loading:
        return const _TodayLoadingState();
      case TodayDashboardStatus.empty:
        return _TodayEmptyState(dashboard: state.dashboard);
      case TodayDashboardStatus.error:
        return _TodayErrorState(onRetry: onRetry);
      case TodayDashboardStatus.success:
        return _TodaySuccessState(dashboard: state.dashboard!);
    }
  }
}

class _TodayLoadingState extends StatelessWidget {
  const _TodayLoadingState();

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
          Expanded(child: Text(localizations.todayLoading)),
        ],
      ),
    );
  }
}

class _TodayEmptyState extends StatelessWidget {
  const _TodayEmptyState({required this.dashboard});

  final TodayDashboardReadModel? dashboard;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.today_outlined),
              const SizedBox(height: RepForgeSpacing.md),
              Text(
                localizations.todayEmptyTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: RepForgeSpacing.xs),
              Text(
                localizations.todayEmptyMessage,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: RepForgeColorTokens.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: RepForgeSpacing.md),
        if (dashboard != null) ...[
          _MetricStrip(dashboard: dashboard!),
          const SizedBox(height: RepForgeSpacing.md),
          _RestTimerCard(dashboard: dashboard!),
          const SizedBox(height: RepForgeSpacing.md),
        ],
        const _QuickActionCard(),
      ],
    );
  }
}

class _TodayErrorState extends StatelessWidget {
  const _TodayErrorState({required this.onRetry});

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
            localizations.todayErrorTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: RepForgeSpacing.xs),
          Text(
            localizations.todayErrorMessage,
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
  }
}

class _TodaySuccessState extends StatelessWidget {
  const _TodaySuccessState({required this.dashboard});

  final TodayDashboardReadModel dashboard;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MetricStrip(dashboard: dashboard),
        const SizedBox(height: RepForgeSpacing.md),
        _LastLoggedSetCard(dashboard: dashboard),
        const SizedBox(height: RepForgeSpacing.md),
        _RestTimerCard(dashboard: dashboard),
        const SizedBox(height: RepForgeSpacing.md),
        const _QuickActionCard(),
        const SizedBox(height: RepForgeSpacing.md),
        const _AnalyticsHintCard(),
      ],
    );
  }
}

class _MetricStrip extends StatelessWidget {
  const _MetricStrip({required this.dashboard});

  final TodayDashboardReadModel dashboard;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

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
            SizedBox(
              width: cardWidth,
              child: _MetricCard(
                label: localizations.todaySetCount,
                value: dashboard.setCount.toString(),
                color: RepForgeColorTokens.metricSetsPink,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _MetricCard(
                label: localizations.todayVolume,
                value: _formatKilograms(context, dashboard.totalVolumeKg),
                color: RepForgeColorTokens.metricVolumeBlue,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label, $value',
      child: AppCard(
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
      ),
    );
  }
}

class _LastLoggedSetCard extends StatelessWidget {
  const _LastLoggedSetCard({required this.dashboard});

  final TodayDashboardReadModel dashboard;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final lastLoggedSet = dashboard.lastLoggedSet;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.todayLastLoggedTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: RepForgeSpacing.sm),
          Text(
            lastLoggedSet == null
                ? localizations.todayNoLastLoggedSet
                : localizations.todayLastLoggedSetSummary(
                    lastLoggedSet.exerciseName,
                    lastLoggedSet.repetitions,
                    _formatKilograms(context, lastLoggedSet.loadKg),
                  ),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _RestTimerCard extends StatelessWidget {
  const _RestTimerCard({required this.dashboard});

  final TodayDashboardReadModel dashboard;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final timer = dashboard.restTimer;

    final statusText = _restTimerStatusText(context, timer.status);
    final displayText = timer.isVisible ? timer.displayText : '--:--';

    return Semantics(
      label: '${localizations.todayRestTimerTitle}, $statusText, $displayText',
      child: AppCard(
        child: Wrap(
          spacing: RepForgeSpacing.md,
          runSpacing: RepForgeSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              timer.isVisible ? Icons.timer : Icons.timer_outlined,
              color: timer.isVisible
                  ? RepForgeColorTokens.accentPrimaryGreen
                  : RepForgeColorTokens.textSecondary,
              semanticLabel: localizations.todayRestTimerTitle,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 180, maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.todayRestTimerTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: RepForgeSpacing.xs),
                  Text(
                    statusText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: RepForgeColorTokens.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(displayText, style: Theme.of(context).textTheme.metricUnit),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.todayQuickActionTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: RepForgeSpacing.sm),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: FilledButton.icon(
              onPressed: null,
              icon: const Icon(Icons.add),
              label: Text(localizations.todayQuickActionLogSet),
            ),
          ),
          const SizedBox(height: RepForgeSpacing.sm),
          Text(
            localizations.todayQuickActionPlaceholder,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: RepForgeColorTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsHintCard extends StatelessWidget {
  const _AnalyticsHintCard();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.todayAnalyticsHintTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: RepForgeSpacing.xs),
          Text(
            localizations.todayAnalyticsHintMessage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: RepForgeColorTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

String _restTimerStatusText(BuildContext context, RestTimerStatus status) {
  final localizations = AppLocalizations.of(context);

  return switch (status) {
    RestTimerStatus.idle ||
    RestTimerStatus.cancelled => localizations.todayRestTimerIdle,
    RestTimerStatus.running => localizations.todayRestTimerRunning,
    RestTimerStatus.finished => localizations.todayRestTimerFinished,
  };
}

String _formatKilograms(BuildContext context, double value) {
  return '${_formatNumber(value, fractionDigits: 1)} kg';
}

String _formatNumber(double value, {required int fractionDigits}) {
  final formatted = value.toStringAsFixed(fractionDigits);
  if (!formatted.contains('.')) {
    return formatted;
  }

  return formatted.replaceFirst(RegExp(r'\.0$'), '');
}
