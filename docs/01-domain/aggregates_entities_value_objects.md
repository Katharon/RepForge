# Aggregates, Entities, and Value Objects

## Aggregates

### UserProfile

Fields:

- `UserProfileId`
- `displayName` optional
- `sexOrGender` optional enum: `male`, `female`, `other`, `preferNotToSay`
- `primaryGoal`: hypertrophy, strength, general fitness, maintenance, recomposition
- `focusProfile`: balanced, upperBodyFocus, lowerBodyGluteFocus, armsChestFocus, strengthBasics, timeEfficient, beginnerFoundation, custom
- `trainingDaysPerWeek`
- `typicalSessionDurationMinutes`
- `availableEquipment[]`
- `experienceLevel`
- `recoverySensitivity`
- `coachingStrictness`

Rule: Sex/gender may influence defaults and wording, but user choice and explicit focus override defaults.

### OfficialExerciseDefinition

Bundled app-catalog exercise.

Fields:

- `catalogId`
- `catalogVersionIntroduced`
- `canonicalName`
- `localizedNames`
- `aliases`
- `movementPatterns[]`
- `equipment[]`
- `primaryMuscles[]`
- `secondaryMuscles[]`
- `stabilizerMuscles[]`
- `activationProfile`
- `defaultRestDuration`
- `trackingMode`
- `difficulty`
- `contraindicationNotes` optional, non-medical wording only

Rule: Official definitions are immutable after import. New corrections create a new catalog version or migration rule.

### CustomExercise

User-created exercise.

Fields:

- `customExerciseId`
- `name`
- `aliases`
- `equipment[]`
- `primaryMuscles[]`
- `secondaryMuscles[]`
- `activationProfile` optional
- `defaultRestDuration`
- `trackingMode`
- `archivedAt`

### WorkoutGroup

User-created training group/day.

Fields:

- `workoutGroupId`
- `name`
- `description`
- `icon`
- `colorToken`
- `sortOrder`
- `groupFocus`
- `exerciseRefs[]`
- `archivedAt`

### TrainingSession

Fields:

- `trainingSessionId`
- `workoutGroupId` optional
- `startedAt`
- `endedAt` optional
- `readinessSnapshot` optional
- `notes`

### WorkoutSet

Fields:

- `workoutSetId`
- `exerciseRef`
- `trainingSessionId` optional
- `repetitions`
- `load`
- `performedAt`
- `label`
- `comment`
- `rpe` optional
- `rir` optional
- `source`

## Value objects

- `ExerciseRef`: references either official catalog ID or custom exercise ID.
- `Load`: numeric value plus unit.
- `RepetitionCount`: positive integer.
- `VolumeLoad`: calculated `load * repetitions`.
- `MuscleId`: stable ID for muscle/muscle group.
- `ActivationWeight`: decimal 0.0–1.0 estimate.
- `MuscleLoad`: weighted set/volume contribution by muscle.
- `PeriodRange`: day/week/month/custom.
- `ReadinessScore`: derived non-medical readiness signal.
- `SorenessScore`: user input 0–10 or enum none/light/moderate/high.
- `RecommendationReason`: explainable reason shown in UI.

## Read models

- `ExerciseListItem`
- `WorkoutGroupOverview`
- `ExerciseTimelineEntry`
- `AnalyticsMetricCard`
- `MuscleLoadOverview`
- `ImbalanceWarning`
- `RecommendedExerciseItem`
- `QuickSessionPlan`
