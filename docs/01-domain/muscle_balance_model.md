# Muscle Balance Model

## Purpose

Help the user avoid obvious long-term neglect of muscles and movement patterns while respecting their chosen focus.

## Concept

The app tracks estimated rolling muscle load from logged sets and compares it to target ranges derived from the user's focus profile.

Slice 45 supplies the input foundation only. Muscle balance detection should read
`MuscleLoadEstimate` values from the analytics domain, use the estimate
confidence, and carry unknown exercises forward as incomplete evidence instead
of treating missing activation data as zero muscle work.

If a rolling window contains unavailable activation data, later balance
detection should avoid strong conclusions for affected muscles and present the
result as a partial signal. Conservative estimates, such as bodyweight-only or
incomplete load inputs, can still be used for trend direction but should not be
shown as precise workload.

## Main dimensions

- Chest
- Back / lats
- Upper back
- Rear delts
- Front/side delts
- Biceps
- Triceps
- Quadriceps
- Hamstrings
- Glutes
- Calves
- Core
- Traps / neck optional later

Movement dimensions:

- Horizontal push
- Vertical push
- Horizontal pull
- Vertical pull
- Squat/knee-dominant
- Hinge/hip-dominant
- Unilateral lower
- Core anti-extension/anti-rotation/flexion

## Focus-aware balance

Balanced means broad coverage. It does not mean identical volume for each muscle.

Upper-body focus can intentionally overweight upper body, but should preserve lower-body minimums.

Lower-body/glute focus can intentionally overweight lower body, but should preserve upper-back and posture-supporting work.

Arms/chest focus can intentionally overweight chest/arms, but should warn if pulling/rear-delt work is too low.

## Output

The UI should show simple statuses:

- On track
- Slightly under target
- Strongly under target
- Above target
- Recovery limited

## Avoiding user frustration

Do not punish users. Show constructive guidance:

- `Your pulling work is below your push work. Add one back exercise this week.`
- `Hamstrings are under target for your plan. Consider a hinge movement.`
- `Triceps are under-stimulated because you chose more chest isolation today.`

## Tests

Test the balance model with deterministic sample histories:

- Push-heavy week triggers pull/rear-delt warning.
- Leg-neglect week triggers lower-body minimum warning for balanced profile.
- Upper-body focus tolerates higher chest/arm load but still warns on zero legs.
- Lower-body focus tolerates higher glute/quad load but still warns on no upper-back work.
