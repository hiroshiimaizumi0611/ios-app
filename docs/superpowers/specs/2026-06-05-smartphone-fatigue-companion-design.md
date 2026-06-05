# Smartphone Fatigue Companion Design

## Product Direction

This app is a Japanese-first, Finch-inspired self-care companion for people who feel drained by smartphone use. It is not an app blocker, productivity coach, or medical mental health tool. Its core promise is:

> A gentle companion you open when your phone has made you tired.

The app helps users notice when they feel depleted, name the kind of fatigue they are carrying, and take a tiny recovery action. Completing these actions slowly changes a small in-app recovery room and companion.

## Target User

The first audience is B2C iPhone users in Japan who feel generally worn down by smartphone use. Their fatigue may come from unconscious scrolling, social comparison, information overload, or discomfort with empty time. The product should not require the user to identify one fixed cause.

The app should feel useful for people who think:

- "I opened my phone because I was tired, and now I feel worse."
- "I do not want another strict habit tracker."
- "I want something gentle that helps me come back to myself."

## Positioning

The product is closer to Finch than Opal.

Finch-like aspects:

- Lightweight self-checks.
- Tiny self-care actions.
- A companion that changes through care.
- A non-punitive tone.
- Emotional comfort as the main value.

Opal-like or screen-time-control aspects are intentionally deferred. The MVP should not include app blocking, forced friction before opening apps, or Screen Time API integration. Those may become paid features later if the initial self-care loop resonates.

## Differentiation

Finch is broad self-care and habit support. This app is narrower and more culturally localized:

- Japanese language and emotional nuance first.
- Focus on smartphone fatigue, comparison fatigue, information fatigue, and vague depletion.
- Calm, adult-friendly cuteness rather than childish gamification.
- Recovery over productivity.
- No diagnosis, medical claims, or therapy replacement framing.

## MVP Scope

### Included

- Today fatigue check.
- Fatigue category selection:
  - Vague depletion.
  - Comparison fatigue.
  - Information fatigue.
  - Unconscious scrolling.
  - I do not want to do anything.
- Optional short memo.
- Gentle companion response.
- Thirty-second to one-minute recovery actions.
- Small visual changes in the companion room after recovery.
- Seven-day reflection view.
- Local-first data storage.
- No account required.

### Not Included

- SNS blocking.
- App limits.
- Friend or social features.
- Diagnosis, clinical mental health advice, or treatment claims.
- External content feeds.
- Server backend.
- Heavy habit management.

## Core Experience

1. The user opens the app after feeling drained.
2. The home screen shows a small companion and recovery room.
3. The user taps "check today's fatigue."
4. The user selects the closest fatigue category and may add a short memo.
5. The companion responds with a short, non-judgmental message.
6. The app offers one tiny recovery action.
7. After completing the action, the room changes slightly: a light turns on, a plant grows, or the companion becomes calmer.
8. The app closes the loop with a gentle "this is enough for today" tone.

## Main Screens

### Home

Shows the companion, recovery room, today's state, and the primary action. The home screen should be calm and sparse. It should not feel like a dashboard of obligations.

Primary actions:

- Check fatigue.
- Do a tiny recovery action.
- View recent reflection.

### Fatigue Check

Lets the user choose the fatigue that best matches the moment. The UI should be one-tap first, with optional memo entry. The memo should never feel required.

Fatigue types:

- Vague depletion.
- Comparison fatigue.
- Information fatigue.
- Unconscious scrolling.
- I do not want to do anything.

### Recovery Action

Offers a short action that can be completed in thirty seconds to one minute.

Initial examples:

- Breathe slowly three times.
- Close your eyes for thirty seconds.
- Look away from the screen.
- Roll your shoulders.
- Drink water.
- Say one kind sentence to yourself.

### Recovery Complete

Shows the companion response and a small room change. This should be emotionally satisfying without becoming noisy or manipulative.

### Reflection

Shows a seven-day summary:

- Which fatigue types appeared often.
- Which recovery actions were completed.
- A short, non-judgmental companion summary.

The reflection should avoid streak pressure. Missing days are treated neutrally.

## Visual Direction

The approved visual direction is "soft companion room." The interface should feel like a small, quiet recovery room rather than a productivity app. The companion and room are the emotional anchor.

Approved design comps:

- `docs/design/comps/soft-companion-room-home-v1.png`
- `docs/design/comps/soft-companion-room-fatigue-check-v1.png`
- `docs/design/comps/soft-companion-room-recovery-action-v1.png`
- `docs/design/comps/soft-companion-room-reflection-v1.png`

Visual principles:

- Warm off-white, pale sage, muted peach, soft butter yellow, and gentle brown accents.
- Soft cards and generous whitespace.
- A cozy room illustration with lamp, plant, cushion, table, and round window motifs.
- A simple plush-like companion that is original, calm, and non-judgmental.
- Japanese text rendered by native UI, not embedded in generated mockup images.
- Avoid hard dashboards, heavy analytics, red alert states, streak pressure, medical aesthetics, or childish clutter.

## Companion And World

The app contains a small recovery room. The companion is not a coach. It is a quiet presence that sits beside the user.

Tone guidelines:

- Gentle.
- Non-punitive.
- Quietly warm.
- Not preachy.
- Not medicalized.
- Cute, but not too childish.
- Japanese copy should leave emotional space.

The room can change through:

- Light.
- Plants.
- Small objects.
- Seasonal details.
- Companion posture or expression.

## Teaser Landing Page

Before the app MVP, build a lightweight teaser LP to validate the world and collect release notifications.

Approved LP direction:

- Use the app name `やすみどき`.
- Lead with the companion and room, not a feature checklist.
- Hero copy: "スマホで疲れた日に開く、回復の相棒。"
- Supporting copy should explain the gentle loop: choose fatigue, take a thirty-second breath, and let the room slowly light up.
- CTA: release notification signup.
- The LP should feel like a warm invitation, not a clinical or productivity landing page.

Approved LP structure:

1. Hero with the home screen comp, app name, core promise, and release notification CTA.
2. Three-step section:
   - つかれを選ぶ.
   - 30秒だけひと息.
   - 部屋が少し灯る.
3. Screenshot/story section using fatigue check, recovery action, and reflection comps.
4. Final release notification CTA.

Approved motion direction:

- Soft, slow, and optional-feeling motion.
- The hero screenshot should float subtly, as if the room is breathing.
- Background light should drift very slowly.
- Small leaves or decorative details may drift gently.
- CTA can breathe subtly, but should not pulse like an urgent marketing button.
- Respect reduced-motion preferences.
- Avoid fast parallax, scroll-jacking, loud effects, confetti, or gamified reward bursts.

## Monetization

The app targets B2C subscription or low-cost premium revenue.

Monetization is post-MVP. The first implementation plan should build the free core loop and leave subscriptions, paywalls, and paid content delivery out of scope.

Free tier:

- One daily fatigue check.
- Basic companion.
- Basic recovery actions.
- Seven-day reflection.

Paid tier:

- More companion appearances.
- Room themes.
- Additional recovery actions.
- Monthly reflection.
- Personalized wording and care tendencies.
- Seasonal events.

The paid tier should feel like deeper comfort and personalization, not withholding essential care.

## Data Model

Local-first storage is enough for MVP.

Entities:

- FatigueCheck:
  - id.
  - createdAt.
  - fatigueType.
  - optionalMemo.
- RecoveryAction:
  - id.
  - title.
  - durationSeconds.
  - category.
  - prompt.
- RecoveryCompletion:
  - id.
  - actionId.
  - completedAt.
  - linkedFatigueCheckId.
- CompanionState:
  - growthLevel.
  - roomTheme.
  - unlockedItems.
  - lastInteractionAt.

## Technical Direction

The first app should be native iOS with SwiftUI.

Initial implementation choices:

- SwiftUI for UI.
- Local persistence with SwiftData or lightweight local storage.
- No login.
- No backend.
- No push notifications in the MVP unless explicitly chosen later.
- No Screen Time integration in the MVP.

This keeps the app maintainable for a solo developer and reduces launch risk.

## Risks

- It may feel too similar to existing self-care apps unless smartphone fatigue is clearly expressed.
- It may become too soft to retain users if the room progression is not satisfying.
- If the app overuses streaks or pressure, it will contradict the product promise.
- Medical or therapy-like claims could create trust and review risks.

## Success Criteria For MVP

The MVP is successful if early users:

- Understand within one minute that the app is for smartphone fatigue recovery.
- Complete a fatigue check without needing instructions.
- Complete at least one recovery action.
- Describe the companion tone as gentle rather than pushy.
- Return on at least three separate days in the first week.

## Research Notes

Initial research found overseas traction around:

- Finch as a self-care pet app with very high App Store ratings and broad adoption.
- Opal and Dumb Phone as screen-time and digital-minimalism tools.
- Partiful, Beli, Yuka, and Pickle as examples of overseas consumer app trends with varying fit for Japan.

For this project, the Finch-like self-care direction was selected because it is more realistic for solo B2C development than marketplace, database-heavy, or network-effect-heavy app ideas.
