# Domain Events

Domain events are optional at first. They should be introduced only when they simplify coordination between features.

## Candidate events

- `WorkoutSetLogged`
- `WorkoutSetUpdated`
- `WorkoutSetDeleted`
- `ExerciseCreated`
- `ExerciseArchived`
- `RestTimerStarted`
- `RestTimerCompleted`
- `PreferencesChanged`
- `EntitlementChanged`

## Initial approach

Do not build an event bus in early slices. Use explicit use-case return values and BLoC reactions first. Add domain events only if the timer, analytics refresh, notification scheduling, and sync features become difficult to coordinate.

## Event payload rule

Events should contain IDs and minimal values, not full mutable object graphs.
