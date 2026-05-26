# Architecture Overview

## Style

Use feature-first Clean Architecture adapted to Flutter.

```text
lib/
  main.dart
  src/
    app/
      app_bootstrap.dart
      composition_root.dart
      localization/
      navigation/
      repforge_app.dart
    core/
    features/
      training_log/
        domain/
        application/
        data/
        presentation/
      exercise_catalog/
        domain/
        application/
        data/
        presentation/
      analytics/
        domain/
        application/
        presentation/
      training_intelligence/
        domain/
        application/
        presentation/
      rest_timer/
        domain/
        application/
        data/
        presentation/
      settings/
        domain/
        application/
        data/
        presentation/
      entitlements/        # post-MVP
      sync/                # post-MVP optional
      wearables/           # future
      social/              # future
    shared/
      domain/
      application/
      data/
      presentation/
```

Feature folders are created when their slice introduces a real boundary. Empty
future feature directories are avoided unless a concise README is useful.

## Dependency rule

Dependencies point inward:

```text
presentation -> application -> domain
        data -> application/domain
composition wires everything
```

Domain must be pure Dart. Data owns Drift, bundled catalog asset parsing, local notifications, platform APIs, future payment APIs, future Firebase APIs, and future health/wearable APIs.

## Why not a tiny architecture?

The app is domain-heavy:

- workout groups and exercise assignment,
- local persistence and migrations,
- official catalog import/versioning,
- analytics formulas,
- muscle activation and imbalance calculations,
- readiness and progressive overload rules,
- recommendations,
- rest timers,
- local notifications,
- future payments, optional sync, wearables, and social features.

A domain/application layer prevents rules from being scattered across widgets and database classes.

## Feature responsibilities

### training_log

Workout groups, sessions, sets, labels, comments, and logging UI.

### exercise_catalog

Official bundled catalog, custom exercises, search/filter, user overrides, and catalog import.

### analytics

Metrics, charts, period comparisons, estimated 1RM, muscle load, and dashboards.

### training_intelligence

User goals, focus profiles, readiness, recommendations, quick sessions, imbalance prevention, and deload hints.

### rest_timer

Rest timer state and local notification scheduling.

### settings

Units, theme, defaults, profile settings, equipment, export/import entry points.

## Composition root

Use constructor injection. A small composition root creates:

- database,
- repositories,
- use cases,
- Cubits/Blocs,
- platform adapters.

`get_it` is acceptable for registration, but do not hide dependencies inside domain/application code.

## Catalog import boundary

Bundled catalog JSON files are data-layer input. The importer parses assets, validates schema/version, and writes imported official definitions to the local database. Domain sees official exercises through repository ports and value objects, not through JSON or Flutter assets directly.

## Future integration boundaries

- Payments: entitlement ports in application; app-store implementation in data.
- Firebase/remote push: optional data adapter; not needed for local rest timers.
- Sync: optional repository decorator/adapter; never required for local logging.
- Wearables: optional platform adapter; domain receives normalized heart-rate/activity samples.
- Social: separate bounded context; never mix friends data with local canonical training log.

## v5 architecture additions

### Localization

Add localization as a foundation concern in the app shell. Use Flutter's official ARB/gen-l10n workflow. English is fallback; German is initially supported. Domain logic must not depend on localized strings.

### Equipment-aware future coach

Equipment inventory and load constraints belong in Domain/Application, not Presentation. UI screens only collect and display equipment settings. Recommendation logic later consumes equipment constraints through application use cases.

### Freemium boundary

The free local tracker must not depend on payment infrastructure. Premium gates should be adapter-driven and applied at use-case entry points for future coach features, not scattered throughout widgets.
