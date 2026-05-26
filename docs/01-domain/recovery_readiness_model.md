# Recovery and Readiness Model

## Purpose

Reduce poor recommendations when the user is sore, fatigued, or performing below baseline.

## Inputs

### User input

- General soreness.
- Optional region soreness.
- Session perceived exertion.
- Energy/motivation optional later.
- Pain warning optional later.

### Derived signals

- Time since last direct muscle stimulus.
- Recent rolling volume.
- Performance drop versus recent baseline.
- Frequency of hard sessions.
- Missed deload intervals.

## Readiness levels

- High: normal progression allowed.
- Medium: maintain or small progression.
- Low: reduce volume/intensity or choose alternatives.
- Very low: suggest rest, mobility, or different muscle group.

## DOMS handling

DOMS is not treated as proof of growth or injury. It is a signal that can influence direct muscle recommendations.

## Strength-down logic

If a user is weaker than expected:

- Check if soreness/readiness is low.
- If low: reduce or stop direct work.
- If acceptable: suggest lower-load backoff volume or extra set to preserve useful volume.
- Avoid forcing heavier load.

## Deload logic

Suggest deload when several signals align:

- 4–6 weeks of progressive volume/intensity without reduced week.
- Repeated strength drops.
- High soreness reports.
- High perceived exertion.
- Poor readiness across several sessions.

## UI wording

Use non-medical language:

- `Your readiness looks low for heavy chest work today.`
- `Consider reducing load or choosing a lighter variation.`
- `This is an estimate based on your logs and feedback.`
