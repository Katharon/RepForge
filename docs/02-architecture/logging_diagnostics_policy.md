# Logging and Diagnostics Policy

## Goal

RepForge must be debuggable without leaking sensitive training, profile, payment, or health data.

## Default stance

The MVP should not use remote logging, remote analytics, or crash reporting. Local development logs are allowed. Production logs must be minimal and privacy-safe.

## Data that must not be logged

Do not log:

- user age, sex, weight, body measurements, injuries, soreness notes, readiness check-ins
- workout set entries, exact weights, repetitions, personal notes, timestamps linked to user behavior
- health/wearable payloads, heart rate, calories, sleep, recovery details
- purchase tokens, receipt data, account identifiers, device identifiers
- full database paths or backup file contents
- imported/exported user data payloads

## Allowed log categories

Allowed in development:

- feature lifecycle markers without personal payloads
- migration step names and schema versions
- catalog version numbers and counts
- validation failure categories without raw sensitive payloads
- performance timings without user-identifying context

Allowed in production:

- minimal local-only technical logs if needed for user-triggered troubleshooting
- sanitized error categories
- app/catalog/database version metadata

## Remote diagnostics later

If crash reporting or analytics are introduced later:

- Create a dedicated slice.
- Update privacy policy before release.
- Keep it opt-in unless a legal review confirms another basis.
- Provide a setting to disable diagnostics.
- Sanitize all events centrally.
- Do not use ad identifiers.
- Do not include training payloads.
- Document processors/sub-processors.

## Architecture rule

Logging must go through an application-level abstraction:

```text
Domain -> no logging dependency
Application -> DiagnosticsPort for abstract technical events
Data/Platform -> concrete logger adapter
Presentation -> user-facing errors through localized messages, not raw exception dumps
```

## Testing requirements

- Add tests for redaction utilities.
- Add tests that sensitive DTOs are never serialized into diagnostic events.
- Add lint/review checklist item for new logging calls.
