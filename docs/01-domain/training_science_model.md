# Training Science Model

This document defines how training-science ideas are represented in the app. It is a product and domain model, not a medical claim.

## Principles

1. The app tracks actual behavior first.
2. Recommendations are explainable and conservative.
3. Muscle activation, fatigue, calories, and readiness are estimates.
4. Progressive overload should be gradual.
5. Recovery is part of progress.
6. Imbalance prevention should guide, not shame.
7. User goals override generic defaults.

## Focus profiles

Initial profiles:

### Balanced

Goal: broad development across major movement patterns and muscle groups.

Default bias:

- Push and pull kept reasonably aligned.
- Legs trained consistently.
- Core/stability included.
- Small muscle isolation is allowed but not dominant.

### Upper-body focus

Goal: more upper-body emphasis while preserving minimum leg/posterior-chain work.

Use case: user wants aesthetic upper-body progress with limited time.

Guardrail: show under-target warnings if legs, posterior chain, or pulling volume becomes too low.

### Lower-body / glute focus

Goal: stronger lower-body emphasis while preserving upper-body posture and balance.

Guardrail: ensure upper back, posterior shoulder, and core are not ignored.

### Arms/chest focus

Goal: high aesthetic focus on chest/arms.

Guardrail: recommend enough pulling/rear-delt/back work to avoid extreme push dominance.

### Strength basics

Goal: focus on fundamental strength patterns.

Bias: squat/hinge/push/pull/carry/core patterns, lower exercise variety.

### Time-efficient

Goal: best useful stimulus in low time.

Bias: high-value exercises, supersets later, minimal setup changes, short clear plan.

### Beginner foundation

Goal: learn consistency, technique, and safe progression.

Bias: simple exercises, less aggressive overload, more guidance, fewer complex recommendations.

## Muscle load model

Each exercise has an activation profile:

```text
muscleId -> activationWeight
```

Example concept:

```text
bench_press:
  chest: 1.0
  triceps: 0.6
  anterior_delts: 0.4
```

These values are practical estimates for relative analysis. They are not EMG truth.

## Imbalance prevention

The app compares rolling muscle load against focus-aware target ranges.

Dimensions:

- Muscle group coverage.
- Movement pattern coverage.
- Push/pull ratio.
- Squat/hinge ratio.
- Horizontal/vertical push and pull.
- Left/right unilateral later.
- Anterior/posterior shoulder balance.

Output categories:

- `onTrack`
- `slightlyUnderTarget`
- `stronglyUnderTarget`
- `overEmphasized`
- `recoveryLimited`

## Recovery and soreness

The app should ask short questions only when useful:

- After session: `How hard was this session?` 1–10.
- Next day or before training: `How sore are you?` none/light/moderate/high.
- Optional per-region soreness: chest, back, legs, shoulders, arms, core.

Use input to adjust recommendations:

- High soreness: reduce direct volume for that muscle, suggest alternatives, technique work, or rest.
- Moderate soreness: avoid overload jumps, keep volume stable or slightly reduced.
- Low soreness and good trend: allow normal progression.

## Progressive overload policy

Progression can happen via:

- More load.
- More reps.
- More sets.
- Better density.
- Better range of motion/quality later.
- Better consistency.

Rules:

- Do not increase everything at once.
- Prefer small increments.
- If strength is down, do not automatically force heavier load.
- If readiness is okay but top-set strength is down, suggest a backoff set or extra lower-intensity set to preserve volume.
- If readiness is poor, reduce volume/intensity instead.

## Quick Session mode

Inputs:

- Available time.
- Selected group or full-body fallback.
- Equipment.
- Recent muscle load.
- Readiness.

Output:

- 2–5 exercises.
- Clear order.
- Suggested sets/reps/rest.
- Explanation of what is covered and what is skipped.

## Recommendation explanations

Every recommendation should have visible reasons:

- `You trained chest heavily last session, but triceps is still under target.`
- `Legs are under your weekly minimum for your selected focus.`
- `You reported high soreness in hamstrings, so hinge work is reduced today.`
- `You have 25 minutes, so this quick session prioritizes compound movements.`

## Legal/product wording

Never claim:

- guaranteed results,
- injury prevention,
- medical diagnosis,
- exact muscle fatigue,
- exact calorie burn.

Use:

- `estimated`,
- `likely`,
- `based on your logs`,
- `recommendation`,
- `signal`,
- `trend`.
