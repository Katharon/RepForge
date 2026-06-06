# Component Catalog

## Core app components

- `AppScaffold`
- `NavigationShell` — implemented as the feature-neutral mobile shell for the
  main MVP destinations.
- `AppCard` — implemented as the feature-neutral base surface component.
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
- `WorkoutSessionStatusCard` — implemented in the training-log presentation
  layer for reusable active/completed local session summaries on Train, Today,
  and Exercise Detail.

## Timer components

- `RestTimerCapsule`
- `CircularCountdownIndicator`
- `TimerActionButton`

## Today components

- `TodayMetricCard`
- `TodayLastLoggedSetCard`
- `TodayRestTimerCard`
- `TodayQuickActionCard`
- `TodayAnalyticsHintCard`

## Analytics components

- `AnalyticsRangeSelector`
- `MetricSelectorTabs`
- `PeriodComparisonCard`
- `AnalyticsChartCard`
- `OneRepMaxFormulaSelector`
- `MuscleLoadDashboardSection` — implemented as the Slice 51 Analytics section
  for estimated weekly/rolling muscle load, focus-aware balance signals, and
  constructive suggested actions.

## Settings components

- `SettingsSection` — implemented inside the Settings feature for the compact
  local settings foundation.
- `SettingsRow`
- `UnitSystemSelector` — represented by the Slice 22 settings dropdown.
- `ThemeModeSelector` — represented by the Slice 22 settings dropdown.
- `NotificationPrivacySelector`

## Component rules

- Components should accept view models, not domain entities directly, when presentation formatting is non-trivial.
- Components must be widget-testable.
- Reusable visual components belong in `core/widgets` only when feature-neutral.
- Stable visual components or screens may have focused golden baselines in
  `test/goldens/` when they can be rendered with fixed locale, theme, surface
  size, and deterministic fake content.
