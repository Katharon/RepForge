# AGENTS.md

This repository is the Flutter rebuild of a Setgraph-style workout tracker. The selected app name is `RepForge`.

## Source of truth

Treat Markdown files in `docs/` as the project specification. The most important files are:

1. `docs/00-project/project_memory_brief.md`
2. `docs/00-project/product_requirements.md`
3. `docs/01-domain/domain_map.md`
4. `docs/01-domain/training_science_model.md`
5. `docs/02-architecture/architecture_overview.md`
6. `docs/02-architecture/exercise_catalog_distribution.md`
7. `docs/05-codex/codex_workflow.md`
8. `docs/06-slices/index.md`
9. `docs/02-architecture/data_versioning_backward_compatibility.md` for persistence, catalog, analytics, or export/import changes.

## Non-negotiable rules

1. Work one slice at a time unless explicitly instructed otherwise.
2. Read only the files listed in the slice prompt plus files required by direct imports/errors.
3. Keep domain pure Dart. No Flutter, Drift, Firebase, platform, payment, notification, HTTP, or database imports in `domain`.
4. Use feature-first Clean Architecture.
5. Presentation uses Flutter with BLoC/Cubit.
6. Use constructor injection and a small composition root.
7. Work TDD-first for domain/application/data logic. For UI, add widget/BLoC tests where meaningful.
8. Do not introduce cloud sync, auth, Firebase, payments, analytics SDKs, crash reporting, wearables, or social features before their slice.
9. Do not introduce a cloud database for the official exercise catalog. Official exercise data is shipped through versioned bundled assets and app releases/patches.
10. Local Drift/SQLite is allowed and expected for user data, imported official catalog data, analytics queries, migrations, and offline use.
11. Keep all user training data local-first and exportable.
12. Update affected documentation after each slice.
13. Update slice status after each slice.
14. Validate before committing.
15. Commit each slice with one Conventional Commit.

## Product intent

The app should not merely store sets. It should help users understand training progress and make better next decisions.

The user can:

- Create workout groups such as Push Day, Pull Day, Leg Day, Upper, Lower, Full Body, or custom splits.
- Use bundled official exercises or create custom exercises.
- Assign exercises to groups.
- Log sets with weight and repetitions quickly.
- See analytics for exercise progression, session volume, weekly muscle load, recovery, and potential imbalances.
- Later receive adaptive recommendations based on focus, available time, equipment, recent training, soreness, recovery, and muscle balance.

## Official exercise catalog rule

Official exercises, muscle metadata, equipment tags, movement patterns, and muscle activation estimates are distributed as versioned JSON assets inside the app. Weekly updates are normal app releases or content patches. The app imports new catalog versions into local storage. User-created exercises and user overrides are never overwritten by official catalog imports.

## Training-science boundaries

The app may provide coaching recommendations, but it must not claim medical certainty. Use careful wording such as `recommendation`, `signal`, `estimated`, `likely`, `readiness`, and `trend`. Avoid promising injury prevention or guaranteed results.

## Quality bar

Prefer small, production-quality increments over broad prototypes. Keep code readable, testable, and maintainable. Do not overengineer, but make boundaries strong enough that later payments, optional sync, remote push, wearables, or social features can be added without rewriting the local workout core.

## v5 implementation reminders

- User-facing UI strings must be localized after the localization foundation exists.
- Do not introduce a cloud database for the official exercise catalog.
- Respect freemium boundaries: core tracking, groups, base analytics, custom exercises, and export stay free.
- Model equipment constraints before implementing recommendation logic.
- Use careful non-medical wording for recovery/readiness/DOMS/calorie guidance.


## v6 project rules

- Use the product name `RepForge`.
- Keep the MVP local-first and near-zero-cost to operate.
- Do not add cloud services, Firebase, ads, remote sync, or paid third-party runtime services unless the slice explicitly says so.
- Treat official catalog JSON assets as canonical and Drift as the local imported runtime database.
- Keep German and English localization complete for every user-visible MVP string.
- Keep free vs premium boundaries clear: tracking/groups/base analytics free; coach/guidance/recommendations premium later.
- RepForge still needs trademark and store-availability verification before public launch.
