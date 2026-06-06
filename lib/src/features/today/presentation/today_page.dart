import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../recovery/domain/recovery_domain.dart';
import '../../rest_timer/domain/rest_timer_domain.dart';
import '../../training_log/application/training_log_application.dart';
import '../../training_log/domain/training_log_domain.dart';
import '../../training_log/presentation/training_log_presentation.dart';
import 'today_dashboard_loader.dart';
import 'today_dashboard_models.dart';

typedef TodayLogSetAction = Future<bool> Function(BuildContext context);

enum TodayDashboardStatus { loading, empty, error, success }

final class TodayDashboardState {
  const TodayDashboardState({required this.status, this.dashboard, this.error});

  final TodayDashboardStatus status;
  final TodayDashboardReadModel? dashboard;
  final Object? error;
}

class TodayPage extends StatefulWidget {
  const TodayPage({
    required this.loader,
    super.key,
    this.workoutSessionController,
    this.logSetAction,
  });

  final TodayDashboardLoader loader;
  final WorkoutSessionController? workoutSessionController;
  final TodayLogSetAction? logSetAction;

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
          children: [
            _TodayStateBody(
              state: _state,
              onRetry: _load,
              workoutSessionController: widget.workoutSessionController,
              logSetAction: widget.logSetAction,
            ),
          ],
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
          status:
              dashboard.hasLoggedSets ||
                  dashboard.hasVisibleRestTimer ||
                  dashboard.hasReadinessEstimate
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
  const _TodayStateBody({
    required this.state,
    required this.onRetry,
    required this.workoutSessionController,
    required this.logSetAction,
  });

  final TodayDashboardState state;
  final VoidCallback onRetry;
  final WorkoutSessionController? workoutSessionController;
  final TodayLogSetAction? logSetAction;

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case TodayDashboardStatus.loading:
        return const _TodayLoadingState();
      case TodayDashboardStatus.empty:
        return _TodayEmptyState(
          dashboard: state.dashboard,
          onReload: onRetry,
          workoutSessionController: workoutSessionController,
          logSetAction: logSetAction,
        );
      case TodayDashboardStatus.error:
        return _TodayErrorState(onRetry: onRetry);
      case TodayDashboardStatus.success:
        return _TodaySuccessState(
          dashboard: state.dashboard!,
          onReload: onRetry,
          workoutSessionController: workoutSessionController,
          logSetAction: logSetAction,
        );
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
  const _TodayEmptyState({
    required this.dashboard,
    required this.onReload,
    required this.workoutSessionController,
    required this.logSetAction,
  });

  final TodayDashboardReadModel? dashboard;
  final VoidCallback onReload;
  final WorkoutSessionController? workoutSessionController;
  final TodayLogSetAction? logSetAction;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _WorkoutSessionSection(controller: workoutSessionController),
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
          if (dashboard!.hasReadinessEstimate) ...[
            _ReadinessCard(dashboard: dashboard!),
            const SizedBox(height: RepForgeSpacing.md),
          ],
          _RestTimerCard(dashboard: dashboard!),
          const SizedBox(height: RepForgeSpacing.md),
        ],
        _QuickActionCard(onLogSet: logSetAction == null ? null : _logSet),
      ],
    );
  }

  Future<void> _logSet(BuildContext context) async {
    final saved = await logSetAction!(context);
    if (saved) {
      onReload();
    }
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
  const _TodaySuccessState({
    required this.dashboard,
    required this.onReload,
    required this.workoutSessionController,
    required this.logSetAction,
  });

  final TodayDashboardReadModel dashboard;
  final VoidCallback onReload;
  final WorkoutSessionController? workoutSessionController;
  final TodayLogSetAction? logSetAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _WorkoutSessionSection(controller: workoutSessionController),
        _MetricStrip(dashboard: dashboard),
        const SizedBox(height: RepForgeSpacing.md),
        _ReadinessCard(dashboard: dashboard),
        const SizedBox(height: RepForgeSpacing.md),
        _LastLoggedSetCard(dashboard: dashboard),
        const SizedBox(height: RepForgeSpacing.md),
        _RestTimerCard(dashboard: dashboard),
        const SizedBox(height: RepForgeSpacing.md),
        _QuickActionCard(onLogSet: logSetAction == null ? null : _logSet),
        const SizedBox(height: RepForgeSpacing.md),
        const _AnalyticsHintCard(),
      ],
    );
  }

  Future<void> _logSet(BuildContext context) async {
    final saved = await logSetAction!(context);
    if (saved) {
      onReload();
    }
  }
}

class _WorkoutSessionSection extends StatelessWidget {
  const _WorkoutSessionSection({required this.controller});

  final WorkoutSessionController? controller;

  @override
  Widget build(BuildContext context) {
    final controller = this.controller;
    if (controller == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<WorkoutSessionSnapshot>(
      stream: controller.changes,
      initialData: controller.snapshot,
      builder: (context, snapshot) {
        final sessionState = snapshot.data ?? const WorkoutSessionSnapshot();
        if (sessionState.active == null &&
            sessionState.completedSummary == null) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            WorkoutSessionStatusCard(controller: controller),
            const SizedBox(height: RepForgeSpacing.md),
          ],
        );
      },
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
                warning: dashboard.hasUnusuallyHighDailyVolume
                    ? localizations.todayHighVolumeWarning
                    : null,
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
    this.warning,
  });

  final String label;
  final String value;
  final Color color;
  final String? warning;

  @override
  Widget build(BuildContext context) {
    final warning = this.warning;
    final semanticsLabel = warning == null
        ? '$label, $value'
        : '$label, $value. $warning';

    return Semantics(
      label: semanticsLabel,
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
            if (warning != null) ...[
              const SizedBox(height: RepForgeSpacing.sm),
              _InputGuardWarningChip(message: warning),
            ],
          ],
        ),
      ),
    );
  }
}

class _InputGuardWarningChip extends StatelessWidget {
  const _InputGuardWarningChip({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Semantics(
      label: localizations.inputGuardWarningSemantics,
      child: InputChip(
        avatar: const Icon(Icons.warning_amber, size: 18),
        label: Text(message),
      ),
    );
  }
}

class _ReadinessCard extends StatelessWidget {
  const _ReadinessCard({required this.dashboard});

  final TodayDashboardReadModel dashboard;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final readiness = dashboard.readiness;
    final level = readiness.level;
    final score = readiness.score;
    final levelText = level == null
        ? localizations.todayReadinessUnavailable
        : _readinessLevelText(context, level);
    final scoreText = score == null
        ? localizations.todayReadinessNoScore
        : localizations.todayReadinessScore(score.value);

    return Semantics(
      label:
          '${localizations.todayReadinessTitle}, $levelText, $scoreText. '
          '${localizations.todayReadinessEstimateNote}',
      child: AppCard(
        child: Wrap(
          spacing: RepForgeSpacing.md,
          runSpacing: RepForgeSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Icon(
              Icons.battery_saver_outlined,
              color: RepForgeColorTokens.accentPrimaryGreen,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 180, maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.todayReadinessTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: RepForgeSpacing.xs),
                  Text(
                    levelText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: RepForgeColorTokens.textSecondary,
                    ),
                  ),
                  const SizedBox(height: RepForgeSpacing.xs),
                  Text(
                    localizations.todayReadinessEstimateNote,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: RepForgeColorTokens.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(scoreText, style: Theme.of(context).textTheme.metricUnit),
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
  const _QuickActionCard({required this.onLogSet});

  final Future<void> Function(BuildContext context)? onLogSet;

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
              onPressed: onLogSet == null ? null : () => onLogSet!(context),
              icon: const Icon(Icons.add),
              label: Text(localizations.todayQuickActionLogSet),
            ),
          ),
          const SizedBox(height: RepForgeSpacing.sm),
          Text(
            localizations.todayQuickActionMessage,
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

String _readinessLevelText(BuildContext context, ReadinessLevel level) {
  final localizations = AppLocalizations.of(context);

  return switch (level) {
    ReadinessLevel.high => localizations.todayReadinessHigh,
    ReadinessLevel.medium => localizations.todayReadinessMedium,
    ReadinessLevel.low => localizations.todayReadinessLow,
    ReadinessLevel.veryLow => localizations.todayReadinessVeryLow,
  };
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
