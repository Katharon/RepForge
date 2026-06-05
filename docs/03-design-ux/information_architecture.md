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
- search within the selected category,
- exercise rows open Exercise Detail with recent history and quick logging,
- disabled/future New workout action,
- optional starter-group previews when local groups exist.

Later:

- start session,
- create/edit/archive groups,
- create/edit custom splits,
- assign/reorder exercises,
- recommended exercise order,
- group analytics.

Implementation note: Slice 57 relabels the visible Groups destination to
Train/Training while keeping the internal `groups` route stable. Category
filtering is a deterministic presentation/read-model helper based on existing
catalog metadata, not coaching guidance.

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
- compact Analytics and 1RM entry cards as honest placeholders for the next
  chart slice,
- compared-to-previous-session metric summary,
- bounded recent set history grouped by local calendar date,
- visible Log Set action preselected to the current exercise.

Later:

- full charts and range interactions,
- deeper timeline pagination,
- custom-exercise editing once custom exercises are implemented,
- coach/adaptive next-set UI only in its explicit later slice.

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

- exercise selection/detail handoff,
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
