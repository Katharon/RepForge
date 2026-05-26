# State Management with BLoC/Cubit

## Decision

Use `flutter_bloc` for non-trivial screen state. Use Cubit for simple command/state flows and Bloc for event-heavy flows.

## Guidelines

- Cubit is enough for simple screens: list, load, refresh, select.
- Bloc is better when user events, timers, notification reactions, and navigation side effects become more complex.
- BLoC state must be immutable.
- UI must not mutate state objects.
- Use `BlocListener` for one-off side effects such as SnackBars and navigation.
- Use `BlocBuilder` for rendering.
- Use `BlocSelector` for performance-sensitive small state selections.

## State design

Prefer explicit states:

```text
Initial
Loading
Loaded(data)
Saving(data)
Error(message, previousData?)
```

For complex screens, use a single immutable view state object:

```dart
class ExerciseDetailState {
  final LoadStatus status;
  final ExerciseView exercise;
  final List<WorkoutSetView> sets;
  final RestTimerView? timer;
  final String? errorMessage;
}
```

## Timer state

Timers must not depend only on `Timer.periodic` state. Store `startedAt` and `dueAt`, then derive remaining time from a clock. This prevents incorrect countdown behavior after app pause/resume.

## Testing

Use `bloc_test` for Cubit/Bloc state transitions. Mock application use cases, not database internals.
