# Tech Stack and Package Policy

## Baseline

RepForge uses Flutter and Dart with a feature-first Clean Architecture.

Recommended baseline stack:

```text
Flutter + Dart
Feature-first Clean Architecture
BLoC/Cubit for presentation state
Drift/SQLite for local persistence
Versioned JSON assets for official exercise catalog content
flutter_localizations + intl for English/German localization
go_router for routing
get_it as composition root / dependency registration
in_app_purchase for future store subscriptions
flutter_local_notifications for rest timers
```

## Package selection criteria

A package may be used when it is:

- actively maintained,
- widely adopted or official / ecosystem-standard,
- compatible with Android and iOS,
- testable without a real device where possible,
- replaceable through an application/domain port,
- not tied to a paid runtime service unless explicitly accepted.

Avoid packages that:

- solve a small problem with a large dependency tree,
- hide critical native behavior behind weak abstractions,
- require paid cloud infrastructure,
- force architecture decisions into the domain layer,
- are unmaintained or have poor platform support.

## Recommended packages

| Area | Package | Decision | Notes |
|---|---|---|---|
| Routing | `go_router` | Use | Declarative routing, shell routes, deep-link readiness. |
| State | `flutter_bloc`, `bloc`, `bloc_test` | Use | Fits BLoC/Cubit and TDD-first state tests. |
| DI | `get_it` | Use carefully | Composition root only. Avoid random service-locator calls inside domain/application. |
| Persistence | `drift`, `drift_dev`, `sqlite3_flutter_libs` | Use | Main local relational database. |
| JSON DTOs | `json_serializable`, `build_runner` | Use | Official catalog import DTOs and app metadata. |
| Immutable data | `freezed` | Optional | Useful for Bloc states and DTOs. Domain entities should remain readable and explicit. |
| Settings | `shared_preferences` | Use | Theme, locale override, onboarding-complete flag. Not for training logs. |
| Secure values | `flutter_secure_storage` | Later | Store-sensitive values only if sync/accounts/payments require it. |
| Package info | `package_info_plus` | Use | App version, build number, catalog version display. |
| Charts | `fl_chart` | Likely use | Keep behind local chart widgets/read models. Do not leak package types into domain/application. |
| Local notifications | `flutter_local_notifications` | Use | Rest timer and local reminders. |
| Payments | `in_app_purchase` | Later | Official store purchase integration. Premium starts after MVP. |
| Permissions | `permission_handler` | Later | Only once permissions are actually needed. |
| Health | `health` | Later evaluation | Use only when smartwatch/HealthKit/Health Connect integration starts. |
| Ads | `google_mobile_ads` | Not MVP | Add only if an explicit later monetization decision approves ads. |
| Firebase Core | `firebase_core` | Not MVP | Optional later only. |
| Crash reporting | `firebase_crashlytics` | Not MVP | Optional later. Consider privacy implications and alternatives. |
| Remote push | `firebase_messaging` | Not MVP | Only for future social/remote features, not rest timers. |

## Packages not used in MVP

Do not add these in the MVP:

- Firebase Firestore / Realtime Database,
- Supabase,
- Appwrite,
- RevenueCat,
- server-driven remote config,
- Google Mobile Ads,
- Firebase Messaging,
- Firebase Crashlytics,
- generic cloud analytics SDKs.

Rationale: the MVP should have near-zero running cost and no mandatory remote service.

## Method Channels / Pigeon policy

Use existing packages for common, stable platform features. Use Method Channels or Pigeon only when RepForge needs native capabilities not covered well enough by maintained packages.

Do **not** use Method Channels for:

- Drift/SQLite persistence,
- BLoC state management,
- routing,
- basic localization,
- basic app settings,
- normal local notifications,
- standard in-app purchases.

Consider Method Channels / Pigeon for later:

- advanced HealthKit / Health Connect features not covered by `health`,
- Apple Watch / Wear OS companion behavior,
- iOS Live Activities / Dynamic Island timer UX,
- Android/iOS widgets,
- native background constraints that cannot be modeled with existing packages,
- platform-specific store entitlement edge cases not exposed by `in_app_purchase`.

Architecture rule:

```text
Presentation -> Application Use Case -> Domain Port -> Infrastructure Adapter -> Platform Channel
```

Never call a platform channel directly from random UI widgets.
