# Slice 48 — Recommendation engine MVP

## Goal

Implement deterministic, explainable recommendation rules for exercise ordering, alternatives, muscle balance, recovery, equipment, time, and focus profile.

## Read first

1. `AGENTS.md`
2. `docs/01-domain/recommendation_engine.md`
3. `docs/01-domain/training_science_model.md`
4. `docs/01-domain/muscle_balance_model.md`
5. `docs/01-domain/recovery_readiness_model.md`
6. `docs/06-slices/slice_48_recommendation_engine_mvp.md`

## Non-goals

- Do not use cloud AI.
- Do not add social/wearables/payments.
- Do not make recommendations non-explainable.

## TDD requirements

Write domain tests first for filtering, scoring, substitution recalculation, soreness suppression, and focus-aware suggestions.

## Implementation requirements

- Generate ordered recommendations for a selected workout group.
- Generate alternatives.
- Return explanation reasons.
- Recompute next recommendations after user substitution.
- Follow `AGENTS.md`.
- Keep layer boundaries from the architecture docs.
- Handle loading, empty, error, and success states where UI is touched.
- Update affected docs if implementation decisions differ from the plan.

## Acceptance criteria

- Slice goal is implemented.
- Tests required by this slice are added or updated.
- Formatting passes.
- Static analysis passes.
- All relevant tests pass.
- `docs/05-codex/slice_status.md` is updated.
- No unrelated future feature is introduced.

## Implementation note

Slice 48 adds the MVP as a computed pure-Dart `recommendations` feature
boundary. `RecommendationRequest` accepts explicit candidate exercise metadata
plus local profile, equipment inventory, max-load constraints, muscle-balance
assessment, readiness read model, exclusions, and substitutions. The
deterministic engine returns an advisory `RecommendationPlan` with ordered
recommendations, stable reason codes, load adjustments, alternatives, input
quality, and constraints. It does not persist snapshots, add UI, call remote
services, use cloud AI, require accounts, or block workout logging.

## Validation commands

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

Add slice-specific commands if appropriate:

```bash
flutter test integration_test
flutter build apk --debug
```

## Documentation updates

Update these if changed by implementation:

- `docs/05-codex/slice_status.md`
- Any architecture/domain/UX document made stale by this slice
- `CHANGELOG.md` only for user-visible or release-relevant changes

## Commit message

```text
feat(coach): add recommendation engine mvp
```

## Ready-to-use Codex prompt

```text
You are working in the `gesundheit-gym-app` Flutter repository.

Read first, in this order:
1. AGENTS.md
2. docs/01-domain/recommendation_engine.md
3. docs/01-domain/training_science_model.md
4. docs/01-domain/muscle_balance_model.md
5. docs/01-domain/recovery_readiness_model.md
6. docs/06-slices/slice_48_recommendation_engine_mvp.md

Implement Slice 48: Recommendation engine MVP.

Goal:
Implement deterministic, explainable recommendation rules for exercise ordering, alternatives, muscle balance, recovery, equipment, time, and focus profile.

Non-goals:
- Do not use cloud AI.
- Do not add social/wearables/payments.
- Do not make recommendations non-explainable.

Architecture and quality rules:
- Follow AGENTS.md strictly.
- Keep domain pure Dart and presentation thin.
- Use constructor injection and the documented composition-root approach.
- Do not add unrelated packages or features.
- Do not use a cloud database for the official exercise catalog.
- Keep the repository fresh-context safe by updating docs when assumptions change.

TDD requirements:
Write domain tests first for filtering, scoring, substitution recalculation, soreness suppression, and focus-aware suggestions.

Implementation requirements:
- Generate ordered recommendations for a selected workout group.
- Generate alternatives.
- Return explanation reasons.
- Recompute next recommendations after user substitution.

Validation commands:
```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```
Run stronger commands if applicable:
```bash
flutter test integration_test
flutter build apk --debug
```

Documentation:
- Update docs/05-codex/slice_status.md.
- Update any affected docs if implementation reveals a stale or wrong assumption.

Commit:
Create one git commit with this exact message:
`feat(coach): add recommendation engine mvp`

When finished, report summary, tests, validation results, changed files, commit hash, and follow-ups.
```

## v5 adjustment

Recommendation logic must consume equipment constraints and must not suggest infeasible loads without adjustment or alternatives.
