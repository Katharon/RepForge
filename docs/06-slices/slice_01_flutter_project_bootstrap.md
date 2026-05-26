# Slice 01 — Flutter project bootstrap

## Goal

Bootstrap a clean Flutter app foundation for RepForge without implementing product features.

## Read first

1. `AGENTS.md`
2. `README.md`
3. `CHANGELOG.md`
4. `docs/00-project/project_memory_brief.md`
5. `docs/00-project/business_model_zero_cost.md`
6. `docs/02-architecture/architecture_overview.md`
7. `docs/02-architecture/tech_stack_and_packages.md`
8. `docs/02-architecture/localization_i18n.md`
9. `docs/05-codex/codex_workflow.md`
10. `docs/05-codex/commit_conventions.md`
11. `docs/06-slices/index.md`
12. `docs/06-slices/slice_01_flutter_project_bootstrap.md`

## Current assumptions

- Slice 00 has established the repository governance baseline.
- Product name: `RepForge`.
- Dart/Flutter package name: `repforge`.
- App identifiers are provisional until trademark and store availability are verified.
- Android and iOS are the first target platforms.
- English and German localization are prepared from the start, with English as fallback.
- The MVP remains local-first and near-zero-cost.

## Non-goals

- Do not implement workout tracking, groups, exercises, analytics, rest timers, onboarding, settings, payments, premium gates, notifications, Firebase, sync, ads, wearables, or coach logic.
- Do not implement Clean Architecture folders beyond the minimal Flutter bootstrap.
- Do not add BLoC/Cubit, `go_router`, Drift/SQLite, catalog import, backend APIs, remote analytics, cloud databases, or paid runtime services.
- Do not rename or rewrite the documentation tree.

## TDD requirements

This bootstrap slice uses widget smoke tests. Tests should prove the app starts and that both English and German localization paths can render the placeholder shell.

## Implementation requirements

- Bootstrap Flutter at the repository root without overwriting governance/docs files.
- Use project name `repforge` and display name `RepForge`.
- Generate Android and iOS platforms only.
- Use a provisional bundle/application identifier and document that it is not a store/trademark claim.
- Replace counter-demo UI with a minimal localized RepForge placeholder.
- Add `flutter_localizations`, `intl`, `l10n.yaml`, English ARB, and German ARB.
- Use system locale by default and English fallback through Flutter localization.
- Keep `pubspec.yaml` minimal and aligned with the documented package policy.
- Keep generated boilerplate reasonable and defer architecture folders to later slices.

## Acceptance criteria

- Flutter app compiles for the current bootstrap scope.
- Android/iOS project files exist.
- `pubspec.yaml` is minimal and uses package name `repforge`.
- App display name is `RepForge`.
- English and German ARB files exist.
- Generated localization classes are available.
- Widget smoke tests pass.
- No cloud/backend/Firebase/ads/paid-service dependencies are introduced.
- `CHANGELOG.md`, `docs/05-codex/slice_status.md`, and `docs/06-slices/index.md` are updated.

## Validation commands

```bash
git status --short
flutter --version
flutter doctor -v
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
find . -maxdepth 3 -type f | sort
rg "RepForge" README.md AGENTS.md CHANGELOG.md pubspec.yaml lib test docs/00-project docs/02-architecture docs/05-codex docs/06-slices
rg "Firebase|Supabase|Appwrite|Firestore|RevenueCat|google_mobile_ads|AdMob|remote analytics|cloud database" pubspec.yaml lib test docs || true
```

Optional platform-tooling gaps for non-target platforms are not Slice 01 failures. Android/iOS bootstrap plus `flutter analyze` and `flutter test` are the important gates.

## Documentation updates

Update these if changed by implementation:

- `CHANGELOG.md`
- `docs/05-codex/slice_status.md`
- `docs/06-slices/index.md`
- Any minimal architecture/project-layout doc made stale by this slice

## Implementation note

Slice 01 bootstrapped the Flutter project at the repository root with Android and iOS only. The package is `repforge`, the display name is `RepForge`, and the generated provisional native identifiers use `com.repforge.repforge`. English and German ARB files plus generated Flutter localization classes are in `lib/l10n/`. The app shell is a localized placeholder only; no workout features, persistence, routing, BLoC, notifications, payments, Firebase, ads, analytics SDKs, or backend services were introduced.

## Commit message

```text
chore: bootstrap Flutter app
```
