# Information Architecture

## Primary navigation

Suggested main areas:

1. Today
2. Train
3. Exercises
4. Analytics
5. Settings

## Today

Purpose: fastest path to action.

Contains:

- readiness summary,
- active workout-session banner when a local session is in progress or has just
  completed,
- recent training summary,
- rest timer if active,
- quick set logging from the local official exercise catalog,
- later: recommended next workout/group,
- later: quick session button,
- later: full coach card.

Slice 50b wires Today to a compact `Log set` dialog. The dialog selects an
official exercise from the bundled catalog, captures load, repetitions, label,
and comment, saves locally, and refreshes the existing Today summary.

## Train

Purpose: fastest path into a workout plan or training split.

Contains now:

- Setgraph-inspired split/folder categories:
  My Exercises, Full Body, Upper Body, Lower Body, Push, Pull, Legs, and Core,
- category drill-in to matching local catalog exercises,
- local workout-session starter and active/completed session banner inside a
  selected category,
- search within the selected category,
- exercise rows open Exercise Detail with recent history and quick logging,
- disabled/future New workout action,
- optional starter-group previews when local groups exist.

Later:

- create/edit/archive groups,
- create/edit custom splits,
- assign/reorder exercises,
- recommended exercise order,
- group analytics.

Implementation note: Slice 57 relabels the visible Groups destination to
Train/Training while keeping the internal `groups` route stable. Category
filtering is a deterministic presentation/read-model helper based on existing
catalog metadata, not coaching guidance.

Implementation note: Slice 61 adds the first lightweight session state. Starting
a session from a Train category creates an in-memory active session, logs future
sets with the existing optional session ID, and shows compact active/completed
summary cards without adding a full planner.

## Exercises

Purpose: find and manage exercises.

Contains now:

- official bundled exercises imported into local storage,
- localized catalog names,
- search,
- equipment, movement-pattern, and primary-muscle chips,
- full catalog/library browsing separate from Train split navigation.

Later:

- custom exercises,
- advanced filters by muscle/equipment/movement,
- favorites/hidden,
- exercise detail timeline beyond the compact recent history surface.

## Exercise Detail

Purpose: inspect one exercise before logging or analyzing.

Contains now:

- localized exercise title and metadata chips,
- compact Analytics and 1RM entry cards that open the Exercise Analytics chart
  screen for the same stable exercise reference,
- compared-to-previous-session metric summary,
- bounded recent set history grouped by local calendar date,
- visible Log Set action preselected to the current exercise.
- active workout-session banner when a local session is in progress or has just
  completed.

Later:

- deeper timeline pagination,
- custom-exercise editing once custom exercises are implemented,
- coach/adaptive next-set UI only in its explicit later slice.

## Exercise Analytics

Purpose: inspect one exercise's local trend before deciding what to do next.

Contains now:

- stable exercise title carried from Exercise Detail,
- metric selector for Sets, Reps, Volume, kg/rep, and Estimated 1RM,
- range selector for D, W, 2W, M, 3M, 6M, and All,
- deterministic lightweight chart for local logged sets,
- selected point summary with metric value, local date/time, reps, and load,
- honest empty, unavailable, error, one-point, multi-point, and
  limited-history states.

Implementation note: Slice 59 keeps the chart local-first and bounded. The All
range uses the latest 100 local sets loaded through the timeline API and shows a
limited-history notice when more sets exist.

Implementation note: Slice 60 adds a compact next-set signal inside Exercise
Detail only after a set is saved. It stays advisory, dismissible, and non-modal;
logging remains available regardless of the signal.

Implementation note: Slice 61 threads active workout-session context through
Exercise Detail so users can keep orientation while logging, without changing
the existing detail refresh or adaptive-suggestion behavior.

## Analytics

Purpose: understand progress.

Contains now:

- exercise metric summary cards,
- exercise trend chart,
- estimated 1RM card,
- local muscle load and balance dashboard,
- focus-aware imbalance signals with suggested actions,
- partial-data and readiness-softened explanations.

Later:

- richer date-bounded muscle load queries,
- catalog-authored activation weights,
- optional schematic visuals that are not body heatmaps unless explicitly scoped,
- 1RM estimates,
- time-window comparisons.

## Settings

Purpose: configure user and app.

Contains:

- profile/focus,
- equipment,
- training frequency/time,
- units,
- theme,
- rest defaults,
- backup/export/import,
- premium later,
- integrations later.

## Legacy screenshot mapping

The old Setgraph exercise detail screen maps to:

- `Exercise Detail`
- `Set Timeline`
- `Rest Timer Banner`
- `Analytics Entry Point`
- `1RM Entry Point`
- `Floating Add Set Button`

The new app should preserve the fast logging feel but improve clarity, recommendation quality, and analytics explanation.
