# CI/CD

## GitHub Actions baseline

Run on pull requests and pushes to main/develop:

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test --coverage
```

After app bootstrap:

```bash
flutter build apk --debug
```

After release setup:

```bash
flutter build appbundle --release
```

## Workflow stages

1. Checkout.
2. Set up Flutter stable.
3. Cache pub packages if useful.
4. `flutter pub get`.
5. Format check.
6. Analyze.
7. Tests.
8. Debug build.
9. Upload coverage/build artifacts where appropriate.

## Release workflow

Tag-based release workflow after production hardening:

- Trigger on `v*.*.*` tags.
- Build Android App Bundle.
- Build iOS artifact in macOS runner if Apple signing is configured.
- Generate GitHub release notes.

## Secrets

Never commit signing keys, API secrets, or store credentials. Use GitHub Actions secrets.
