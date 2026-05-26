# Vision

## Product idea

RepForge is a modern workout tracking app inspired by the user's older Setgraph-style app. It must keep the speed and focus of the old app while becoming cleaner, more robust, more maintainable, and ready for a production-grade Flutter codebase.

## Core promise

The app helps strength-training users log sets extremely quickly, understand their progress without spreadsheet work, and time their rest periods without leaving the workout flow.

## Product personality

- Dark, athletic, precise.
- Fast interaction over decorative complexity.
- Data-rich but not visually overloaded.
- Distinctive enough to not feel like a stock Android Material demo.
- Clear enough to use during a workout under fatigue.

## Primary users

1. Strength-training users who log exercises, reps, weight, and rest time.
2. Users who want trend analytics such as sets, reps, volume, kg/rep, and estimated 1RM.
3. Advanced users who may later pay for cloud sync, deeper analytics, backup, templates, and multi-device features.

## Product constraints

- Mobile-first: Android and iOS are the primary platforms.
- Offline-first: core set logging and analytics must work without internet.
- Data integrity matters more than visual novelty.
- The app must be easy for Codex to extend slice by slice.
- The implementation must stay testable and not turn into a widget-only prototype.

## Long-term product direction

MVP should be a strong local workout tracker. Production v1 can add polished analytics, backup/export, local notifications, and release hardening. Premium and cloud features should be introduced behind interfaces and feature gates after the local core is stable.
