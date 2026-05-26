# Component Catalog

## Core app components

- `AppScaffold`
- `AppCard`
- `MetricRail`
- `MetricValueText`
- `DateStrip`
- `EmptyState`
- `ErrorState`
- `LoadingSkeleton`
- `ConfirmDestructiveActionDialog`

## Training components

- `ExerciseListTile`
- `WorkoutSetTile`
- `SetDateGroupHeader`
- `QuickAddSetButton`
- `SetLabelChip`
- `ExerciseSearchField`
- `ProgramCard`

## Timer components

- `RestTimerCapsule`
- `CircularCountdownIndicator`
- `TimerActionButton`

## Analytics components

- `AnalyticsRangeSelector`
- `MetricSelectorTabs`
- `PeriodComparisonCard`
- `AnalyticsChartCard`
- `OneRepMaxFormulaSelector`

## Settings components

- `SettingsSection`
- `SettingsRow`
- `UnitSystemSelector`
- `ThemeModeSelector`
- `NotificationPrivacySelector`

## Component rules

- Components should accept view models, not domain entities directly, when presentation formatting is non-trivial.
- Components must be widget-testable.
- Reusable visual components belong in `core/widgets` only when feature-neutral.
