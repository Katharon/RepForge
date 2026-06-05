import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import 'muscle_load_dashboard_loader.dart';
import 'muscle_load_dashboard_view_model.dart';

enum MuscleLoadDashboardUiStatus { loading, empty, error, success }

final class MuscleLoadDashboardUiState {
  const MuscleLoadDashboardUiState({
    required this.status,
    this.viewModel,
    this.error,
  });

  final MuscleLoadDashboardUiStatus status;
  final MuscleLoadDashboardViewModel? viewModel;
  final Object? error;
}

class MuscleLoadDashboardSection extends StatefulWidget {
  const MuscleLoadDashboardSection({
    required this.loader,
    super.key,
    this.nowProvider,
  });

  final MuscleLoadDashboardLoader loader;
  final MuscleLoadDashboardNowProvider? nowProvider;

  @override
  State<MuscleLoadDashboardSection> createState() =>
      _MuscleLoadDashboardSectionState();
}

class _MuscleLoadDashboardSectionState
    extends State<MuscleLoadDashboardSection> {
  var _requestVersion = 0;
  var _state = const MuscleLoadDashboardUiState(
    status: MuscleLoadDashboardUiStatus.loading,
  );

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void didUpdateWidget(covariant MuscleLoadDashboardSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.loader != widget.loader) {
      unawaited(_load());
    }
  }

  @override
  Widget build(BuildContext context) {
    return switch (_state.status) {
      MuscleLoadDashboardUiStatus.loading =>
        const _MuscleLoadDashboardLoadingState(),
      MuscleLoadDashboardUiStatus.empty =>
        const _MuscleLoadDashboardEmptyState(),
      MuscleLoadDashboardUiStatus.error => _MuscleLoadDashboardErrorState(
        onRetry: _load,
      ),
      MuscleLoadDashboardUiStatus.success => _MuscleLoadDashboardSuccessState(
        viewModel: _state.viewModel!,
      ),
    };
  }

  Future<void> _load() async {
    final requestVersion = ++_requestVersion;
    setState(() {
      _state = const MuscleLoadDashboardUiState(
        status: MuscleLoadDashboardUiStatus.loading,
      );
    });

    try {
      final model = await widget.loader.load(
        MuscleLoadDashboardLoadRequest(
          now: (widget.nowProvider ?? DateTime.now)(),
        ),
      );
      if (!mounted || requestVersion != _requestVersion) {
        return;
      }
      final viewModel = MuscleLoadDashboardViewModel.fromReadModel(model);
      setState(() {
        _state = MuscleLoadDashboardUiState(
          status:
              viewModel.overallStatus == MuscleLoadDashboardOverallStatus.empty
              ? MuscleLoadDashboardUiStatus.empty
              : MuscleLoadDashboardUiStatus.success,
          viewModel: viewModel,
        );
      });
    } catch (error) {
      if (!mounted || requestVersion != _requestVersion) {
        return;
      }
      setState(() {
        _state = MuscleLoadDashboardUiState(
          status: MuscleLoadDashboardUiStatus.error,
          error: error,
        );
      });
    }
  }
}

class _MuscleLoadDashboardLoadingState extends StatelessWidget {
  const _MuscleLoadDashboardLoadingState();

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
          Expanded(child: Text(localizations.analyticsMuscleLoadLoading)),
        ],
      ),
    );
  }
}

class _MuscleLoadDashboardEmptyState extends StatelessWidget {
  const _MuscleLoadDashboardEmptyState();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.monitor_heart_outlined),
          const SizedBox(height: RepForgeSpacing.md),
          Text(
            localizations.analyticsMuscleLoadEmptyTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: RepForgeSpacing.xs),
          Text(
            localizations.analyticsMuscleLoadEmptyMessage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: RepForgeColorTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MuscleLoadDashboardErrorState extends StatelessWidget {
  const _MuscleLoadDashboardErrorState({required this.onRetry});

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
            localizations.analyticsMuscleLoadErrorTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: RepForgeSpacing.xs),
          Text(
            localizations.analyticsMuscleLoadErrorMessage,
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

class _MuscleLoadDashboardSuccessState extends StatelessWidget {
  const _MuscleLoadDashboardSuccessState({required this.viewModel});

  final MuscleLoadDashboardViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.analyticsMuscleLoadTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: RepForgeSpacing.xs),
        Text(
          localizations.analyticsMuscleLoadSubtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: RepForgeColorTokens.textSecondary,
          ),
        ),
        const SizedBox(height: RepForgeSpacing.md),
        _MuscleLoadMetricCards(viewModel: viewModel),
        const SizedBox(height: RepForgeSpacing.md),
        _FocusExplanationCard(viewModel: viewModel),
        if (viewModel.topMuscles.isNotEmpty) ...[
          const SizedBox(height: RepForgeSpacing.md),
          _MuscleCoverageCard(viewModel: viewModel),
        ],
        const SizedBox(height: RepForgeSpacing.md),
        for (final signal in viewModel.signals) ...[
          _MuscleBalanceSignalCard(signal: signal),
          const SizedBox(height: RepForgeSpacing.md),
        ],
      ],
    );
  }
}

class _MuscleLoadMetricCards extends StatelessWidget {
  const _MuscleLoadMetricCards({required this.viewModel});

  final MuscleLoadDashboardViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = RepForgeSpacing.md;
        final cardWidth = constraints.maxWidth >= 720
            ? (constraints.maxWidth - spacing * 2) / 3
            : constraints.maxWidth >= 480
            ? (constraints.maxWidth - spacing) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            SizedBox(
              width: cardWidth,
              child: _MetricCard(
                label: localizations.analyticsMuscleLoadWeeklyMetric,
                value: _formatKilograms(context, viewModel.weeklyLoadKg),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _MetricCard(
                label: localizations.analyticsMuscleLoadRollingMetric,
                value: _formatKilograms(context, viewModel.rollingLoadKg),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _MetricCard(
                label: localizations.analyticsMuscleLoadCoverageMetric,
                value: localizations.analyticsMuscleLoadLoggedSets(
                  viewModel.loggedSetCount,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value});

  final String label;
  final String value;

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
              style: Theme.of(context).textTheme.metricValue.copyWith(
                color: RepForgeColorTokens.metricVolumeBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FocusExplanationCard extends StatelessWidget {
  const _FocusExplanationCard({required this.viewModel});

  final MuscleLoadDashboardViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.analyticsMuscleLoadFocusTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: RepForgeSpacing.xs),
          Text(
            _focusExplanation(context, viewModel.focusProfile),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: RepForgeColorTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MuscleCoverageCard extends StatelessWidget {
  const _MuscleCoverageCard({required this.viewModel});

  final MuscleLoadDashboardViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.analyticsMuscleLoadTopMusclesTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: RepForgeSpacing.md),
          for (final muscle in viewModel.topMuscles) ...[
            _MuscleLoadRow(muscle: muscle),
            const SizedBox(height: RepForgeSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _MuscleLoadRow extends StatelessWidget {
  const _MuscleLoadRow({required this.muscle});

  final MuscleLoadMetricViewModel muscle;

  @override
  Widget build(BuildContext context) {
    final label = _muscleLabel(context, muscle.muscleId);
    final value = _formatKilograms(context, muscle.estimatedLoadKg);

    return Semantics(
      label: '$label, $value',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label)),
              const SizedBox(width: RepForgeSpacing.md),
              Text(
                value,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: RepForgeColorTokens.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: RepForgeSpacing.xs),
          LinearProgressIndicator(
            value: muscle.share.clamp(0, 1),
            minHeight: 6,
            backgroundColor: RepForgeColorTokens.surfaceCardElevated,
            color: RepForgeColorTokens.metricVolumeBlue,
          ),
        ],
      ),
    );
  }
}

class _MuscleBalanceSignalCard extends StatelessWidget {
  const _MuscleBalanceSignalCard({required this.signal});

  final MuscleBalanceSignalViewModel signal;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final label = _signalStatusLabel(context, signal.status);
    final explanation = _signalExplanation(context, signal);
    final action = _signalAction(context, signal);

    return Semantics(
      label:
          '${localizations.analyticsMuscleLoadSignalSemantics(label)}, '
          '$explanation ${localizations.analyticsMuscleLoadSuggestedAction}: '
          '$action',
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: RepForgeSpacing.sm,
              runSpacing: RepForgeSpacing.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _StatusPill(status: signal.status, label: label),
                Text(
                  _signalTitle(context, signal),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: RepForgeSpacing.sm),
            Text(
              explanation,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: RepForgeColorTokens.textSecondary,
              ),
            ),
            const SizedBox(height: RepForgeSpacing.md),
            Text(
              '${localizations.analyticsMuscleLoadSuggestedAction}: $action',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status, required this.label});

  final MuscleLoadSignalStatus status;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _statusColor(status).withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(RepForgeRadius.sm),
        border: Border.all(color: _statusColor(status)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: RepForgeSpacing.sm,
          vertical: RepForgeSpacing.xs,
        ),
        child: Text(label, style: Theme.of(context).textTheme.labelMedium),
      ),
    );
  }
}

Color _statusColor(MuscleLoadSignalStatus status) {
  return switch (status) {
    MuscleLoadSignalStatus.onTrack => RepForgeColorTokens.success,
    MuscleLoadSignalStatus.underTarget => RepForgeColorTokens.warning,
    MuscleLoadSignalStatus.overEmphasized =>
      RepForgeColorTokens.accentWeightOrange,
    MuscleLoadSignalStatus.partialData => RepForgeColorTokens.metricVolumeBlue,
    MuscleLoadSignalStatus.recoveryLimited =>
      RepForgeColorTokens.accentOneRepMaxPurple,
  };
}

String _signalStatusLabel(BuildContext context, MuscleLoadSignalStatus status) {
  final localizations = AppLocalizations.of(context);

  return switch (status) {
    MuscleLoadSignalStatus.onTrack =>
      localizations.analyticsMuscleLoadStatusOnTrack,
    MuscleLoadSignalStatus.underTarget =>
      localizations.analyticsMuscleLoadStatusUnderTarget,
    MuscleLoadSignalStatus.overEmphasized =>
      localizations.analyticsMuscleLoadStatusOverEmphasized,
    MuscleLoadSignalStatus.partialData =>
      localizations.analyticsMuscleLoadStatusPartialData,
    MuscleLoadSignalStatus.recoveryLimited =>
      localizations.analyticsMuscleLoadStatusRecoveryLimited,
  };
}

String _signalTitle(BuildContext context, MuscleBalanceSignalViewModel signal) {
  final localizations = AppLocalizations.of(context);

  return switch (signal.code) {
    'muscle_load.recovery_limited' =>
      localizations.analyticsMuscleLoadRecoveryTitle,
    'muscle_balance.balanced' => localizations.analyticsMuscleLoadBalancedTitle,
    'muscle_balance.push_heavy' =>
      localizations.analyticsMuscleLoadPushHeavyTitle,
    'muscle_balance.pull_neglect' =>
      localizations.analyticsMuscleLoadPullNeglectTitle,
    'muscle_balance.leg_neglect' || 'muscle_balance.lower_body_under_target' =>
      localizations.analyticsMuscleLoadLowerUnderTitle,
    'muscle_balance.upper_body_under_target' =>
      localizations.analyticsMuscleLoadUpperUnderTitle,
    'muscle_balance.movement_pattern_gap' =>
      localizations.analyticsMuscleLoadMovementGapTitle,
    'muscle_balance.incomplete_activation_data' =>
      localizations.analyticsMuscleLoadPartialTitle,
    'muscle_balance.insufficient_data' =>
      localizations.analyticsMuscleLoadInsufficientTitle,
    _ => localizations.analyticsMuscleLoadSignalTitle,
  };
}

String _signalExplanation(
  BuildContext context,
  MuscleBalanceSignalViewModel signal,
) {
  final localizations = AppLocalizations.of(context);

  return switch (signal.code) {
    'muscle_load.recovery_limited' =>
      localizations.analyticsMuscleLoadRecoveryExplanation,
    'muscle_balance.balanced' =>
      localizations.analyticsMuscleLoadBalancedExplanation,
    'muscle_balance.push_heavy' =>
      localizations.analyticsMuscleLoadPushHeavyExplanation,
    'muscle_balance.pull_neglect' =>
      localizations.analyticsMuscleLoadPullNeglectExplanation,
    'muscle_balance.leg_neglect' || 'muscle_balance.lower_body_under_target' =>
      localizations.analyticsMuscleLoadLowerUnderExplanation,
    'muscle_balance.upper_body_under_target' =>
      localizations.analyticsMuscleLoadUpperUnderExplanation,
    'muscle_balance.movement_pattern_gap' =>
      localizations.analyticsMuscleLoadMovementGapExplanation,
    'muscle_balance.incomplete_activation_data' =>
      localizations.analyticsMuscleLoadPartialExplanation,
    'muscle_balance.insufficient_data' =>
      localizations.analyticsMuscleLoadInsufficientExplanation,
    _ => localizations.analyticsMuscleLoadSignalExplanation,
  };
}

String _signalAction(
  BuildContext context,
  MuscleBalanceSignalViewModel signal,
) {
  final localizations = AppLocalizations.of(context);

  return switch (signal.code) {
    'muscle_load.recovery_limited' =>
      localizations.analyticsMuscleLoadRecoveryAction,
    'muscle_balance.balanced' =>
      localizations.analyticsMuscleLoadBalancedAction,
    'muscle_balance.push_heavy' =>
      localizations.analyticsMuscleLoadPushHeavyAction,
    'muscle_balance.pull_neglect' =>
      localizations.analyticsMuscleLoadPullNeglectAction,
    'muscle_balance.leg_neglect' || 'muscle_balance.lower_body_under_target' =>
      localizations.analyticsMuscleLoadLowerUnderAction,
    'muscle_balance.upper_body_under_target' =>
      localizations.analyticsMuscleLoadUpperUnderAction,
    'muscle_balance.movement_pattern_gap' =>
      localizations.analyticsMuscleLoadMovementGapAction,
    'muscle_balance.incomplete_activation_data' =>
      localizations.analyticsMuscleLoadPartialAction,
    'muscle_balance.insufficient_data' =>
      localizations.analyticsMuscleLoadInsufficientAction,
    _ => localizations.analyticsMuscleLoadSignalAction,
  };
}

String _focusExplanation(BuildContext context, Object focusProfile) {
  final localizations = AppLocalizations.of(context);
  final value = focusProfile.toString().split('.').last;

  return switch (value) {
    'upperBodyFocus' => localizations.analyticsMuscleLoadFocusUpper,
    'lowerBodyGluteFocus' => localizations.analyticsMuscleLoadFocusLower,
    'armsChestFocus' => localizations.analyticsMuscleLoadFocusArmsChest,
    'strengthBasics' => localizations.analyticsMuscleLoadFocusStrength,
    'timeEfficient' => localizations.analyticsMuscleLoadFocusTimeEfficient,
    'beginnerFoundation' => localizations.analyticsMuscleLoadFocusBeginner,
    _ => localizations.analyticsMuscleLoadFocusBalanced,
  };
}

String _muscleLabel(BuildContext context, String muscleId) {
  final localizations = AppLocalizations.of(context);

  return switch (muscleId) {
    'chest' => localizations.analyticsMuscleChest,
    'triceps' => localizations.analyticsMuscleTriceps,
    'front_deltoids' => localizations.analyticsMuscleFrontDeltoids,
    'shoulders' => localizations.analyticsMuscleShoulders,
    'upper_chest' => localizations.analyticsMuscleUpperChest,
    'lats' => localizations.analyticsMuscleLats,
    'upper_back' => localizations.analyticsMuscleUpperBack,
    'rear_deltoids' => localizations.analyticsMuscleRearDeltoids,
    'biceps' => localizations.analyticsMuscleBiceps,
    'forearms' => localizations.analyticsMuscleForearms,
    'traps' => localizations.analyticsMuscleTraps,
    'quadriceps' => localizations.analyticsMuscleQuadriceps,
    'hamstrings' => localizations.analyticsMuscleHamstrings,
    'glutes' => localizations.analyticsMuscleGlutes,
    'calves' => localizations.analyticsMuscleCalves,
    'erector_spinae' => localizations.analyticsMuscleErectorSpinae,
    'core' => localizations.analyticsMuscleCore,
    _ => muscleId.replaceAll('_', ' '),
  };
}

String _formatKilograms(BuildContext context, double value) {
  final localizations = AppLocalizations.of(context);
  final formatted = value.toStringAsFixed(0);

  return '$formatted ${localizations.analyticsUnitKilograms}';
}
