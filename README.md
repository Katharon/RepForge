# RepForge

Modern Flutter rebuild of an old Setgraph-style workout tracking app.

The product is a local-first, privacy-conscious strength-training tracker with a later coaching layer. The MVP path is **offline-capable tracking, workout groups, custom exercises, a small official base exercise catalog, and analytics**. Cloud databases are **not** part of the MVP and must not be introduced for the official exercise catalog.

## Product thesis

Most gym apps either log sets or generate generic plans. This app should do both better:

1. Track everything the user actually does.
2. Organize training around user-defined groups such as `Push Day`, `Pull Day`, `Leg Day`, `Upper`, `Lower`, `Full Body`, or custom splits.
3. Support custom exercises and an official bundled exercise catalog.
4. Interpret progress through understandable metrics: sets, repetitions, volume, kg/rep, estimated 1RM, deltas to previous comparable sessions, time-window trends, muscle load, fatigue, recovery, and imbalance signals.
5. Later, guide the user toward productive training with less guesswork: next exercise suggestions, alternatives, quick sessions, volume adjustments, deload hints, and imbalance signals.

## Key architectural decision

The official exercise catalog is distributed as **versioned app assets**, not as a paid cloud database.

- New official exercises, muscle activation tables, equipment tags, and recommendation metadata are added through app releases / weekly patches.
- The app imports bundled catalog versions into the local database on startup or migration.
- User-created exercises remain local user data.
- Official catalog records are immutable by default; user overrides are stored separately.
- Future dynamic content updates may use signed static JSON from GitHub Releases/CDN/object storage, but not a mutable cloud database.

## Core features

- Workout groups / training days.
- Exercise catalog with official and custom exercises.
- Assign exercises to groups.
- Fast set logging with weight, reps, timestamp, label, and comment.
- Future local feature: rest timer with local notifications.
- Exercise detail timeline and edit flow.
- Analytics matrix: sets, repetitions, volume, kg/rep, estimated 1RM, density, trends, and deltas.
- Muscle activation and weekly load visualization.
- Future Premium: recovery/readiness input, adaptive recommendations, quick session mode, muscle-balance insights, wearable-derived interpretation, and advanced reports.
- Future: body metrics, calories, wearable heart-rate integration, friends/social feed, optional sync.

## Repository principles

The Markdown files in `docs/` are the source of truth. Codex must read only slice-relevant files, validate before committing, and keep docs, tests, implementation, and slice status synchronized after every slice.

Important documents:

- `AGENTS.md`
- `docs/00-project/project_memory_brief.md`
- `docs/00-project/product_requirements.md`
- `docs/01-domain/domain_map.md`
- `docs/01-domain/training_science_model.md`
- `docs/02-architecture/architecture_overview.md`
- `docs/02-architecture/exercise_catalog_distribution.md`
- `docs/05-codex/codex_workflow.md`
- `docs/06-slices/index.md`

## Architecture summary

Feature-first Clean Architecture adapted to Flutter:

- `domain`: pure Dart entities, value objects, policies, formulas, and rules.
- `application`: use cases, ports, orchestration, DTOs/read models.
- `data`: Drift/SQLite, repositories, mappers, bundled catalog importers, platform adapters.
- `presentation`: Flutter widgets, screens, BLoC/Cubit, navigation, design system.
- `composition`: explicit dependency wiring.

## Initial validation commands

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

Add stronger commands as the app grows:

```bash
flutter test integration_test
flutter build apk --debug
flutter build appbundle --release
```

## v5 planning update

Current product decisions:

- MVP: local tracker + workout groups + analytics.
- Localization: system locale first, English fallback, German early.
- Catalog: bundled versioned JSON assets, no paid cloud exercise database.
- Equipment: model available equipment and max load for future coach constraints.
- Monetization: freemium; Premium later for coach/recommendation/recovery/wearables.
- UI: inspired by Setgraph, not copied.


## v6 Baseline Decisions

- Product name: RepForge.
- MVP: tracking, workout groups, custom exercises, official base catalog, and analytics.
- Languages: English and German from MVP start; system locale first, English fallback.
- Free tier: tracking, groups, custom exercises, official base catalog, base analytics, and local export/import.
- Premium tier later: coach, guidance, recommendations, recovery/readiness, muscle balance, quick sessions, wearables, and advanced reports.
- Official catalog: versioned JSON assets imported into local Drift/SQLite.
- Cost model: no paid cloud database, no mandatory backend, no paid runtime services in MVP.
- Monetization: freemium; coach/guidance features are Premium later.
- Ads: excluded from MVP.

## Compliance and privacy posture

RepForge is designed as a local-first workout tracker. The MVP should not include cloud sync, a cloud database, ads, Firebase, remote analytics, remote crash reporting, or recurring developer-controlled service costs. Legal and compliance planning lives in `docs/08-legal-compliance/` and must stay aligned with the actual app behavior.


## Data evolution principle

RepForge is designed for long-lived local training history. Official catalog IDs are stable, catalog entries are deprecated instead of deleted, Drift migrations must preserve user data, and historical set entries keep stable references plus display-name snapshots.
