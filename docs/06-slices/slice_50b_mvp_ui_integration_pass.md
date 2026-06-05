# Slice 50b — MVP UI Integration Pass

Status: done

## Goal

Wire existing local-first foundations into visible MVP surfaces before Slice 51:

- browse the bundled official exercise catalog,
- view local workout groups and assignment counts,
- log a set from Today through the existing training-log use case,
- refresh Today after a saved set,
- keep readiness visible on Today,
- expose small honest coach/recommendation preview copy without claiming a full
  coach screen.

## Implementation Notes

- Added an on-demand bundled catalog import adapter that reads the current
  catalog manifest and imports the official JSON asset into Drift before
  catalog browsing or quick logging.
- Replaced the Exercises placeholder with a localized repository-backed catalog
  list, search field, loading/empty/error/success states, and compact equipment,
  movement-pattern, and primary-muscle chips.
- Replaced the Groups placeholder with a localized repository-backed group list,
  exercise counts, assignment previews, loading/empty/error/success states, and
  a careful local coach preview.
- Enabled Today's `Log set` quick action when the app has catalog and save-set
  dependencies, opening a compact dialog for exercise selection, load, reps,
  label, and comment.
- Quick logging saves through `SaveWorkoutSet`, preserving `ExerciseRef`
  snapshots, then refreshes the existing Today dashboard loader.
- No new domain algorithms, cloud services, remote catalog fetches, sync,
  accounts, payments, wearables, medical claims, blocking logic, custom exercise
  creation, full group editing, full coach screen, heatmap, or body graphic were
  added.

## Test Coverage

- Exercises page loading, empty, error, success, and search forwarding.
- Groups page loading, empty, error, success, and semantic group summaries.
- Today quick action enabled state and refresh after a saved set.
- Quick log dialog save path through `SaveWorkoutSet` and German/English
  localized visible strings.
- App navigation smoke test now expects wired Groups and Exercises surfaces
  instead of placeholders.

## Follow-ups

- Add full group editing and custom exercise creation in explicit later slices.
- Add exercise detail/timeline and analytics exercise selection in a later UI
  slice.
- Add a real localized coach/recommendation surface only when the required
  bounded inputs and presentation scope are explicitly requested.
