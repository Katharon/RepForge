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

Slice 18 exercise-detail analytics defines the first concrete comparable-session
rule for one exercise:

- the current comparable group is the newest group inside the requested current
  period.
- groups use `workoutSessionId` when present.
- sets without a session id fall back to the UTC `performedAt` day.
- the previous comparable group is the immediately older different group within
  the bounded scanned history.
- if no current group, previous group, or non-zero baseline exists, delta state
  is explicit and unavailable where needed rather than throwing.

## Time-window delta

Use this when the user asks: `How is my trend over time?`

Examples:

- This week vs previous week.
- Last 14 days vs prior 14 days.
- Current month vs previous month.
- Last 3 months trend.

Prefer previous comparable session for immediate workout feedback and time-window deltas for long-term analytics.

Slice 18 exercise-detail analytics uses `[start, end)` as the current period and
compares it with the previous equal-length period `[start - duration, start)`.
The UI-facing use case reads WorkoutSet timeline pages with an explicit
`maxHistorySets` bound; it does not call unbounded exercise history APIs.

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
- `FormulaIdentity` and `EstimatedOneRepMax` reject invalid values with
  deterministic analytics validation exceptions instead of assert-only checks.

## Muscle load estimate

Muscle load is derived, not measured.

```text
muscleSetLoad = setVolume * activationWeight
muscleWeeklyLoad = sum(muscleSetLoad for muscle in rolling week)
```

For bodyweight or machine exercises where load is incomplete, later versions may use normalized stimulus points.

Slice 45 implements the initial pure-Dart formula:

```text
estimatedMuscleLoadKg = loggedLoadKg * repetitions * activationWeight
```

Inputs:

- `WorkoutSet.load` and `WorkoutSet.repetitions` remain the source of truth.
- `ActivationWeight` must be finite and between `0.0` and `1.0`.
- missing exercise activation data returns unavailable confidence plus the
  unknown exercise refs.
- incomplete/bodyweight-style load inputs are allowed but lower confidence to a
  conservative estimate.

Zero logged load produces `0` estimated muscle load. Zero repetitions remain
invalid before analytics because the training-log domain rejects them.

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

Slice 46 implements a conservative first pass:

```text
lowerShare = lowerBodyLoad / totalKnownMuscleLoad
upperShare = upperBodyLoad / totalKnownMuscleLoad
pushPullRatio = pushLoad / pullLoad
```

The detector uses focus-aware target ranges:

- balanced/default: lower-body minimum `0.25`, upper-body minimum `0.45`,
  push/pull maximum `1.6`.
- upper-body focus: lower-body minimum `0.10`, upper-body minimum `0.65`,
  push/pull maximum `1.8`.
- lower-body/glute focus: lower-body minimum `0.40`, upper-body minimum `0.25`,
  push/pull maximum `1.6`.
- arms/chest focus: lower-body minimum `0.12`, upper-body minimum `0.55`,
  push/pull maximum `1.7`.

Missing or explicitly unavailable activation data lowers balance confidence and
adds incomplete-data evidence instead of being counted as zero workload.
