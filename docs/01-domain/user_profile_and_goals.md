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
