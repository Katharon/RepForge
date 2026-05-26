# ChatGPT Meta Prompts

These are prompts the user can send to ChatGPT to generate high-quality Codex prompts without re-explaining the project.

## Generate next slice prompt

```text
Use the Gym-App project docs. Generate the exact English Codex prompt for Slice <N>. Keep it context-window efficient. Include only the files Codex must read, the TDD requirements, implementation scope, validation commands, documentation updates, and commit message. Do not implement the slice yourself.
```

## Validate Codex result

```text
Codex implemented Slice <N>. I will paste the summary / diff / terminal output. Validate whether it followed the slice, architecture rules, TDD expectations, docs update requirements, and whether the commit message is suitable. Tell me exactly what to fix before moving on.
```

## Generate a repair prompt

```text
Codex attempted Slice <N> but something is wrong. Based on the docs and the following error/diff/output, generate a minimal English Codex repair prompt. It should read only the necessary files and fix only the broken scope.
```

## Ask whether to release/tag

```text
Based on the completed Gym-App slices and current changelog/slice status, tell me whether this is a good point for a Git tag or release. If yes, generate the exact Codex prompt for version/changelog/tag work. If not, explain what is missing.
```

## Ask for next slice strategy

```text
Given the Gym-App roadmap and completed slice status, what should the next slice be and why? Keep the answer pragmatic and aligned with production readiness.
```

## v5 meta-prompt reminder

When generating Codex prompts for any UI slice, include localization requirements. When generating prompts for catalog, onboarding, profile, or recommendation slices, include equipment inventory and max-load constraints. When generating payment prompts, enforce freemium boundaries and do not paywall core tracking/export.
