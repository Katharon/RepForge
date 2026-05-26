# Analytics Formulas

## Set-level formulas

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
