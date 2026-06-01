import 'package:repforge/src/features/analytics/domain/analytics_domain.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

import '../read_models/exercise_analytics_read_model.dart';

final class ExerciseAnalyticsQuery {
  ExerciseAnalyticsQuery({
    required this.exerciseRef,
    required this.period,
    int maxHistorySets = 500,
  }) : maxHistorySets = _requireMaxHistorySets(maxHistorySets);

  final ExerciseRef exerciseRef;
  final ExerciseAnalyticsPeriod period;
  final int maxHistorySets;
}

final class GetExerciseAnalytics {
  const GetExerciseAnalytics(
    this._workoutSetRepository, {
    this._formulaService = const WorkoutSetAnalyticsFormulaService(),
  });

  final WorkoutSetRepository _workoutSetRepository;
  final WorkoutSetAnalyticsFormulaService _formulaService;

  Future<ExerciseAnalyticsReadModel> call(ExerciseAnalyticsQuery query) async {
    final previousPeriod = query.period.previousEqualLength;
    final scan = await _scanBoundedHistory(
      exerciseRef: query.exerciseRef,
      earliestIncludedAt: previousPeriod.start,
      latestExcludedAt: query.period.end,
      maxHistorySets: query.maxHistorySets,
    );

    final currentSets = scan.sets
        .where((WorkoutSet set) => query.period.contains(set.performedAt.value))
        .toList(growable: false);
    final previousPeriodSets = scan.sets
        .where(
          (WorkoutSet set) => previousPeriod.contains(set.performedAt.value),
        )
        .toList(growable: false);
    final overview = _overviewFor(currentSets);

    return ExerciseAnalyticsReadModel(
      exerciseRef: query.exerciseRef,
      period: query.period,
      previousPeriod: previousPeriod,
      overview: overview,
      previousComparableSession: _previousComparableSessionFor(
        scan.sets,
        currentSets,
      ),
      timeWindow: _comparisonFor(
        current: overview,
        previous: _overviewFor(previousPeriodSets),
        requireNonEmptyCurrent: false,
      ),
      scannedSetCount: scan.scannedSetCount,
      reachedHistoryLimit: scan.reachedHistoryLimit,
    );
  }

  Future<_HistoryScan> _scanBoundedHistory({
    required ExerciseRef exerciseRef,
    required DateTime earliestIncludedAt,
    required DateTime latestExcludedAt,
    required int maxHistorySets,
  }) async {
    final collected = <WorkoutSet>[];
    var scannedSetCount = 0;
    var reachedHistoryLimit = false;
    WorkoutSetTimelineCursor? cursor;

    while (scannedSetCount < maxHistorySets) {
      final remaining = maxHistorySets - scannedSetCount;
      final page = await _workoutSetRepository.timelineForExercise(
        WorkoutSetTimelineQuery(
          exerciseRef: exerciseRef,
          limit: remaining > 100 ? 100 : remaining,
          after: cursor,
        ),
      );
      if (page.items.isEmpty) {
        break;
      }

      scannedSetCount += page.items.length;
      for (final set in page.items) {
        final performedAt = set.performedAt.value.toUtc();
        if (!performedAt.isBefore(latestExcludedAt)) {
          continue;
        }
        if (performedAt.isBefore(earliestIncludedAt)) {
          continue;
        }
        collected.add(set);
      }

      final oldestInPage = page.items.last.performedAt.value.toUtc();
      if (scannedSetCount >= maxHistorySets) {
        reachedHistoryLimit = page.hasMore;
        break;
      }
      if (oldestInPage.isBefore(earliestIncludedAt)) {
        break;
      }
      if (!page.hasMore || page.nextCursor == null) {
        break;
      }

      cursor = page.nextCursor;
    }

    return _HistoryScan(
      sets: collected,
      scannedSetCount: scannedSetCount,
      reachedHistoryLimit: reachedHistoryLimit,
    );
  }

  ExerciseAnalyticsComparison _previousComparableSessionFor(
    List<WorkoutSet> scannedSets,
    List<WorkoutSet> currentPeriodSets,
  ) {
    if (currentPeriodSets.isEmpty) {
      return _comparisonFor(
        current: _overviewFor(const <WorkoutSet>[]),
        previous: null,
        availability: ExerciseAnalyticsComparisonAvailability.missingCurrent,
      );
    }

    final currentGroupKey = _sessionGroupKeyFor(
      currentPeriodSets.reduce(_newerSet),
    );
    final groups = <_SessionGroupKey, List<WorkoutSet>>{};
    for (final set in scannedSets) {
      final groupKey = _sessionGroupKeyFor(set);
      groups.putIfAbsent(groupKey, () => <WorkoutSet>[]).add(set);
    }

    final currentGroupSets =
        groups[currentGroupKey]?.toList(growable: false) ??
        const <WorkoutSet>[];
    final previousGroupSets = _previousGroupSetsFor(
      groups,
      currentGroupKey,
      currentGroupSets,
    );

    return _comparisonFor(
      current: _overviewFor(currentGroupSets),
      previous: previousGroupSets == null
          ? null
          : _overviewFor(previousGroupSets),
    );
  }

  List<WorkoutSet>? _previousGroupSetsFor(
    Map<_SessionGroupKey, List<WorkoutSet>> groups,
    _SessionGroupKey currentGroupKey,
    List<WorkoutSet> currentGroupSets,
  ) {
    if (currentGroupSets.isEmpty) {
      return null;
    }

    final currentOldest = currentGroupSets.reduce(_olderSet).performedAt.value;
    final candidates = groups.entries
        .where((MapEntry<_SessionGroupKey, List<WorkoutSet>> entry) {
          if (entry.key == currentGroupKey) {
            return false;
          }

          final newest = entry.value.reduce(_newerSet).performedAt.value;
          return newest.isBefore(currentOldest) || newest == currentOldest;
        })
        .toList(growable: false);
    if (candidates.isEmpty) {
      return null;
    }

    candidates.sort((
      MapEntry<_SessionGroupKey, List<WorkoutSet>> a,
      MapEntry<_SessionGroupKey, List<WorkoutSet>> b,
    ) {
      final aNewest = a.value.reduce(_newerSet).performedAt.value;
      final bNewest = b.value.reduce(_newerSet).performedAt.value;
      return bNewest.compareTo(aNewest);
    });

    return candidates.first.value.toList(growable: false);
  }

  ExerciseAnalyticsOverview _overviewFor(List<WorkoutSet> sets) {
    return ExerciseAnalyticsOverview.fromSummary(
      _formulaService.summarize(sets),
    );
  }

  ExerciseAnalyticsComparison _comparisonFor({
    required ExerciseAnalyticsOverview current,
    required ExerciseAnalyticsOverview? previous,
    bool requireNonEmptyCurrent = true,
    ExerciseAnalyticsComparisonAvailability? availability,
  }) {
    final resolvedAvailability =
        availability ??
        (requireNonEmptyCurrent && current.isEmpty
            ? ExerciseAnalyticsComparisonAvailability.missingCurrent
            : previous == null || previous.isEmpty
            ? ExerciseAnalyticsComparisonAvailability.missingPrevious
            : ExerciseAnalyticsComparisonAvailability.available);

    return ExerciseAnalyticsComparison(
      current: current,
      previous: previous,
      availability: resolvedAvailability,
      totalVolumeKgDelta: ExerciseMetricDelta.fromValues(
        current: current.totalVolumeKg,
        previous: previous?.isEmpty ?? true ? null : previous!.totalVolumeKg,
      ),
      bestEstimatedOneRepMaxKgDelta: ExerciseMetricDelta.fromValues(
        current: current.bestEstimatedOneRepMaxKg.value ?? 0,
        previous: previous?.bestEstimatedOneRepMaxKg.value,
      ),
    );
  }
}

int _requireMaxHistorySets(int value) {
  if (value <= 0 || value > 2000) {
    throw const AnalyticsValidationException(
      'exerciseAnalytics.maxHistorySets',
      'Must be between 1 and 2000.',
    );
  }

  return value;
}

WorkoutSet _newerSet(WorkoutSet a, WorkoutSet b) {
  final compared = a.performedAt.value.compareTo(b.performedAt.value);
  if (compared != 0) {
    return compared > 0 ? a : b;
  }

  return a.id.value.compareTo(b.id.value) >= 0 ? a : b;
}

WorkoutSet _olderSet(WorkoutSet a, WorkoutSet b) {
  final compared = a.performedAt.value.compareTo(b.performedAt.value);
  if (compared != 0) {
    return compared < 0 ? a : b;
  }

  return a.id.value.compareTo(b.id.value) <= 0 ? a : b;
}

_SessionGroupKey _sessionGroupKeyFor(WorkoutSet set) {
  final sessionId = set.workoutSessionId;
  if (sessionId != null) {
    return _SessionGroupKey('session', sessionId.value);
  }

  final performedAt = set.performedAt.value.toUtc();
  final day = DateTime.utc(
    performedAt.year,
    performedAt.month,
    performedAt.day,
  );
  return _SessionGroupKey('utcDay', day.toIso8601String());
}

final class _HistoryScan {
  const _HistoryScan({
    required this.sets,
    required this.scannedSetCount,
    required this.reachedHistoryLimit,
  });

  final List<WorkoutSet> sets;
  final int scannedSetCount;
  final bool reachedHistoryLimit;
}

final class _SessionGroupKey {
  const _SessionGroupKey(this.kind, this.value);

  final String kind;
  final String value;

  @override
  bool operator ==(Object other) {
    return other is _SessionGroupKey &&
        other.kind == kind &&
        other.value == value;
  }

  @override
  int get hashCode => Object.hash(kind, value);
}
