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

## User feedback

- Use inline validation for forms.
- Use SnackBars for recoverable operation feedback.
- Use dialogs sparingly for destructive actions.
- Never show raw stack traces to users.
