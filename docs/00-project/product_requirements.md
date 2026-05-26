# Product Requirements

## Purpose

Build a modern Flutter workout tracking app that helps users log strength training quickly and understand their progress. The MVP is intentionally focused: **tracker + workout groups + analytics**. Coaching, recovery, recommendations, premium entitlements, social features, and wearables are planned as later extensions, but the domain model must not block them.

## Product identity

The app name is `RepForge`.

The app is inspired by the old Setgraph-style app screenshots, but it must not be a clone. It should keep the strengths of the old app — dark theme, fast set logging, dense exercise history, rest timer, analytics, and simple navigation — while becoming a modern, original Flutter product with a cleaner UX system.

## Language and localization

The app must support multilingual UI from the beginning.

Rules:

- On first launch, use the smartphone/system locale automatically.
- If the system locale is supported, show that language.
- If the system locale is not supported, fall back to English.
- English must be the canonical fallback language and should be the first supported locale.
- German should be included early because the initial user/developer context is German-speaking.
- Users may later override the app language in settings.

## Primary users

- Gym users who want to track weights/reps/sets over long periods.
- Users who organize training by groups such as Push, Pull, Legs, Upper, Lower, Full Body, or custom days.
- Users who want useful analytics without needing spreadsheets.
- Home-gym users with limited equipment and finite available load.
- Users who later want guidance, but must be able to use the local tracker without an account.

## MVP scope

The MVP contains only:

1. Local-first workout tracking.
2. Workout groups/training days.
3. Official small exercise catalog plus custom exercises.
4. Exercise assignment to groups.
5. Set logging with weight, repetitions, timestamp, optional comment/label.
6. Analytics for exercises/groups/time ranges.
7. Local settings/onboarding required for later equipment-aware coaching.
8. Local backup/export/import.

## MVP non-goals

The MVP does **not** include:

- Cloud sync.
- Cloud exercise database.
- Friends/social feed.
- Wearable integration.
- App-store payments.
- AI/cloud coach.
- Fully automated program generation.
- Medical diagnosis or injury treatment.

## Workout groups

Users can create, rename, reorder, archive, and delete workout groups.

Examples:

- `Push Day`
- `Pull Day`
- `Leg Day`
- `Upper`
- `Lower`
- `Full Body`
- `Arms`
- `Chest Focus`
- custom names

Users can assign one exercise to multiple groups.

## Exercises

Users can use two exercise sources:

1. Official bundled exercises shipped with the app.
2. Custom exercises created locally by the user.

Official exercises must support:

- stable catalog ID,
- localized names,
- aliases,
- primary and secondary muscles,
- approximate activation weights,
- movement pattern,
- equipment requirements,
- default rest duration,
- tracking mode.

Custom exercises must support enough metadata for analytics and future coaching, but the user may start with minimal fields and add muscle/equipment metadata later.

## Initial official catalog

Start small and clean. The first bundled catalog should prioritize fundamental compound movements and a few essential accessory movements.

Suggested initial categories:

- Squat pattern: back squat, front squat, goblet squat, leg press.
- Hinge pattern: deadlift, Romanian deadlift, hip thrust.
- Horizontal push: bench press, dumbbell bench press, push-up, chest press.
- Vertical push: overhead press, dumbbell shoulder press.
- Horizontal pull: barbell row, cable row, machine row.
- Vertical pull: pull-up, lat pulldown.
- Knee flexion/accessory: leg curl.
- Knee extension/accessory: leg extension.
- Calves: standing/seated calf raise.
- Arms: biceps curl, triceps pushdown.
- Core: plank, hanging knee raise.

The catalog can expand through versioned app patches after validation.

## Equipment inventory requirement

The user must be able to configure available equipment during onboarding and later in settings.

The model must support both commercial gyms and home gyms.

Minimum equipment data:

- equipment type: barbell, dumbbell, machine, cable, bench, pull-up bar, bodyweight, etc.
- availability: available, unavailable, limited.
- maximum usable load in kg where relevant.
- minimum increment in kg where relevant.
- notes or custom label.

Example home-gym constraint:

A user has a barbell and plates, but the maximum loaded barbell weight is 80 kg. A future coach must not blindly suggest `bench press 100 kg`. It should either cap the suggestion, adjust reps/sets, suggest tempo/paused variants, or propose an alternative exercise that fits the available equipment.

## Onboarding data

On first launch, collect only the information that is needed for tracking and future recommendations:

- preferred language derived from system locale, with optional override later,
- sex/gender or `prefer not to say`,
- age or birth year,
- body weight,
- optional height,
- training goal,
- focus profile,
- training days per week,
- typical session duration,
- equipment inventory,
- unit system,
- optional sample groups.

All fields must be editable later.

## Focus profiles

Focus profiles are user-controlled, not stereotypes.

Possible profiles:

- Balanced.
- Upper-body emphasis.
- Lower-body/glute emphasis.
- Arms/chest emphasis.
- Strength basics.
- Time-efficient.
- Beginner foundation.
- Custom.

Sex/gender may help select default copy or initial suggestions, but it must not lock training assumptions. A male user can choose lower-body/glute emphasis, and a female user can choose upper-body emphasis.

## Set tracking

Users can log entries with:

- exercise,
- weight/load,
- repetitions,
- timestamp,
- optional label,
- optional comment,
- later: RPE/RIR, perceived difficulty, pain/soreness flag.

## Analytics

The app must provide useful, understandable metrics:

- sets,
- repetitions,
- volume (`weight * reps`),
- kg/rep (`volume / reps`),
- estimated 1RM,
- best set,
- previous comparable session delta,
- time-window delta: day/week/2 weeks/month/3 months/6 months/all,
- group-level history,
- muscle load by muscle group later,
- balance/imbalance signals later.

For the MVP, analytics should explain what changed. Later coaching should explain what to do next.

## Monetization direction

Use a freemium model, not a hard paywall after the trial.

Free forever:

- local tracking,
- workout groups,
- official base catalog,
- custom exercises,
- core analytics,
- local backup/export/import.

Premium:

- coach/recommendation engine,
- smart exercise order,
- adaptive alternatives,
- muscle-balance dashboard,
- recovery/readiness guidance,
- advanced periodization/progression suggestions,
- quick-session generator,
- wearable-based calorie/readiness features,
- advanced export/reporting,
- optional social comparison later.

A free Premium trial can be offered through app-store subscription mechanisms. The app must clearly communicate what is free, what is premium, trial length, renewal price, and restore-purchase options.

## Training disclaimer and safety

The app provides training guidance and estimates, not medical diagnosis. It should use careful wording around readiness, pain, recovery, calories, and soreness. It may suggest reducing load, skipping painful movements, or consulting a qualified professional if pain/injury/medical issues are present.

## Official exercise catalog without cloud database

The official catalog is bundled with the app as versioned assets.

Requirements:

- stable catalog IDs,
- versioned catalog manifest,
- muscle activation estimates per exercise,
- equipment tags and constraints,
- movement pattern tags,
- body region tags,
- import/migration logic into local storage,
- user override table for hiding, favoriting, default rest changes, notes, and group assignment,
- no paid cloud database for catalog lookup.

## Future capabilities

- Coach/recommendation engine.
- Muscle-balance dashboard.
- Recovery/readiness check-ins.
- Quick-session mode.
- Body metrics and calorie estimates from age/sex/height/weight and workout duration.
- Wearable/health platform integration for heart rate and activity data.
- Friends/social feed to compare training activity and recovery signals.
- Optional account and sync.
- Premium entitlements through app stores.
