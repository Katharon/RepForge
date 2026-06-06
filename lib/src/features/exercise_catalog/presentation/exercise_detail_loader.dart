import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../analytics/application/analytics_application.dart';
import '../../training_log/domain/training_log_domain.dart';
import '../domain/exercise_catalog_domain.dart';
import 'exercise_catalog_loader.dart';

abstract interface class ExerciseDetailLoader {
  Future<ExerciseDetailViewModel> load(
    ExerciseRef exerciseRef, {
    Locale? locale,
    int historyLimit = 30,
  });
}

final class RepositoryExerciseDetailLoader implements ExerciseDetailLoader {
  const RepositoryExerciseDetailLoader({
    required this.exerciseCatalogRepository,
    required this.workoutSetRepository,
    required this.getExerciseAnalytics,
    this.customExerciseRepository,
    this.ensureCatalogImported,
    this.nowProvider = DateTime.now,
  });

  final ExerciseCatalogRepository exerciseCatalogRepository;
  final CustomExerciseRepository? customExerciseRepository;
  final WorkoutSetRepository workoutSetRepository;
  final GetExerciseAnalytics getExerciseAnalytics;
  final EnsureOfficialCatalogImported? ensureCatalogImported;
  final DateTime Function() nowProvider;

  @override
  Future<ExerciseDetailViewModel> load(
    ExerciseRef exerciseRef, {
    Locale? locale,
    int historyLimit = 30,
  }) async {
    await ensureCatalogImported?.call();
    final resolved = await _resolveExercise(exerciseRef, locale: locale);
    final boundedHistoryLimit = historyLimit.clamp(1, 100).toInt();
    final timeline = await workoutSetRepository.timelineForExercise(
      WorkoutSetTimelineQuery(
        exerciseRef: resolved.exerciseRef,
        limit: boundedHistoryLimit,
      ),
    );
    final now = nowProvider().toUtc();
    final analytics = await getExerciseAnalytics(
      ExerciseAnalyticsQuery(
        exerciseRef: resolved.exerciseRef,
        period: ExerciseAnalyticsPeriod(
          start: now.subtract(const Duration(days: 365)),
          end: now.add(const Duration(days: 1)),
        ),
        maxHistorySets: 100,
      ),
    );

    return ExerciseDetailViewModel(
      exerciseRef: resolved.exerciseRef,
      title: resolved.title,
      tags: resolved.tags,
      summary: ExerciseDetailSummaryViewModel.fromComparison(
        analytics.previousComparableSession,
        locale: locale,
      ),
      historyGroups: _groupHistory(timeline.items),
      historyLimit: boundedHistoryLimit,
      hasMoreHistory: timeline.hasMore,
    );
  }

  Future<_ResolvedExercise> _resolveExercise(
    ExerciseRef exerciseRef, {
    Locale? locale,
  }) async {
    if (exerciseRef.source != ExerciseSource.official) {
      final custom = await customExerciseRepository?.findCustomExerciseById(
        CustomExerciseId(exerciseRef.id),
      );
      if (custom != null) {
        return _ResolvedExercise(
          exerciseRef: ExerciseRef.custom(
            id: custom.id,
            displayNameSnapshot: custom.name,
          ),
          title: custom.name,
          tags: [
            ...custom.equipment.map((tag) => tag.value).take(2),
            ...custom.movementPatterns.map((pattern) => pattern.value).take(1),
            ...custom.primaryMuscles.map((muscle) => muscle.value).take(2),
          ],
        );
      }
      return _ResolvedExercise(
        exerciseRef: exerciseRef,
        title: exerciseRef.displayNameSnapshot,
        tags: const <String>[],
      );
    }

    final exercise = await exerciseCatalogRepository.findOfficialExerciseById(
      OfficialExerciseId(exerciseRef.id),
    );
    if (exercise == null) {
      throw StateError('Official exercise not found: ${exerciseRef.id}');
    }

    final title = locale?.languageCode == 'de'
        ? exercise.germanName
        : exercise.englishName;
    return _ResolvedExercise(
      exerciseRef: ExerciseRef.official(
        id: exercise.id,
        displayNameSnapshot: title,
        catalogVersionSnapshot: exercise.catalogVersion.value,
      ),
      title: title,
      tags: [
        ...exercise.equipment.map((tag) => tag.value).take(2),
        ...exercise.movementPatterns.map((pattern) => pattern.value).take(1),
        ...exercise.primaryMuscles.map((muscle) => muscle.value).take(2),
      ],
    );
  }
}

final class ExerciseDetailViewModel {
  const ExerciseDetailViewModel({
    required this.exerciseRef,
    required this.title,
    required this.tags,
    required this.summary,
    required this.historyGroups,
    required this.historyLimit,
    required this.hasMoreHistory,
  });

  final ExerciseRef exerciseRef;
  final String title;
  final List<String> tags;
  final ExerciseDetailSummaryViewModel summary;
  final List<ExerciseDetailHistoryGroupViewModel> historyGroups;
  final int historyLimit;
  final bool hasMoreHistory;

  bool get hasHistory {
    return historyGroups.any((group) => group.sets.isNotEmpty);
  }
}

final class ExerciseDetailSummaryViewModel {
  const ExerciseDetailSummaryViewModel({
    required this.previousAvailable,
    required this.metrics,
  });

  factory ExerciseDetailSummaryViewModel.fromComparison(
    ExerciseAnalyticsComparison comparison, {
    Locale? locale,
  }) {
    final current = comparison.current;
    final previous = comparison.previous;
    final previousAvailable =
        comparison.availability ==
        ExerciseAnalyticsComparisonAvailability.available;

    return ExerciseDetailSummaryViewModel(
      previousAvailable: previousAvailable,
      metrics: [
        ExerciseDetailMetricViewModel(
          label: 'Sets',
          value: _formatInteger(current.setCount, locale),
          delta: previousAvailable
              ? _formatSignedInteger(current.setCount - previous!.setCount)
              : null,
        ),
        ExerciseDetailMetricViewModel(
          label: 'Repetitions',
          value: _formatInteger(current.totalRepetitions, locale),
          delta: previousAvailable
              ? _formatSignedInteger(
                  current.totalRepetitions - previous!.totalRepetitions,
                )
              : null,
        ),
        ExerciseDetailMetricViewModel(
          label: 'Volume',
          value: _formatKg(current.totalVolumeKg, locale),
          delta: previousAvailable
              ? _formatSignedKg(current.totalVolumeKg - previous!.totalVolumeKg)
              : null,
        ),
        ExerciseDetailMetricViewModel(
          label: 'kg/rep',
          value: current.averageKgPerRep.isAvailable
              ? _formatKg(current.averageKgPerRep.value!, locale)
              : 'Unavailable',
          delta:
              previousAvailable &&
                  current.averageKgPerRep.isAvailable &&
                  previous!.averageKgPerRep.isAvailable
              ? _formatSignedKg(
                  current.averageKgPerRep.value! -
                      previous.averageKgPerRep.value!,
                )
              : null,
        ),
        ExerciseDetailMetricViewModel(
          label: 'Estimated 1RM',
          value: current.bestEstimatedOneRepMaxKg.isAvailable
              ? _formatKg(current.bestEstimatedOneRepMaxKg.value!, locale)
              : 'Unavailable',
          delta:
              previousAvailable &&
                  current.bestEstimatedOneRepMaxKg.isAvailable &&
                  previous!.bestEstimatedOneRepMaxKg.isAvailable
              ? _formatSignedKg(
                  current.bestEstimatedOneRepMaxKg.value! -
                      previous.bestEstimatedOneRepMaxKg.value!,
                )
              : null,
        ),
      ],
    );
  }

  final bool previousAvailable;
  final List<ExerciseDetailMetricViewModel> metrics;
}

final class ExerciseDetailMetricViewModel {
  const ExerciseDetailMetricViewModel({
    required this.label,
    required this.value,
    required this.delta,
  });

  final String label;
  final String value;
  final String? delta;
}

final class ExerciseDetailHistoryGroupViewModel {
  const ExerciseDetailHistoryGroupViewModel({
    required this.localDate,
    required this.sets,
  });

  final DateTime localDate;
  final List<ExerciseDetailSetViewModel> sets;
}

final class ExerciseDetailSetViewModel {
  const ExerciseDetailSetViewModel({
    required this.performedAt,
    required this.repetitions,
    required this.loadKg,
    required this.hasInputWarning,
    this.label = WorkoutSetLabel.none,
    this.comment,
  });

  final DateTime performedAt;
  final int repetitions;
  final double loadKg;
  final bool hasInputWarning;
  final WorkoutSetLabel label;
  final String? comment;
}

final class _ResolvedExercise {
  const _ResolvedExercise({
    required this.exerciseRef,
    required this.title,
    required this.tags,
  });

  final ExerciseRef exerciseRef;
  final String title;
  final List<String> tags;
}

List<ExerciseDetailHistoryGroupViewModel> _groupHistory(List<WorkoutSet> sets) {
  final grouped = <DateTime, List<ExerciseDetailSetViewModel>>{};
  for (final set in sets) {
    final local = set.performedAt.value.toLocal();
    final localDate = DateTime(local.year, local.month, local.day);
    grouped
        .putIfAbsent(localDate, () => <ExerciseDetailSetViewModel>[])
        .add(
          ExerciseDetailSetViewModel(
            performedAt: local,
            repetitions: set.repetitions.value,
            loadKg: set.load.value,
            hasInputWarning: const WorkoutSetInputGuard().isSetUnusuallyHigh(
              repetitions: set.repetitions,
              load: set.load,
            ),
            label: set.label,
            comment: set.comment?.value,
          ),
        );
  }

  return [
    for (final entry in grouped.entries)
      ExerciseDetailHistoryGroupViewModel(
        localDate: entry.key,
        sets: List<ExerciseDetailSetViewModel>.unmodifiable(entry.value),
      ),
  ];
}

String _formatInteger(int value, Locale? locale) {
  return NumberFormat.decimalPattern(locale?.languageCode).format(value);
}

String _formatSignedInteger(int value) {
  if (value == 0) {
    return '0';
  }
  return value > 0 ? '+$value' : '$value';
}

String _formatKg(double value, Locale? locale) {
  final formatter = NumberFormat.decimalPattern(locale?.languageCode)
    ..maximumFractionDigits = value.truncateToDouble() == value ? 0 : 1;
  return '${formatter.format(value)} kg';
}

String _formatSignedKg(double value) {
  if (value == 0) {
    return '0 kg';
  }
  final absolute = value.abs();
  final formatter = NumberFormat.decimalPattern()
    ..maximumFractionDigits = absolute.truncateToDouble() == absolute ? 0 : 1;
  final prefix = value > 0 ? '+' : '-';
  return '$prefix${formatter.format(absolute)} kg';
}
