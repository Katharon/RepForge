import 'package:repforge/src/features/recovery/domain/recovery_domain.dart';
import 'package:repforge/src/features/training_log/domain/training_log_domain.dart';

import '../value_objects/adaptive_set_models.dart';
import '../value_objects/recommendation_models.dart';

abstract interface class AdaptiveSetSuggester {
  AdaptiveSetSuggestion suggest(AdaptiveSetSuggestionRequest request);
}

final class DeterministicAdaptiveSetSuggester implements AdaptiveSetSuggester {
  const DeterministicAdaptiveSetSuggester();

  @override
  AdaptiveSetSuggestion suggest(AdaptiveSetSuggestionRequest request) {
    final reasons = <AdaptiveSetReasonCode>{
      AdaptiveSetReasonCode.advisory,
      AdaptiveSetReasonCode.userOverrideAllowed,
      AdaptiveSetReasonCode.stableTieBreak,
      AdaptiveSetReasonCode.rpeNotRequired,
    };
    final alternatives = _alternativesFor(request.recommendationAlternatives);
    final readiness = _readinessState(request.readiness);
    reasons.addAll(readiness.reasons);

    if (readiness.veryLow) {
      if (alternatives.isNotEmpty) {
        reasons.add(AdaptiveSetReasonCode.alternativeAvailable);
        return _suggestion(
          request,
          direction: AdaptiveSetDirection.chooseAlternative,
          inputQuality: _inputQualityFor(request),
          suggestedLoad: request.currentSet.load,
          suggestedRepetitions: request.currentSet.repetitions,
          alternatives: alternatives,
          reasons: reasons,
        );
      }
      reasons.add(AdaptiveSetReasonCode.conservativeStop);
      return _suggestion(
        request,
        direction: AdaptiveSetDirection.stop,
        inputQuality: _inputQualityFor(request),
        reasons: reasons,
      );
    }

    if (readiness.low) {
      return _backoffSuggestion(request, reasons);
    }

    final baseline = request.baseline;
    if (baseline == null) {
      reasons.add(AdaptiveSetReasonCode.noBaseline);
      return _suggestion(
        request,
        direction: AdaptiveSetDirection.maintain,
        inputQuality: AdaptiveSetInputQuality.partial,
        suggestedLoad: request.currentSet.load,
        suggestedRepetitions: request.currentSet.repetitions,
        alternatives: alternatives,
        reasons: reasons,
      );
    }

    final comparison = _compareToBaseline(
      request.currentSet,
      baseline,
      request.backoffPolicy,
    );
    reasons.add(comparison.reason);
    if (comparison.strengthDown) {
      reasons.add(AdaptiveSetReasonCode.strengthDown);
      return _backoffSuggestion(request, reasons);
    }
    if (comparison.belowBaseline) {
      return _suggestion(
        request,
        direction: AdaptiveSetDirection.maintain,
        inputQuality: _inputQualityFor(request),
        suggestedLoad: request.currentSet.load,
        suggestedRepetitions: request.currentSet.repetitions,
        alternatives: alternatives,
        reasons: reasons,
      );
    }
    if (!comparison.exceededBaseline) {
      return _suggestion(
        request,
        direction: AdaptiveSetDirection.maintain,
        inputQuality: _inputQualityFor(request),
        suggestedLoad: request.currentSet.load,
        suggestedRepetitions: request.currentSet.repetitions,
        alternatives: alternatives,
        reasons: reasons,
      );
    }

    final loadIncrease = _nextLoad(request);
    if (loadIncrease.available) {
      reasons.add(AdaptiveSetReasonCode.loadIncrementApplied);
      return _suggestion(
        request,
        direction: AdaptiveSetDirection.addWeight,
        inputQuality: _inputQualityFor(request),
        suggestedLoad: LoadKg(loadIncrease.loadKg!),
        suggestedRepetitions: baseline.repetitions,
        alternatives: alternatives,
        reasons: reasons,
      );
    }

    reasons.addAll(loadIncrease.reasons);
    if (request.currentSet.repetitions.value <
        request.progressiveOverloadPolicy.targetRepMaximum) {
      reasons.add(AdaptiveSetReasonCode.repProgressionAvailable);
      return _suggestion(
        request,
        direction: AdaptiveSetDirection.addReps,
        inputQuality: _inputQualityFor(request),
        suggestedLoad: request.currentSet.load,
        suggestedRepetitions: Repetitions(
          request.currentSet.repetitions.value + 1,
        ),
        alternatives: alternatives,
        reasons: reasons,
      );
    }

    return _suggestion(
      request,
      direction: AdaptiveSetDirection.maintain,
      inputQuality: _inputQualityFor(request),
      suggestedLoad: request.currentSet.load,
      suggestedRepetitions: request.currentSet.repetitions,
      alternatives: alternatives,
      reasons: reasons,
    );
  }
}

AdaptiveSetSuggestion _backoffSuggestion(
  AdaptiveSetSuggestionRequest request,
  Set<AdaptiveSetReasonCode> reasons,
) {
  final load = _backoffLoad(request);
  final repetitions = _backoffRepetitions(request);
  return _suggestion(
    request,
    direction: AdaptiveSetDirection.backoff,
    inputQuality: _inputQualityFor(request),
    suggestedLoad: LoadKg(load),
    suggestedRepetitions: Repetitions(repetitions),
    alternatives: _alternativesFor(request.recommendationAlternatives),
    reasons: reasons,
  );
}

double _backoffLoad(AdaptiveSetSuggestionRequest request) {
  final raw =
      request.currentSet.load.value *
      request.backoffPolicy.backoffLoadMultiplier;
  final increment = _incrementFor(request);
  return _floorToIncrement(raw, increment);
}

int _backoffRepetitions(AdaptiveSetSuggestionRequest request) {
  final value =
      request.currentSet.repetitions.value -
      request.backoffPolicy.backoffRepetitionDrop;
  return value < 1 ? 1 : value;
}

AdaptiveSetSuggestion _suggestion(
  AdaptiveSetSuggestionRequest request, {
  required AdaptiveSetDirection direction,
  required AdaptiveSetInputQuality inputQuality,
  required Iterable<AdaptiveSetReasonCode> reasons,
  Iterable<AdaptiveSetAlternative> alternatives =
      const <AdaptiveSetAlternative>[],
  LoadKg? suggestedLoad,
  Repetitions? suggestedRepetitions,
}) {
  return AdaptiveSetSuggestion(
    direction: direction,
    inputQuality: inputQuality,
    exerciseRef: request.currentSet.exerciseRef,
    currentLoad: request.currentSet.load,
    currentRepetitions: request.currentSet.repetitions,
    suggestedLoad: suggestedLoad,
    suggestedRepetitions: suggestedRepetitions,
    alternatives: alternatives,
    reasons: _sortedReasons(reasons),
  );
}

_ReadinessState _readinessState(ReadinessReadModel? readiness) {
  final reasons = <AdaptiveSetReasonCode>{};
  final level = readiness?.level;
  if (level == ReadinessLevel.high) {
    reasons.add(AdaptiveSetReasonCode.goodReadiness);
  }
  if (level == ReadinessLevel.low) {
    reasons.add(AdaptiveSetReasonCode.lowReadiness);
  }
  if (level == ReadinessLevel.veryLow) {
    reasons.add(AdaptiveSetReasonCode.veryLowReadiness);
  }

  final soreness = readiness?.latestCheckIn?.soreness.value;
  final highSoreness =
      (soreness != null && soreness >= 3) ||
      (readiness?.reasons.contains(ReadinessReason.highSoreness) ?? false);
  final veryHighSoreness = soreness != null && soreness >= 4;
  if (highSoreness) {
    reasons.add(AdaptiveSetReasonCode.highSoreness);
  }

  return _ReadinessState(
    low: level == ReadinessLevel.low || highSoreness,
    veryLow: level == ReadinessLevel.veryLow || veryHighSoreness,
    reasons: reasons,
  );
}

_BaselineComparison _compareToBaseline(
  CurrentSetPerformance current,
  SetPerformanceBaseline baseline,
  BackoffPolicy policy,
) {
  if (current.load.value > baseline.load.value ||
      current.repetitions.value > baseline.repetitions.value) {
    return const _BaselineComparison(
      reason: AdaptiveSetReasonCode.baselineExceeded,
      exceededBaseline: true,
    );
  }

  if (current.load.value == baseline.load.value &&
      current.repetitions.value == baseline.repetitions.value) {
    return const _BaselineComparison(
      reason: AdaptiveSetReasonCode.baselineMatched,
    );
  }

  final repetitionDrop = baseline.repetitions.value - current.repetitions.value;
  final loadDrop = baseline.load.value - current.load.value;
  final strengthDown =
      repetitionDrop >= policy.strengthDownRepetitionThreshold || loadDrop > 0;

  return _BaselineComparison(
    reason: AdaptiveSetReasonCode.baselineBelow,
    belowBaseline: true,
    strengthDown: strengthDown,
  );
}

_NextLoad _nextLoad(AdaptiveSetSuggestionRequest request) {
  final increment = _incrementFor(request);
  final next = _ceilToNextIncrement(request.currentSet.load.value, increment);
  final maxLoad = request.primaryLoadConstraint?.maxLoadKg?.value;
  if (maxLoad != null && request.currentSet.load.value >= maxLoad) {
    return const _NextLoad(
      reasons: <AdaptiveSetReasonCode>[
        AdaptiveSetReasonCode.equipmentMaxLoadReached,
        AdaptiveSetReasonCode.loadIncreaseUnavailable,
      ],
    );
  }
  if (maxLoad != null && next > maxLoad) {
    return const _NextLoad(
      reasons: <AdaptiveSetReasonCode>[
        AdaptiveSetReasonCode.equipmentMaxLoadReached,
        AdaptiveSetReasonCode.loadIncreaseUnavailable,
      ],
    );
  }
  return _NextLoad(loadKg: next);
}

double _incrementFor(AdaptiveSetSuggestionRequest request) {
  return request.primaryLoadConstraint?.incrementKg?.value ??
      request.progressiveOverloadPolicy.defaultLoadIncrementKg;
}

double _ceilToNextIncrement(double value, double increment) {
  final nextStep = (value / increment).floor() + 1;
  return _roundKg(nextStep * increment);
}

double _floorToIncrement(double value, double increment) {
  final steps = (value / increment).floor();
  final snapped = steps <= 0 ? value : steps * increment;
  return _roundKg(snapped);
}

double _roundKg(double value) {
  return (value * 1000).roundToDouble() / 1000;
}

AdaptiveSetInputQuality _inputQualityFor(AdaptiveSetSuggestionRequest request) {
  if (request.baseline == null) {
    return AdaptiveSetInputQuality.partial;
  }
  return AdaptiveSetInputQuality.ready;
}

List<AdaptiveSetAlternative> _alternativesFor(
  Iterable<RecommendationAlternative> alternatives,
) {
  return alternatives
      .map(
        (alternative) => AdaptiveSetAlternative(
          exerciseRef: alternative.exercise.exerciseRef,
          reasons: const <AdaptiveSetReasonCode>[
            AdaptiveSetReasonCode.alternativeAvailable,
          ],
        ),
      )
      .take(2)
      .toList(growable: false);
}

List<AdaptiveSetReasonCode> _sortedReasons(
  Iterable<AdaptiveSetReasonCode> reasons,
) {
  return reasons.toList(growable: false)
    ..sort((left, right) => left.index.compareTo(right.index));
}

final class _ReadinessState {
  const _ReadinessState({
    required this.low,
    required this.veryLow,
    required this.reasons,
  });

  final bool low;
  final bool veryLow;
  final Set<AdaptiveSetReasonCode> reasons;
}

final class _BaselineComparison {
  const _BaselineComparison({
    required this.reason,
    this.exceededBaseline = false,
    this.belowBaseline = false,
    this.strengthDown = false,
  });

  final AdaptiveSetReasonCode reason;
  final bool exceededBaseline;
  final bool belowBaseline;
  final bool strengthDown;
}

final class _NextLoad {
  const _NextLoad({
    this.loadKg,
    this.reasons = const <AdaptiveSetReasonCode>[],
  });

  final double? loadKg;
  final List<AdaptiveSetReasonCode> reasons;

  bool get available => loadKg != null;
}
