# Onboarding and Settings

## Onboarding goal

Collect just enough information to make recommendations useful without delaying logging.

## Steps

1. Welcome and local-first/privacy promise.
2. Goal and focus profile.
3. Training days per week and typical session duration.
4. Available equipment.
5. Optional sex/gender and body metrics for defaults/calorie estimates.
6. Import sample groups or create first group.
7. Start first workout.

## Focus selection copy

Examples:

- Balanced: `Build your whole body with broad coverage.`
- Upper-body focus: `More upper-body emphasis while keeping minimum leg and back balance.`
- Lower-body/glute focus: `More lower-body emphasis while keeping posture and upper-body balance.`
- Arms/chest focus: `Aesthetic chest and arm focus with balance guardrails.`
- Strength basics: `Simple progression around fundamental movement patterns.`
- Time-efficient: `Short sessions with high-value exercises.`
- Beginner foundation: `Simple, guided, conservative progress.`

## Do not shame users

Even if a user chooses a `discopumper`-style focus, the app should not mock them. Internally call it `armsChestFocus` or `upperBodyFocus`. UI can use friendly language.

## Settings later

Allow changing:

- focus profile,
- equipment,
- session duration,
- training frequency,
- coaching strictness,
- soreness reminders,
- units,
- theme,
- privacy/export settings.

## Slice 22 settings surface

The Settings tab now exposes the MVP-local controls for language override,
units, theme preference, default rest time, optional profile name, focus
profile, training frequency, session duration, and available equipment. It does
not implement the onboarding wizard, starter groups, recommendation logic, or
privacy/export settings.

## Slice 23 onboarding surface

The app now shows a skippable local setup flow before the Today dashboard until
the user skips or completes onboarding. The flow captures optional profile name,
focus profile, training days per week, typical session duration, equipment
inventory, and whether to create starter workout groups from bundled local
templates. Starter groups are user-local workout groups and can be edited or
deleted by later group-management flows.

Home-gym max-load values are not collected yet because the current settings
model does not persist max-load fields.

## Slice 44 profile model readiness

The local settings/profile model now supports optional body/profile basics,
primary training goal, recovery sensitivity, coaching strictness, rack
equipment, and per-equipment max-load/increment constraints. The current
Settings and Onboarding surfaces keep their compact Slice 22/23 controls; they
preserve existing load constraints when equipment chips are toggled, but Slice
44 does not add a large form redesign, readiness check-in UI, coach UI, or
recommendation flow.

## v5 onboarding additions

Localization:

- The app starts in the system language when supported.
- If unsupported, it starts in English.
- A language override can be added in settings.

MVP onboarding should collect:

1. Local-first/privacy explanation.
2. Body/profile basics: sex/gender, age or birth year, body weight, optional height.
3. Goal and focus profile.
4. Training days per week.
5. Typical session duration.
6. Equipment inventory.
7. Maximum usable load for relevant home-gym equipment.
8. Units.
9. Optional starter groups.

Do not block the user from logging if optional health/body fields are skipped.
