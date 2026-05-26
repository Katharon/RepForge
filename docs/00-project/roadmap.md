# Roadmap

## Phase 0 — Repository and architecture foundation

- Repository governance.
- Flutter project bootstrap.
- Static analysis and test gates.
- Feature-first Clean Architecture skeleton.
- Design tokens and navigation shell.

## Phase 1 — Local tracking MVP

- Domain foundation for exercises, workout groups, sets, sessions, and analytics.
- Drift/SQLite local persistence.
- Official bundled exercise catalog import.
- Custom exercises.
- Workout groups and exercise assignment.
- Exercise detail timeline.
- Add/edit set form.
- Rest timer and local notifications.

## Phase 2 — Analytics cockpit

- Exercise analytics use cases.
- Charts and range selector.
- Estimated 1RM.
- Today dashboard.
- Analytics matrix.
- Previous-session and time-window deltas.
- Search/filter/sort/archive flows.

## Phase 3 — Training intelligence MVP

- User profile, goals, focus, equipment, training frequency, and time constraints.
- Muscle activation model.
- Muscle load dashboard.
- Recovery/readiness surveys.
- Recommendation engine MVP.
- Quick session mode.
- Imbalance detection and corrective recommendations.
- Deload and fatigue signals.

## Phase 4 — Hardening

- Import/export/local backup.
- Migration and data-integrity hardening.
- Accessibility and responsive layout pass.
- Golden tests and visual regression baseline.
- Integration/E2E logging flow.
- Privacy/security hardening.
- Performance optimization for large histories.

## Phase 5 — Monetization and optional integrations

- Entitlement domain and premium gates.
- App-store purchase integration.
- Purchase verification strategy.
- Authentication abstraction only when needed.
- Optional Firebase/remote push boundary.
- Optional sync design spike.
- Optional wearable/health platform integration.
- Optional social/friend activity feed.

## Release rhythm

Tag meaningful stability points, not every slice:

- `v0.1.0` after architecture foundation.
- `v0.2.0` after local logging MVP.
- `v0.3.0` after analytics cockpit.
- `v0.4.0` after training intelligence MVP.
- `v0.9.0` beta candidate.
- `v1.0.0` production release.

## v5 roadmap adjustment

### MVP release target

The first meaningful MVP release should include:

- localized app shell with English fallback and German support,
- onboarding for profile, units, training frequency, and equipment inventory,
- small official exercise catalog,
- custom exercises,
- workout groups,
- set logging,
- exercise/group analytics,
- local backup/export/import.

### Post-MVP Premium target

Premium work should start only after the free tracker is genuinely useful:

- coach recommendations,
- equipment-aware suggestions,
- muscle balance dashboard,
- recovery/readiness check-ins,
- quick sessions,
- adaptive set suggestions,
- wearable integration.
