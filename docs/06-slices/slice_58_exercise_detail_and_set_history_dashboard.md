# Slice 58 - Exercise Detail and Set History Dashboard

## Goal

Add a Setgraph-inspired, RepForge-native Exercise Detail screen reachable from
Train split exercise lists and the full Exercises catalog.

This slice focuses on exercise detail and recent history UX. It does not add a
full chart screen, full workout-session engine, custom exercise editor, custom
split editor, adaptive next-set UI, cloud services, Firebase, sync, social
runtime, health/wearable runtime, ads, payment changes, or schema migrations.

## Implementation Summary

- Adds an Exercise Detail route under both Train and Exercises so normal back
  navigation returns to the source list.
- Carries a stable exercise reference through route parameters and snapshot
  query values, not only display text.
- Shows localized exercise title, compact metadata chips, Analytics and 1RM
  entry cards/placeholders, and a prominent Log Set action.
- Uses existing training-log timeline APIs for bounded recent set history.
- Uses the existing exercise analytics use case/read model for current metrics
  and previous comparable session context.
- Groups set history by local calendar date and displays time, load,
  repetitions, optional set label, and optional comment.
- Opens the existing quick-log dialog with the current exercise preselected and
  refreshes detail data after a successful save.

## Boundaries

- The detail loader is a presentation read-model adapter over existing
  repository/use-case contracts.
- History loading is bounded; the UI does not call unbounded history APIs.
- Compact Analytics and 1RM cards are entry placeholders for Slice 59 rather
  than full chart interactions.
- Missing history or missing previous comparable data renders neutral empty or
  unavailable states.

## Validation Result

Pre-block validation passed earlier in this slice:

- `git status --short`
- `git rev-parse --short HEAD`
- `git log --oneline -12`
- `flutter pub get`
- `flutter gen-l10n`
- `dart run tool/validate_catalog.dart`
- `dart run build_runner build --delete-conflicting-outputs`
- focused Flutter tests for exercise catalog, workout groups, training log,
  analytics, and app routing/widget smoke coverage
- `flutter analyze`
- `git diff --check`

After the final localization-label patch, repo-local validation passed:

- `git diff --check`
- `git diff --exit-code -- lib test` reported intentional Slice 58 diffs
- domain Drift/SQLite import guardrail returned no hits
- domain Flutter/UI import guardrail returned no hits
- no-cloud/backend guardrail hit existing boundary docs/fake gateways plus this
  slice's boundary note, with no new runtime cloud dependency

Final `dart format`, Flutter test suites, `scripts/check.sh`,
`flutter build apk --debug`, and the required commit could not be completed in
this environment because Dart/Flutter attempted SDK-cache writes outside the
workspace and the required escalation was automatically rejected after the
environment hit its usage limit.

## Follow-ups

- Build full exercise charts and range interactions in Slice 59.
- Add exercise detail/timeline deep links for custom exercises only when custom
  exercise creation exists.
- Keep future coach/adaptive set suggestions advisory and separate from this
  history dashboard.
