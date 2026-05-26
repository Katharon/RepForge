# Slice 02 — Analysis options, formatting, test gates

## Goal

Harden RepForge's analysis, linting, formatting, and test gates after the Flutter bootstrap from Slice 01.

## Read first

1. `AGENTS.md`
2. `docs/00-project/project_memory_brief.md`
3. `docs/02-architecture/architecture_overview.md`
4. `docs/02-architecture/tech_stack_and_packages.md`
5. `docs/04-quality/test_strategy.md`
6. `docs/05-codex/codex_workflow.md`
7. `docs/05-codex/commit_conventions.md`
8. `docs/06-slices/index.md`
9. `docs/06-slices/slice_02_analysis_options_formatting_test_gates.md`
10. `CHANGELOG.md`
11. `pubspec.yaml`
12. `analysis_options.yaml`

## Current assumptions

- Slice 01 has bootstrapped the minimal Flutter app.
- RepForge is the app name and `repforge` is the Dart package name.
- English and German localization foundation exists.
- This slice is about quality gates only.
- The MVP remains local-first and near-zero-cost.

## Non-goals

- Do not implement product features, Clean Architecture layers, BLoC/Cubit, routing, Drift/SQLite, catalog import, analytics, rest timers, settings, payments, notifications, Firebase, sync, ads, wearables, or coach logic.
- Do not add Firebase, Supabase, Appwrite, Firestore, RevenueCat, remote analytics, remote config, AdMob/google_mobile_ads, backend APIs, or paid services.
- Do not add unnecessary dependencies.
- Do not rewrite unrelated UI or documentation.

## Implementation requirements

- Keep `flutter_lints` as the baseline lint package.
- Enable practical stricter analyzer settings without adding noisy rules that slow early development.
- Keep generated localization code excluded from manual lint expectations.
- Prefer `dart format` for formatting checks.
- Keep widget smoke tests deterministic and localization-safe.
- Add a lightweight local validation script.
- Add or align a minimal GitHub Actions workflow for quality gates only.

## Validation commands

```bash
git status --short
flutter --version
flutter pub get
flutter gen-l10n
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
scripts/check.sh
find . -maxdepth 3 -type f | sort
rg "RepForge" README.md AGENTS.md CHANGELOG.md pubspec.yaml analysis_options.yaml lib test docs/00-project docs/02-architecture docs/04-quality docs/05-codex docs/06-slices
rg "Firebase|Supabase|Appwrite|Firestore|RevenueCat|google_mobile_ads|AdMob|remote analytics|cloud database" pubspec.yaml lib test .github docs || true
```

## Documentation updates

Update these if changed by implementation:

- `CHANGELOG.md`
- `README.md` if local validation commands change
- `docs/04-quality/test_strategy.md` if validation workflow changes
- `docs/05-codex/slice_status.md`
- `docs/06-slices/index.md`

## Implementation note

Slice 02 tightened `analysis_options.yaml` with practical strict analyzer language settings and focused lint rules, added `scripts/check.sh` as the local validation gate, added a minimal `.github/workflows/quality.yml` workflow for formatting/analyze/test, and documented the updated quality workflow. No product features, architecture layers, cloud services, ads, analytics SDKs, or paid services were introduced.

## Commit message

```text
chore: harden Flutter analysis and test gates
```
