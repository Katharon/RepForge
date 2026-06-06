import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../application/training_log_application.dart';
import '../domain/training_log_domain.dart';

class WorkoutSessionStatusCard extends StatefulWidget {
  const WorkoutSessionStatusCard({required this.controller, super.key});

  final WorkoutSessionController controller;

  @override
  State<WorkoutSessionStatusCard> createState() =>
      _WorkoutSessionStatusCardState();
}

class _WorkoutSessionStatusCardState extends State<WorkoutSessionStatusCard> {
  var _isCompleting = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<WorkoutSessionSnapshot>(
      stream: widget.controller.changes,
      initialData: widget.controller.snapshot,
      builder: (context, snapshot) {
        final state = snapshot.data ?? const WorkoutSessionSnapshot();
        final active = state.active;
        if (active != null) {
          return _WorkoutSessionSummaryCard(
            key: const Key('workout_session_active_card'),
            summary: state.activeSummary,
            active: active,
            isCompleting: _isCompleting,
            onComplete: _complete,
          );
        }

        final completed = state.completedSummary;
        if (completed != null &&
            completed.status == WorkoutSessionStatus.completed) {
          return _WorkoutSessionSummaryCard(
            key: const Key('workout_session_completed_card'),
            summary: completed,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Future<void> _complete() async {
    setState(() {
      _isCompleting = true;
    });
    try {
      await widget.controller.complete();
    } finally {
      if (mounted) {
        setState(() {
          _isCompleting = false;
        });
      }
    }
  }
}

class _WorkoutSessionSummaryCard extends StatelessWidget {
  const _WorkoutSessionSummaryCard({
    required this.summary,
    this.active,
    this.isCompleting = false,
    this.onComplete,
    super.key,
  });

  final WorkoutSessionSummary? summary;
  final ActiveWorkoutSession? active;
  final bool isCompleting;
  final Future<void> Function()? onComplete;

  bool get _isActive => active != null;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final summary = this.summary ?? _emptySummary(active!);
    final durationText = _formatDuration(summary.duration);
    final volumeText = _formatKilograms(context, summary.totalVolumeKg);
    final title = _isActive
        ? localizations.workoutSessionActiveTitle
        : localizations.workoutSessionCompletedTitle;
    final semantics = _isActive
        ? localizations.workoutSessionActiveSemantics(
            summary.source.name,
            durationText,
            summary.setCount,
            summary.exerciseCount,
            volumeText,
          )
        : localizations.workoutSessionCompletedSemantics(
            summary.source.name,
            durationText,
            summary.setCount,
            summary.exerciseCount,
            volumeText,
          );

    return Semantics(
      label: semantics,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _isActive ? Icons.play_circle_outline : Icons.check_circle,
                  color: _isActive
                      ? RepForgeColorTokens.accentPrimaryGreen
                      : RepForgeColorTokens.success,
                ),
                const SizedBox(width: RepForgeSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: RepForgeSpacing.xs),
                      Text(
                        localizations.workoutSessionSource(summary.source.name),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: RepForgeColorTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isActive && onComplete != null)
                  FilledButton.icon(
                    key: const Key('workout_session_complete_button'),
                    onPressed: isCompleting
                        ? null
                        : () {
                            unawaited(onComplete!());
                          },
                    icon: isCompleting
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.done),
                    label: Text(
                      isCompleting
                          ? localizations.workoutSessionCompleting
                          : localizations.workoutSessionComplete,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: RepForgeSpacing.md),
            Wrap(
              spacing: RepForgeSpacing.md,
              runSpacing: RepForgeSpacing.md,
              children: [
                _SessionMetricTile(
                  label: localizations.workoutSessionDuration,
                  value: durationText,
                ),
                _SessionMetricTile(
                  label: localizations.workoutSessionSets,
                  value: summary.setCount.toString(),
                ),
                _SessionMetricTile(
                  label: localizations.workoutSessionExercises,
                  value: summary.exerciseCount.toString(),
                ),
                _SessionMetricTile(
                  label: localizations.workoutSessionVolume,
                  value: volumeText,
                ),
              ],
            ),
            if (!_isActive) ...[
              const SizedBox(height: RepForgeSpacing.md),
              Text(
                _topExerciseText(localizations, summary),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: RepForgeColorTokens.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SessionMetricTile extends StatelessWidget {
  const _SessionMetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
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
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: RepForgeColorTokens.textSecondary,
                ),
              ),
              const SizedBox(height: RepForgeSpacing.xs),
              Text(value, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
      ),
    );
  }
}

WorkoutSessionSummary _emptySummary(ActiveWorkoutSession active) {
  return WorkoutSessionSummary.fromSets(
    session: active,
    status: WorkoutSessionStatus.active,
    sets: const <WorkoutSet>[],
    measuredAt: DateTime.now(),
  );
}

String _topExerciseText(
  AppLocalizations localizations,
  WorkoutSessionSummary summary,
) {
  final top = summary.topExercise;
  if (top == null) {
    return localizations.workoutSessionNoSets;
  }
  return localizations.workoutSessionTopExercise(
    top.exerciseRef.displayNameSnapshot,
  );
}

String _formatKilograms(BuildContext context, double value) {
  final formatter = NumberFormat.decimalPattern(
    Localizations.localeOf(context).toLanguageTag(),
  )..maximumFractionDigits = value.truncateToDouble() == value ? 0 : 1;
  return '${formatter.format(value)} kg';
}

String _formatDuration(Duration duration) {
  final totalMinutes = duration.inMinutes;
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;
  if (hours <= 0) {
    return '${minutes}m';
  }
  return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
}
