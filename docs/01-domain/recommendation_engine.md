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
