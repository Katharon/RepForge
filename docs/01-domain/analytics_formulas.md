# Analytics Formulas

## Set-level formulas

Slice 07 implements the first MVP analytics formula foundation in pure Dart.
These formulas are deterministic derived values. Raw `WorkoutSet` history remains
the source of truth and is not modified by analytics calculations.

```text
setVolume = load * repetitions
```

```text
kgPerRep = totalVolume / totalRepetitions
```

If `totalRepetitions == 0`, kg/rep is unavailable.

## Session-level formulas

```text
sessionVolume = sum(setVolume)
sessionSets = count(sets)
sessionRepetitions = sum(repetitions)
sessionKgPerRep = sessionVolume / sessionRepetitions
```

MVP workout-set summary semantics:

- empty input: set count, repetitions, and volume are `0`; average kg/rep, best
  set load, and best estimated 1RM are unavailable.
- zero-load sets: valid and deterministic; volume, average kg/rep, and estimated
  1RM can be `0` when repetitions exist.
- decimal loads: supported in kilograms.
- best set load: highest logged set load in kg.
- best estimated 1RM: highest estimated 1RM across the input sets.

## Previous comparable session delta

Use this when the user asks: `How did I perform compared with last time?`

Comparable session means:

1. Same exercise for exercise detail analytics.
2. Same workout group for group analytics.
3. Same muscle group for muscle-load analytics.

```text
deltaAbsolute = current - previous
if previous == 0:
  deltaPercent = unavailable or special-case "new baseline"
else:
  deltaPercent = deltaAbsolute / previous
```

MVP period comparisons expose:

- current value,
- optional previous value,
- optional absolute delta,
- optional percent change as a decimal ratio.

Percent change is unavailable when the previous value is absent or `0`.

## Time-window delta

Use this when the user asks: `How is my trend over time?`

Examples:

- This week vs previous week.
- Last 14 days vs prior 14 days.
- Current month vs previous month.
- Last 3 months trend.

Prefer previous comparable session for immediate workout feedback and time-window deltas for long-term analytics.

## Estimated 1RM

Support multiple formulas later, but start with one formula and document confidence.

Epley-style example:

```text
estimated1RM = load * (1 + repetitions / 30)
```

Rules:

- Label as estimate.
- Avoid overemphasis for very high-rep sets.
- Let user choose formula later.

MVP implementation:

- formula identity: `epley_one_rep_max`, version `1`.
- inputs: validated `LoadKg` and `Repetitions` from the training-log domain.
- zero-load sets return an estimate of `0 kg`.
- derived estimates carry their formula identity so future formula changes can be
  additive and explainable.

## Muscle load estimate

Muscle load is derived, not measured.

```text
muscleSetLoad = setVolume * activationWeight
muscleWeeklyLoad = sum(muscleSetLoad for muscle in rolling week)
```

For bodyweight or machine exercises where load is incomplete, later versions may use normalized stimulus points.

## Weighted set estimate

For recommendation and imbalance purposes, a weighted set can be simpler and more stable than raw volume:

```text
weightedSetContribution = setDifficultyFactor * activationWeight
```

Initial MVP may use:

```text
setDifficultyFactor = 1.0
```

Later:

- RPE/RIR.
- Rep range.
- Proximity to failure.
- Load relative to recent performance.

## Readiness estimate

Readiness is a coaching signal, not medical measurement.

Inputs:

- Soreness score per muscle or general soreness.
- Time since last hard stimulus.
- Last session perceived exertion.
- Strength drop compared with recent baseline.
- Sleep/energy later.

Example initial scoring:

```text
readiness = 100
readiness -= sorenessPenalty
readiness -= recentHighLoadPenalty
readiness -= strengthDropPenalty
readiness += recoveryTimeCredit
readiness = clamp(0, 100)
```

## Imbalance signal

Compare rolling-window muscle load against focus-aware target ratios.

```text
actualShare = muscleLoad / totalRelevantLoad
targetShare = focusProfileTarget[muscle]
imbalance = actualShare - targetShare
```

Use thresholds and warnings carefully. The UI should show this as `under target`, `on track`, or `above target`, not as a medical diagnosis.
