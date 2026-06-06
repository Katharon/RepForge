# Slice 63 - Input Guards, Undo/Edit, and Extreme-Value Protection

## Goal

Harden workout-set input UX so users get clear soft warnings before saving
unusually high values, while still allowing intentional expert entries.

The slice should protect against accidental typos in quick logging, mark extreme
values honestly in display surfaces, and keep all behavior local-first.

## Scope

In scope:

- Pure-Dart workout-set input guard model with centralized conservative
  thresholds.
- Confirmation dialog before saving suspicious but otherwise valid set input.
- Shared quick-log integration for Today, Exercise Detail, custom exercises,
  and active workout-session logging.
- Post-save SnackBar affordance with Undo where safe, plus an explicit note that
  richer edit affordances stay a later follow-up unless the existing editor path
  can be reused without broadening this slice.
- Display warnings for unusually high daily volume and suspicious set rows.
- English and German localization, semantics, and focused tests.

Out of scope:

- Automatic correction, hard caps, or silent clamping of valid values.
- Rewriting, deleting, or hiding historical set data.
- Full bulk cleanup, audit log, or broad edit wizard.
- Medical advice, injury prediction, or shaming language.
- Cloud services, Firebase, sync, social runtime, wearables, ads, payments, or
  broad redesign.

## Thresholds

Initial soft warning thresholds are intentionally conservative:

- repetitions greater than `100`,
- load greater than `500 kg`,
- single-set volume greater than `20,000 kg`,
- daily volume greater than `100,000 kg`.

These thresholds produce confirmation and display warnings only. They do not
make the value invalid. Existing validation still rejects malformed numbers,
non-positive repetitions, and unsupported negative loads.

## Implementation Notes

- The guard should stay in the pure-Dart training-log boundary.
- Warning copy should say values look unusually high and ask whether to save
  anyway.
- Historical extreme values remain visible. The implemented quick correction
  path is post-save Undo; richer edit/delete history actions remain a later
  follow-up.
- Calculations should not be silently capped; any warning is display-only.

## Validation

Slice 63 should validate:

- full localization/code generation and catalog validation,
- formatting, analyzer, full and focused tests,
- domain purity and no-cloud/no-medical/no-silent-clamp guardrail searches,
- debug APK build if feasible.

## Completion

In progress.
