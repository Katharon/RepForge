# Recommendation Engine

## Goal

Provide practical, explainable training suggestions based on the user's workout group, profile, equipment, available time, recent training, recovery state, and muscle-balance targets.

## Inputs

- `UserProfile`
- selected `WorkoutGroup`
- available time
- available equipment
- recent sets and sessions
- muscle-load analytics
- muscle-balance signals
- soreness/readiness input
- exercise catalog
- custom exercises
- user favorites/hidden exercises

## Outputs

- ordered exercise recommendations
- alternative exercises
- suggested set/rep/load direction
- quick session plan
- imbalance correction suggestions
- recovery/deload suggestions
- explanation reasons

## Initial algorithm shape

1. Determine session intent from selected group and user profile.
2. Filter exercises by availability, equipment, hidden state, and group assignment.
3. Calculate recent muscle load and readiness.
4. Score exercises:
   - target muscle need
   - movement-pattern need
   - user preference/favorite
   - recovery suitability
   - setup/time efficiency
   - progression opportunity
5. Sort recommendations.
6. Generate explanation reasons.
7. If user chooses an alternative, recalculate remaining recommendations.

## Exercise substitution logic

When the user replaces a recommended exercise:

1. Subtract the planned stimulus of the skipped exercise.
2. Add estimated stimulus of the chosen exercise.
3. Recompute remaining under-target muscles and movement patterns.
4. Re-rank next suggestions.

Example:

- Planned: chest press covers chest + triceps + anterior delts.
- User selects butterfly instead.
- Butterfly covers chest more directly but less triceps.
- Engine may later recommend triceps pressdown, dips, or close-grip machine press depending on equipment and recovery.

## Progressive overload decision

When suggesting next set:

- If recent performance is stable/improving and readiness is good: suggest small load or rep increase.
- If strength is down but readiness is acceptable: suggest backoff set or maintain volume with lower load.
- If soreness/fatigue is high: suggest reduced volume/intensity or alternate muscle group.
- If no baseline exists: suggest conservative starter target.

## Non-goals

- No cloud AI.
- No black-box recommendation logic.
- No medical advice.
- No mandatory account.
- No remote exercise database.

Slice 46 supplies muscle-balance signals for future recommendation use. It does
not yet select exercises, generate coaching copy, or change workout plans.

Slice 47 supplies a local readiness read model for future recommendation use.
It exposes empty/available state, score, level, reasons, confidence, and the
latest local check-in. It still does not generate recommendations, select
exercises, prescribe deloads, or block logging.

Slice 48 implements the first computed recommendation MVP. The feature boundary
lives under `lib/src/features/recommendations/` and stays pure Dart:

- `RecommendationRequest` contains explicit candidate exercise metadata,
  settings/profile context, equipment inventory, optional max-load constraints,
  optional muscle-balance assessment, optional readiness read model, excluded
  exercises, and substitutions.
- `RecommendationPlan` is a read model, not persisted canonical data. It
  returns ordered `RecommendedExercise` items, `RecommendationAlternative`
  items, input-quality state, constraints, and deterministic reason codes.
- `DeterministicRecommendationEngine` filters unavailable equipment, adjusts
  infeasible max-load suggestions instead of returning impossible loads, applies
  focus/profile weighting, uses balance signals to prioritize pull/lower-body
  gaps and suppress push-heavy reinforcement, and down-ranks heavy work when
  readiness or soreness signals are low.
- Substitution/exclusion recomputation is intentionally small: skipped
  exercises are excluded, selected substitutions are treated as already covered,
  and the remaining candidates are re-ranked deterministically.
- The plan is advisory only. `allowsWorkoutLogging` remains true even when input
  quality is partial, readiness is low, or an exercise is filtered.

Reason-code semantics are stable and non-localized. Presentation may translate
codes into careful copy later, but domain code must avoid shame, diagnosis,
mandatory-rest language, or sex/gender stereotypes.

## Test strategy

Domain tests must cover:

- equipment filtering,
- focus profile target weighting,
- soreness-based suppression,
- substitution recalculation,
- quick session generation,
- imbalance correction,
- strength-down backoff behavior,
- empty-history behavior.

Slice 48 tests live under `test/src/features/recommendations/` and cover the
implemented MVP: empty plans, stable ordering, equipment filtering, max-load
adjustment, focus-aware scoring, balance/readiness adjustments, alternatives,
substitution/exclusion recomputation, deterministic reason codes, sex/gender
neutrality, and domain-import guardrails.
