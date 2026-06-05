# CI/CD

## GitHub Actions baseline

Slice 39 provides `.github/workflows/quality.yml` with the workflow name
`RepForge CI`.

Triggers:

- pull requests,
- pushes to `main`,
- pushes to `develop`,
- manual `workflow_dispatch`.

Permissions are read-only for repository contents. The workflow does not require
secrets.

## Quality job

Job name: `Analyze, generate, and test`

Commands:

```bash
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
git diff --exit-code -- lib test
dart run tool/validate_catalog.dart
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter test test/src/integration
scripts/check.sh
```

The generated-code check fails CI if generated Dart files under `lib` or `test`
are stale after localization/build-runner generation. Golden tests run as part
of `flutter test`; CI must not update golden baselines.

Slice 52 adds an offline bundled catalog validation step. The validator checks
manifest consistency, current catalog asset references, stable official IDs,
localized names, aliases when present, known equipment/movement/muscle values,
duplicate per-exercise tag lists, and future-ready activation-weight ranges
without network access or remote catalog fetching.

`scripts/check.sh` intentionally repeats the core local quality gate so the
script remains trustworthy for developers and CI.

## Android debug artifact job

Job name: `Android debug artifact`

The job depends on the quality job and runs:

```bash
flutter pub get
flutter build apk --debug
```

It uploads:

- artifact name: `repforge-debug-apk`
- path: `build/app/outputs/flutter-apk/app-debug.apk`

This artifact is for CI smoke testing and internal inspection only. It is not a
signed store release.

## Release workflow

Tag-based release workflow after production hardening:

- Trigger on `v*.*.*` tags.
- Build Android App Bundle.
- Build iOS artifact in macOS runner if Apple signing is configured.
- Generate GitHub release notes.

## Secrets

Never commit signing keys, API secrets, Firebase configs, keystores,
provisioning profiles, or store credentials. Use GitHub Actions secrets only in
a later explicit signing/publishing slice.

Slice 39 does not publish to Google Play, App Store, TestFlight, Firebase,
backend services, or any paid runtime service.
