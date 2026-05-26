# Slice 55 — Legal Compliance and Resilience Baseline

## Purpose

Create an implementation-facing compliance baseline before production release. This slice does not add cloud infrastructure or legal overengineering. It makes the local-first product safer, more transparent, and store-ready.

## Read first

- `AGENTS.md`
- `docs/00-project/project_memory_brief.md`
- `docs/00-project/decisions.md`
- `docs/02-architecture/security_privacy_threat_model.md`
- `docs/02-architecture/resilience_governance.md`
- `docs/02-architecture/logging_diagnostics_policy.md`
- `docs/08-legal-compliance/README.md`
- `docs/08-legal-compliance/gdpr_privacy_model.md`
- `docs/08-legal-compliance/terms_safety_disclaimer.md`
- `docs/04-quality/compliance_release_checklist.md`
- `docs/04-quality/security_update_policy.md`

## Scope

- Add in-app legal/about screen entries for:
  - privacy policy
  - safety disclaimer
  - open-source licenses
  - app version and catalog version
- Add a local data delete/reset flow if not already present.
- Add or verify export path before production release.
- Add redaction utility tests for diagnostic/logging events.
- Ensure recommendation strings use hedged wording.
- Ensure no remote diagnostics/analytics/ad SDK exists in MVP.
- Update store compliance checklist.

## TDD requirements

Write failing tests first for:

- redaction of sensitive diagnostics data
- legal/about screen route visibility
- local delete/reset confirmation behavior
- no direct logging of sensitive DTOs where applicable

## Non-goals

- No cloud sync.
- No remote analytics.
- No Firebase.
- No ads.
- No legal finalization by Codex.
- No medical-device positioning.

## Validation commands

```bash
flutter analyze
flutter test
flutter test integration_test || true
```

Use project-specific commands if the repository defines wrappers.

## Documentation updates

- Update `docs/04-quality/compliance_release_checklist.md`.
- Update `docs/05-codex/slice_status.md`.
- Update `CHANGELOG.md`.

## Commit message

```bash
git add .
git commit -m "chore(compliance): add legal and resilience baseline"
```
