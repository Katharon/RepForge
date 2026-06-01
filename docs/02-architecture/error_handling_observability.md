# Error Handling and Observability

## Error model

Use explicit failures in application boundaries. Avoid throwing generic exceptions through BLoCs.

```dart
sealed class AppFailure {
  final String technicalMessage;
}
```

UI maps failures to user-friendly messages.

## Categories

- Validation failure.
- Not found.
- Persistence failure.
- Permission denied.
- Notification scheduling failure.
- Purchase unavailable.
- Sync unavailable.
- Unknown failure.

## Logging

Initial app:

- Debug logging only.
- No remote telemetry.

Production:

- Crash reporting optional, privacy-reviewed.
- No workout data in logs.
- No tokens or purchase receipts in logs.
- Backup validation exceptions must be log-safe: exception strings list invalid
  fields only and must not echo backup payload values, comments, profile names,
  exercise names, stable IDs, or raw JSON.
- Use the backup JSON redactor before logging any backup-related diagnostic
  snippet; it redacts training history, workout groups, assignments,
  settings/profile, and onboarding data.

## User feedback

- Use inline validation for forms.
- Use SnackBars for recoverable operation feedback.
- Use dialogs sparingly for destructive actions.
- Never show raw stack traces to users.
