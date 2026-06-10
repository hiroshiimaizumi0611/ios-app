# Companion Memory Reactions Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add the first "the companion noticed me" loop: remember the latest fatigue check and recovery completion, then reflect that memory through short home and completion messages.

**Architecture:** Keep the MVP local-first and testable. Extend `CompanionState` with optional Codable memory/reaction fields so existing saved JSON keeps decoding, update both stores in one shared pattern, and add a small presenter in `YasumidokiCore` that turns companion state into UI copy. SwiftUI screens should consume those values without owning domain decisions.

**Tech Stack:** Swift, Swift Testing, Foundation Codable persistence, SwiftUI, Observation, XcodeBuildMCP Simulator verification.

---

## File Structure

- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/CompanionMemory.swift`
  - Stores the latest fatigue check and optional latest completed recovery action.
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/CompanionReaction.swift`
  - Stores the latest gentle reaction message and display mood.
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/CompanionMessageBuilder.swift`
  - Converts `CompanionState` into home and completion copy.
- Modify: `Core/YasumidokiCore/Sources/YasumidokiCore/CompanionState.swift`
  - Add optional `memory` and `reaction` fields.
- Create: `Core/YasumidokiCore/Tests/YasumidokiCoreTests/CompanionStateTests.swift`
  - Assert defaults and Codable compatibility for the new state fields.
- Modify: `Core/YasumidokiCore/Sources/YasumidokiCore/InMemoryYasumidokiStore.swift`
  - Record memory/reaction after fatigue checks and completions.
- Modify: `Core/YasumidokiCore/Sources/YasumidokiCore/FileBackedYasumidokiStore.swift`
  - Mirror the same state updates and persist them.
- Modify: `Core/YasumidokiCore/Tests/YasumidokiCoreTests/YasumidokiStoreTests.swift`
  - Assert memory/reaction behavior for check and completion.
- Modify: `Core/YasumidokiCore/Tests/YasumidokiCoreTests/FileBackedYasumidokiStoreTests.swift`
  - Assert persistence and backward-compatible JSON decoding.
- Create: `Core/YasumidokiCore/Tests/YasumidokiCoreTests/CompanionMessageBuilderTests.swift`
  - Assert copy stays gentle and state-aware.
- Modify: `Yasumidoki/Yasumidoki/Features/Home/HomeRoomHeroView.swift`
  - Show state-aware companion message.
- Modify: `Yasumidoki/Yasumidoki/Features/Home/HomeView.swift`
  - Make the primary action subtitle memory-aware.
- Modify: `Yasumidoki/Yasumidoki/Features/Recovery/RecoveryCompleteView.swift`
  - Show completion reaction text from state.
- Modify: `docs/TODO.md`
  - Track plan completion and remaining implementation polish.

## Task 1: Companion Memory Models

**Files:**
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/CompanionMemory.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/CompanionReaction.swift`
- Modify: `Core/YasumidokiCore/Sources/YasumidokiCore/CompanionState.swift`
- Create: `Core/YasumidokiCore/Tests/YasumidokiCoreTests/CompanionStateTests.swift`

- [ ] **Step 1: Write the failing model test**

Create `CompanionStateTests.swift`:

```swift
import Foundation
import Testing
@testable import YasumidokiCore

@Suite("Companion state")
struct CompanionStateTests {
    @Test("state can carry optional memory and reaction")
    func carriesMemoryAndReaction() {
        let state = CompanionState(
            memory: CompanionMemory(
                latestFatigueType: .informationFatigue,
                latestMemoPreview: "ニュースを見すぎた",
                latestCheckAt: Date(timeIntervalSince1970: 1_000)
            ),
            reaction: CompanionReaction(
                kind: .noticedFatigue,
                message: "情報疲れ、ちゃんと受け取りました。",
                createdAt: Date(timeIntervalSince1970: 1_000)
            )
        )

        #expect(state.memory?.latestFatigueType == .informationFatigue)
        #expect(state.memory?.latestMemoPreview == "ニュースを見すぎた")
        #expect(state.reaction?.kind == .noticedFatigue)
    }
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `swift test --package-path Core/YasumidokiCore --filter CompanionStateTests`

Expected: FAIL because `memory` and `reaction` do not exist yet.

- [ ] **Step 3: Add Codable model types**

Create `CompanionMemory.swift`:

```swift
import Foundation

public struct CompanionMemory: Codable, Equatable, Sendable {
    public var latestFatigueType: FatigueType?
    public var latestMemoPreview: String?
    public var latestCheckAt: Date?
    public var latestCompletedActionTitle: String?
    public var latestCompletionAt: Date?

    public init(
        latestFatigueType: FatigueType? = nil,
        latestMemoPreview: String? = nil,
        latestCheckAt: Date? = nil,
        latestCompletedActionTitle: String? = nil,
        latestCompletionAt: Date? = nil
    ) {
        self.latestFatigueType = latestFatigueType
        self.latestMemoPreview = latestMemoPreview
        self.latestCheckAt = latestCheckAt
        self.latestCompletedActionTitle = latestCompletedActionTitle
        self.latestCompletionAt = latestCompletionAt
    }
}
```

Create `CompanionReaction.swift`:

```swift
import Foundation

public struct CompanionReaction: Codable, Equatable, Sendable {
    public enum Kind: String, Codable, Equatable, Sendable {
        case welcome
        case noticedFatigue
        case completedRecovery
    }

    public var kind: Kind
    public var message: String
    public var mood: String
    public var createdAt: Date

    public init(kind: Kind, message: String, mood: String = "soft", createdAt: Date) {
        self.kind = kind
        self.message = message
        self.mood = mood
        self.createdAt = createdAt
    }
}
```

Modify `CompanionState.swift`:

```swift
public var memory: CompanionMemory?
public var reaction: CompanionReaction?
```

Update the initializer by appending optional defaults:

```swift
public init(
    growthLevel: Int = 0,
    roomTheme: String = "soft-room",
    unlockedItems: [String] = [],
    lastInteractionAt: Date? = nil,
    memory: CompanionMemory? = nil,
    reaction: CompanionReaction? = nil
) {
    self.growthLevel = growthLevel
    self.roomTheme = roomTheme
    self.unlockedItems = unlockedItems
    self.lastInteractionAt = lastInteractionAt
    self.memory = memory
    self.reaction = reaction
}
```

Keep both fields optional so older app data can decode without migration code.

- [ ] **Step 4: Run the targeted test**

Run: `swift test --package-path Core/YasumidokiCore --filter CompanionStateTests`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add Core/YasumidokiCore/Sources/YasumidokiCore/CompanionMemory.swift \
  Core/YasumidokiCore/Sources/YasumidokiCore/CompanionReaction.swift \
  Core/YasumidokiCore/Sources/YasumidokiCore/CompanionState.swift \
  Core/YasumidokiCore/Tests/YasumidokiCoreTests/CompanionStateTests.swift
git commit -m "Add companion memory models"
```

## Task 2: Store Memory And Reactions

**Files:**
- Modify: `Core/YasumidokiCore/Sources/YasumidokiCore/InMemoryYasumidokiStore.swift`
- Modify: `Core/YasumidokiCore/Sources/YasumidokiCore/FileBackedYasumidokiStore.swift`
- Modify: `Core/YasumidokiCore/Tests/YasumidokiCoreTests/YasumidokiStoreTests.swift`
- Modify: `Core/YasumidokiCore/Tests/YasumidokiCoreTests/FileBackedYasumidokiStoreTests.swift`

- [ ] **Step 1: Extend store tests for completion memory**

In the existing store test, take a snapshot immediately after `recordFatigueCheck(...)` and before recording completion:

```swift
let snapshotAfterCheck = await store.snapshot()
#expect(snapshotAfterCheck.companionState.memory?.latestFatigueType == .informationFatigue)
#expect(snapshotAfterCheck.companionState.memory?.latestMemoPreview == "ニュースを見すぎた")
#expect(snapshotAfterCheck.companionState.reaction?.kind == .noticedFatigue)
```

Then add expectations after recording completion:

```swift
#expect(snapshot.companionState.memory?.latestCompletedActionTitle == action.title)
#expect(snapshot.companionState.memory?.latestCompletionAt == Date(timeIntervalSince1970: 1_100))
#expect(snapshot.companionState.reaction?.kind == .completedRecovery)
#expect(snapshot.companionState.reaction?.message.contains("覚え") == true)
```

- [ ] **Step 2: Run to verify failure**

Run: `swift test --package-path Core/YasumidokiCore --filter YasumidokiStoreTests`

Expected: FAIL because stores have not populated memory/reaction.

- [ ] **Step 3: Implement fatigue check state update**

In both stores, after `currentSnapshot.checks.append(check)`:

```swift
currentSnapshot.companionState.memory = CompanionMemory(
    latestFatigueType: fatigueType,
    latestMemoPreview: check.optionalMemo,
    latestCheckAt: createdAt,
    latestCompletedActionTitle: currentSnapshot.companionState.memory?.latestCompletedActionTitle,
    latestCompletionAt: currentSnapshot.companionState.memory?.latestCompletionAt
)
currentSnapshot.companionState.reaction = CompanionReaction(
    kind: .noticedFatigue,
    message: "\(fatigueType.displayName)、ちゃんと受け取りました。",
    mood: "noticed",
    createdAt: createdAt
)
currentSnapshot.companionState.lastInteractionAt = createdAt
```

- [ ] **Step 4: Implement completion state update**

In both stores, after appending completion:

```swift
currentSnapshot.companionState.memory = CompanionMemory(
    latestFatigueType: currentSnapshot.companionState.memory?.latestFatigueType,
    latestMemoPreview: currentSnapshot.companionState.memory?.latestMemoPreview,
    latestCheckAt: currentSnapshot.companionState.memory?.latestCheckAt,
    latestCompletedActionTitle: action.title,
    latestCompletionAt: completedAt
)
currentSnapshot.companionState.reaction = CompanionReaction(
    kind: .completedRecovery,
    message: "\(action.title)できたこと、相棒が覚えました。",
    mood: "warm",
    createdAt: completedAt
)
```

- [ ] **Step 5: Add file-backed persistence test**

In `FileBackedYasumidokiStoreTests`, record a check/completion, create a new store for the same file, and assert memory/reaction persisted.

- [ ] **Step 6: Add older JSON compatibility test**

Write JSON without `memory` or `reaction`, decode through `FileBackedYasumidokiStore`, and assert:

```swift
#expect(snapshot.companionState.memory == nil)
#expect(snapshot.companionState.reaction == nil)
```

- [ ] **Step 7: Run tests**

Run: `swift test --package-path Core/YasumidokiCore`

Expected: PASS, 0 failures.

- [ ] **Step 8: Commit**

```bash
git add Core/YasumidokiCore/Sources/YasumidokiCore/InMemoryYasumidokiStore.swift \
  Core/YasumidokiCore/Sources/YasumidokiCore/FileBackedYasumidokiStore.swift \
  Core/YasumidokiCore/Tests/YasumidokiCoreTests/YasumidokiStoreTests.swift \
  Core/YasumidokiCore/Tests/YasumidokiCoreTests/FileBackedYasumidokiStoreTests.swift
git commit -m "Remember companion interactions"
```

## Task 3: Companion Message Builder

**Files:**
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/CompanionMessageBuilder.swift`
- Create: `Core/YasumidokiCore/Tests/YasumidokiCoreTests/CompanionMessageBuilderTests.swift`

- [ ] **Step 1: Write builder tests**

Cover these cases:

```swift
@Test("home message welcomes first-time users gently")
func firstHomeMessage() {
    let builder = CompanionMessageBuilder()
    #expect(builder.homeGreeting(for: CompanionState()) == "おかえりなさい")
}

@Test("home message remembers latest fatigue")
func fatigueHomeMessage() {
    let state = CompanionState(
        memory: CompanionMemory(latestFatigueType: .informationFatigue)
    )
    let builder = CompanionMessageBuilder()
    #expect(builder.homeGreeting(for: state).contains("情報疲れ"))
}

@Test("completion message uses latest reaction without streak pressure")
func completionMessage() {
    let state = CompanionState(
        reaction: CompanionReaction(
            kind: .completedRecovery,
            message: "目を閉じて休めたこと、覚えました。",
            createdAt: Date(timeIntervalSince1970: 1_000)
        )
    )
    let builder = CompanionMessageBuilder()
    #expect(builder.completionMessage(for: state).contains("覚え"))
    #expect(builder.completionMessage(for: state).contains("連続") == false)
}
```

- [ ] **Step 2: Run to verify failure**

Run: `swift test --package-path Core/YasumidokiCore --filter CompanionMessageBuilderTests`

Expected: FAIL because the builder does not exist.

- [ ] **Step 3: Implement builder**

```swift
public struct CompanionMessageBuilder: Sendable {
    public init() {}

    public func homeGreeting(for state: CompanionState) -> String {
        if let reaction = state.reaction, reaction.kind == .completedRecovery {
            return reaction.message
        }

        if let fatigue = state.memory?.latestFatigueType {
            return "\(fatigue.displayName)、そっと覚えています"
        }

        return state.growthLevel > 0 ? "相棒がそばで休んでいます" : "おかえりなさい"
    }

    public func homeActionSubtitle(for state: CompanionState) -> String {
        if let fatigue = state.memory?.latestFatigueType {
            return "前回は\(fatigue.displayName)。今日はどうでしょう"
        }

        return state.growthLevel > 0 ? "相棒と一緒に、いまの感じをひとつだけ" : "ひとつ選ぶだけでOK"
    }

    public func completionMessage(for state: CompanionState) -> String {
        state.reaction?.message ?? "ひと息つけたことを、相棒が覚えてくれました。"
    }
}
```

- [ ] **Step 4: Run tests**

Run: `swift test --package-path Core/YasumidokiCore`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add Core/YasumidokiCore/Sources/YasumidokiCore/CompanionMessageBuilder.swift \
  Core/YasumidokiCore/Tests/YasumidokiCoreTests/CompanionMessageBuilderTests.swift
git commit -m "Add companion message builder"
```

## Task 4: SwiftUI Integration

**Files:**
- Modify: `Yasumidoki/Yasumidoki/Features/Home/HomeRoomHeroView.swift`
- Modify: `Yasumidoki/Yasumidoki/Features/Home/HomeView.swift`
- Modify: `Yasumidoki/Yasumidoki/Features/Recovery/RecoveryCompleteView.swift`

- [ ] **Step 1: Add builder to home hero**

In `HomeRoomHeroView`, add:

```swift
private let messageBuilder = CompanionMessageBuilder()
```

Change `greeting` to:

```swift
private var greeting: String {
    messageBuilder.homeGreeting(for: companionState)
}
```

- [ ] **Step 2: Add builder to home primary action subtitle**

In `HomeView`, add:

```swift
private let messageBuilder = CompanionMessageBuilder()
```

Change the first `SoftActionCard` subtitle to:

```swift
subtitle: messageBuilder.homeActionSubtitle(for: companionState)
```

- [ ] **Step 3: Add builder to completion body**

In `RecoveryCompleteView`, add:

```swift
private let messageBuilder = CompanionMessageBuilder()
```

Change the body text to:

```swift
Text(messageBuilder.completionMessage(for: companionState))
```

- [ ] **Step 4: Build the iOS app**

Run:

```bash
xcodebuild -project Yasumidoki/Yasumidoki.xcodeproj \
  -scheme Yasumidoki \
  -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath /tmp/yasumidoki-companion-memory-derived \
  build
```

Expected: `BUILD SUCCEEDED`.

- [ ] **Step 5: Commit**

```bash
git add Yasumidoki/Yasumidoki/Features/Home/HomeRoomHeroView.swift \
  Yasumidoki/Yasumidoki/Features/Home/HomeView.swift \
  Yasumidoki/Yasumidoki/Features/Recovery/RecoveryCompleteView.swift
git commit -m "Show companion memory in SwiftUI"
```

## Task 5: Simulator Verification And TODO

**Files:**
- Modify: `docs/TODO.md`

- [ ] **Step 1: Run full checks**

Run:

```bash
swift test --package-path Core/YasumidokiCore
xcodebuild -project Yasumidoki/Yasumidoki.xcodeproj \
  -scheme Yasumidoki \
  -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath /tmp/yasumidoki-companion-memory-derived \
  build
```

Expected: tests pass and `BUILD SUCCEEDED`.

- [ ] **Step 2: Verify in Simulator**

Use XcodeBuildMCP:

1. Launch the app on iPhone Simulator.
2. Record `情報疲れ`.
3. Complete the suggested recovery action.
4. Return home.

Expected:

- Home greeting references the remembered state.
- Completion screen says the companion remembered the recovery.
- No message implies streak pressure, shame, or obligation.
- Text does not overlap on iPhone-width simulator.

- [ ] **Step 3: Update TODO**

Mark `Add companion memory and reactions` complete only after Simulator verification. Add any visual polish left under `Later`.

- [ ] **Step 4: Final commit**

```bash
git add docs/TODO.md
git commit -m "Update companion memory TODO"
```

## Final Verification

Before opening a PR:

```bash
swift test --package-path Core/YasumidokiCore
xcodebuild -project Yasumidoki/Yasumidoki.xcodeproj \
  -scheme Yasumidoki \
  -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath /tmp/yasumidoki-companion-memory-derived \
  build
git diff --check
```

Expected:

- Swift tests pass.
- Xcode build succeeds.
- `git diff --check` prints no whitespace errors.
