# User Profile and Goals

## Purpose

User profile settings personalize recommendations without forcing a rigid training identity.

## Onboarding fields

- Sex/gender: male, female, other, prefer not to say.
- Primary goal: hypertrophy, strength, general fitness, recomposition, maintenance.
- Focus profile: balanced, upper-body focus, lower-body/glute focus, arms/chest focus, strength basics, time-efficient, beginner foundation, custom.
- Training days per week.
- Typical session duration.
- Equipment access.
- Experience level.
- Recovery sensitivity.
- Coaching strictness.

## Important rule

Sex/gender should not hard-code stereotypes. It may preselect common defaults, but focus profile and explicit user settings are authoritative.

Example:

- A male user can choose lower-body/glute focus.
- A female user can choose upper-body focus.
- Any user can choose balanced or custom.

## Equipment taxonomy

Initial equipment tags:

- bodyweight
- barbell
- dumbbell
- cable
- machine
- smith machine
- pull-up bar
- bench
- rack
- leg press
- cardio machine later

## Session duration buckets

- 15 minutes
- 25 minutes
- 35 minutes
- 45 minutes
- 60 minutes
- 75+ minutes

## Recommendation impact

Profile settings affect:

- exercise filters,
- target muscle ratios,
- quick session generation,
- rest defaults,
- progression aggressiveness,
- deload sensitivity,
- analytics explanations.

## v5 onboarding defaults

On first app start, collect:

- system-derived language, with English fallback,
- sex/gender or `prefer not to say`,
- age or birth year,
- body weight,
- optional height,
- primary training goal,
- focus profile,
- training days per week,
- typical session duration,
- available equipment,
- maximum load/increment for relevant home-gym equipment.

Keep every field editable later. The tracker must remain usable even if the user skips optional fields.

## Slice 22 settings foundation

The current local settings foundation persists a compact editable subset:

- language override: system, English, or German,
- units: metric or imperial placeholder,
- theme preference: system, dark, or light,
- default rest time,
- optional profile display name,
- focus profile,
- training days per week,
- typical session duration,
- structured equipment inventory.

The broader onboarding/body-metric fields remain planned for the onboarding and
recommendation slices. Settings saves must not reinterpret existing logged sets,
workout groups, or official catalog data.

## Slice 23 onboarding foundation

Onboarding currently writes the Slice 22 settings subset plus onboarding
completion status: optional profile display name, focus profile, training days
per week, typical session duration, and equipment inventory. Broader body
metrics and home-gym max-load values remain planned because they do not yet have
persisted settings fields.

## Slice 44 training profile model

Slice 44 extends the existing local settings/profile model instead of creating a
second profile aggregate. The implemented vocabulary is:

- sex/gender preference: unspecified, male, female, other, prefer not to say,
- birth year,
- body weight in kg,
- optional height in cm,
- primary training goal: hypertrophy, strength, general fitness,
  recomposition, or maintenance,
- focus profile from the existing focus list,
- training days per week,
- preferred session duration bucket,
- recovery sensitivity: low, normal, high,
- coaching strictness: gentle, balanced, direct,
- structured equipment inventory, including rack,
- optional per-equipment max load and load increment in kg.

Unknown or skipped body/profile fields are first-class valid states. Defaults
remain user-overridable and keep the app usable without a completed profile.

Sex/gender preference is stored only as user-declared profile context. It must
not drive hard-coded training rules, stereotypes, or fixed focus assumptions.
Explicit user choices such as focus profile, goals, equipment, and recovery
sensitivity are authoritative for future personalization.

Home-gym load constraints are modeled as optional equipment metadata. They can
inform equipment-aware filtering, recommendations, quick sessions, and adaptive
set suggestions, but they do not reinterpret existing logged sets. Slice 50 uses
max-load and increment constraints to avoid suggesting unavailable load jumps.
Wearables, calorie estimation, and muscle-load algorithms remain outside this
profile model.

## Slice 53 wearable/calorie boundary

The existing profile fields may become optional inputs to a future rough calorie
estimator:

- body weight in kg,
- birth year or derived age,
- sex/gender preference if the selected formula requires it,
- typical session duration only as a fallback hint, never as a replacement for
  an actual logged workout duration.

These fields remain optional. Missing body metrics must keep RepForge usable and
must either make calorie estimates unavailable or lower confidence. Sex/gender
preference remains user-declared context, not a training stereotype or a
required identity field.

Slice 53 does not add new profile fields, health permissions, wearable SDKs,
health-data storage, or calorie UI. Future calorie work must explain which
profile fields are used, label outputs as rough estimates, and keep local
tracking available when profile data is skipped.
