# Yasumidoki iOS MVP Vertical Slice Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the first native SwiftUI vertical slice for `やすみどき`: home room, fatigue check, tiny recovery action, completion, and seven-day reflection.

**Architecture:** Split the app into a testable Swift package (`Core/YasumidokiCore`) and a native SwiftUI app (`Yasumidoki/`). The core package owns domain models, recovery selection, local persistence, companion growth, and reflection summaries; the app layer owns navigation, visual composition, accessibility, and interaction. The first MVP uses lightweight Codable JSON storage rather than a backend or account system.

**Tech Stack:** Swift, Swift Testing, Foundation Codable persistence, SwiftUI, NavigationStack, local Swift Package dependency, Xcode iOS app project.

---

## Context And Constraints

- Product spec: `docs/superpowers/specs/2026-06-05-smartphone-fatigue-companion-design.md`
- Approved visual comps:
  - `docs/design/comps/soft-companion-room-home-v1.png`
  - `docs/design/comps/soft-companion-room-fatigue-check-v1.png`
  - `docs/design/comps/soft-companion-room-recovery-action-v1.png`
  - `docs/design/comps/soft-companion-room-reflection-v1.png`
- Current repository has no `.xcodeproj`.
- Current machine has Swift CLI, but `xcodebuild` is unavailable until Xcode.app is installed and selected.
- The core package uses `swift-tools-version: 6.1` so it can be tested with the current CLI. The app target should use the latest installed Xcode; use iOS 26 as the default deployment target when Xcode 26 is available. If only an older Xcode is installed, stop and ask before lowering the app target.
- Use these skills during execution:
  - `@ios-hig-design` for native iOS layout, safe areas, accessibility, Dynamic Type, and Reduce Motion.
  - `@swiftui-pro` when writing or reviewing SwiftUI files.
  - `@swift-testing-pro` when writing Swift Testing tests.
  - `@xcode-project-setup` if linking the local Swift package requires Xcode project setup help.

## File Structure

### Core Package

- Create: `Core/YasumidokiCore/Package.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/PackageMarker.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/FatigueType.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/FatigueCheck.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/RecoveryAction.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/RecoveryCatalog.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/RecoveryCompletion.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/CompanionState.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/YasumidokiSnapshot.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/YasumidokiStore.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/InMemoryYasumidokiStore.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/FileBackedYasumidokiStore.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/ReflectionSummary.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/ReflectionBuilder.swift`
- Create: `Core/YasumidokiCore/Tests/YasumidokiCoreTests/RecoveryCatalogTests.swift`
- Create: `Core/YasumidokiCore/Tests/YasumidokiCoreTests/YasumidokiStoreTests.swift`
- Create: `Core/YasumidokiCore/Tests/YasumidokiCoreTests/FileBackedYasumidokiStoreTests.swift`
- Create: `Core/YasumidokiCore/Tests/YasumidokiCoreTests/ReflectionBuilderTests.swift`

### SwiftUI App

Create the Xcode project manually after Xcode is installed:

- Create: `Yasumidoki/Yasumidoki.xcodeproj`
- Create: `Yasumidoki/Yasumidoki/YasumidokiApp.swift`
- Create: `Yasumidoki/Yasumidoki/App/AppModel.swift`
- Create: `Yasumidoki/Yasumidoki/App/AppRoute.swift`
- Create: `Yasumidoki/Yasumidoki/App/AppRootView.swift`
- Create: `Yasumidoki/Yasumidoki/App/YasumidokiStoreFactory.swift`
- Create: `Yasumidoki/Yasumidoki/Design/YasumidokiTheme.swift`
- Create: `Yasumidoki/Yasumidoki/Components/PrimaryButton.swift`
- Create: `Yasumidoki/Yasumidoki/Components/CompanionRoomView.swift`
- Create: `Yasumidoki/Yasumidoki/Features/Home/HomeView.swift`
- Create: `Yasumidoki/Yasumidoki/Features/FatigueCheck/FatigueCheckView.swift`
- Create: `Yasumidoki/Yasumidoki/Features/Recovery/RecoveryActionView.swift`
- Create: `Yasumidoki/Yasumidoki/Features/Recovery/RecoveryCompleteView.swift`
- Create: `Yasumidoki/Yasumidoki/Features/Reflection/ReflectionView.swift`
- Modify: `README.md`

## Scope

### Included

- Native SwiftUI app shell.
- Home screen with companion room.
- Fatigue check for five fatigue types.
- One suggested tiny recovery action.
- Completion screen that updates companion state.
- Seven-day reflection summary.
- Local-first JSON persistence.
- Unit tests for core logic.
- Build/test commands for the app once Xcode is available.

### Not Included

- App blocking or Screen Time APIs.
- Login, backend, push notifications, subscriptions, analytics.
- Generated image assets inside the app target. Use simple SwiftUI shapes for the first build; keep approved comps as design references.
- Medical or therapy-like claims.

## Task 0: Environment Gate

**Files:**
- No file changes.

- [ ] **Step 1: Confirm Swift CLI works**

Run:

```bash
swift --version
```

Expected: Swift 6.x output.

- [ ] **Step 2: Confirm Xcode status**

Run:

```bash
xcodebuild -version
```

Expected if Xcode is not installed or not selected:

```text
xcode-select: error: tool 'xcodebuild' requires Xcode
```

- [ ] **Step 3: If Xcode is missing, stop before app-target tasks**

Install Xcode from the App Store or Apple Developer. Then select it:

```bash
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
xcodebuild -version
```

Expected: Xcode version output.

- [ ] **Step 4: List available iPhone simulators**

Run:

```bash
xcrun simctl list devices available | rg "iPhone"
```

Expected: at least one available iPhone simulator.

## Task 1: Core Package Skeleton And Recovery Catalog

**Files:**
- Create: `Core/YasumidokiCore/Package.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/PackageMarker.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/FatigueType.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/RecoveryAction.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/RecoveryCatalog.swift`
- Test: `Core/YasumidokiCore/Tests/YasumidokiCoreTests/RecoveryCatalogTests.swift`

- [ ] **Step 1: Create Swift package skeleton**

Create `Core/YasumidokiCore/Package.swift`:

```swift
// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "YasumidokiCore",
    platforms: [
        .iOS(.v18),
        .macOS(.v15)
    ],
    products: [
        .library(name: "YasumidokiCore", targets: ["YasumidokiCore"])
    ],
    targets: [
        .target(name: "YasumidokiCore"),
        .testTarget(name: "YasumidokiCoreTests", dependencies: ["YasumidokiCore"])
    ]
)
```

Create `Core/YasumidokiCore/Sources/YasumidokiCore/PackageMarker.swift` so the target is not empty before the first failing test:

```swift
public enum YasumidokiCorePackageMarker {}
```

- [ ] **Step 2: Write failing recovery catalog tests**

Create `Core/YasumidokiCore/Tests/YasumidokiCoreTests/RecoveryCatalogTests.swift`:

```swift
import Testing
@testable import YasumidokiCore

@Suite("Recovery catalog")
struct RecoveryCatalogTests {
    @Test("fatigue types expose Japanese labels")
    func fatigueTypeLabels() {
        #expect(FatigueType.vagueDepletion.displayName == "なんとなく消耗")
        #expect(FatigueType.comparisonFatigue.displayName == "比較疲れ")
        #expect(FatigueType.informationFatigue.displayName == "情報疲れ")
        #expect(FatigueType.unconsciousScrolling.displayName == "無意識スクロール")
        #expect(FatigueType.doNotWantAnything.displayName == "何もしたくない")
    }

    @Test("catalog returns a gentle short action for each fatigue type")
    func actionForEachFatigueType() {
        for fatigueType in FatigueType.allCases {
            let action = RecoveryCatalog.default.action(for: fatigueType)

            #expect(action.durationSeconds >= 30)
            #expect(action.durationSeconds <= 60)
            #expect(action.title.isEmpty == false)
            #expect(action.prompt.contains("。"))
        }
    }
}
```

- [ ] **Step 3: Run tests to verify they fail**

Run:

```bash
swift test --package-path Core/YasumidokiCore --filter RecoveryCatalogTests
```

Expected: FAIL because `FatigueType`, `RecoveryCatalog`, and `RecoveryAction` do not exist.

- [ ] **Step 4: Implement minimal catalog**

Create `Core/YasumidokiCore/Sources/YasumidokiCore/FatigueType.swift`:

```swift
public enum FatigueType: String, Codable, CaseIterable, Identifiable, Sendable {
    case vagueDepletion
    case comparisonFatigue
    case informationFatigue
    case unconsciousScrolling
    case doNotWantAnything

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .vagueDepletion: "なんとなく消耗"
        case .comparisonFatigue: "比較疲れ"
        case .informationFatigue: "情報疲れ"
        case .unconsciousScrolling: "無意識スクロール"
        case .doNotWantAnything: "何もしたくない"
        }
    }
}
```

Create `Core/YasumidokiCore/Sources/YasumidokiCore/RecoveryAction.swift`:

```swift
import Foundation

public struct RecoveryAction: Codable, Equatable, Identifiable, Sendable {
    public let id: UUID
    public let title: String
    public let durationSeconds: Int
    public let category: String
    public let prompt: String

    public init(
        id: UUID = UUID(),
        title: String,
        durationSeconds: Int,
        category: String,
        prompt: String
    ) {
        self.id = id
        self.title = title
        self.durationSeconds = durationSeconds
        self.category = category
        self.prompt = prompt
    }
}
```

Create `Core/YasumidokiCore/Sources/YasumidokiCore/RecoveryCatalog.swift`:

```swift
public struct RecoveryCatalog: Sendable {
    public static let `default` = RecoveryCatalog()

    public init() {}

    public func action(for fatigueType: FatigueType) -> RecoveryAction {
        switch fatigueType {
        case .vagueDepletion:
            RecoveryAction(title: "ゆっくり3回、息をする", durationSeconds: 30, category: "breathing", prompt: "画面から少し目を離して、ゆっくり3回だけ息をしましょう。")
        case .comparisonFatigue:
            RecoveryAction(title: "自分に戻るひと言", durationSeconds: 30, category: "self-kindness", prompt: "比べる時間をいったん置いて、自分にやさしい一文を向けましょう。")
        case .informationFatigue:
            RecoveryAction(title: "目を閉じて休む", durationSeconds: 30, category: "eye-rest", prompt: "目を閉じて、入ってきた情報を静かにほどきましょう。")
        case .unconsciousScrolling:
            RecoveryAction(title: "肩をゆるめる", durationSeconds: 30, category: "body", prompt: "スマホを置いて、肩を一度上げてからゆっくり下ろしましょう。")
        case .doNotWantAnything:
            RecoveryAction(title: "水をひと口飲む", durationSeconds: 30, category: "care", prompt: "何かを頑張らなくて大丈夫。水をひと口だけ飲みましょう。")
        }
    }
}
```

- [ ] **Step 5: Run tests to verify they pass**

Run:

```bash
swift test --package-path Core/YasumidokiCore --filter RecoveryCatalogTests
```

Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add Core/YasumidokiCore
git commit -m "Add Yasumidoki core recovery catalog"
```

## Task 2: Fatigue Check, Companion State, And In-Memory Store

**Files:**
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/FatigueCheck.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/RecoveryCompletion.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/CompanionState.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/YasumidokiSnapshot.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/YasumidokiStore.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/InMemoryYasumidokiStore.swift`
- Test: `Core/YasumidokiCore/Tests/YasumidokiCoreTests/YasumidokiStoreTests.swift`

- [ ] **Step 1: Write failing store workflow tests**

Create `Core/YasumidokiCore/Tests/YasumidokiCoreTests/YasumidokiStoreTests.swift`:

```swift
import Foundation
import Testing
@testable import YasumidokiCore

@Suite("Yasumidoki store")
struct YasumidokiStoreTests {
    @Test("recording a check and completion grows companion gently")
    func completionUpdatesState() async throws {
        let store = InMemoryYasumidokiStore(
            snapshot: YasumidokiSnapshot(
                checks: [],
                completions: [],
                companionState: CompanionState(growthLevel: 0)
            )
        )
        let check = try await store.recordFatigueCheck(
            fatigueType: .informationFatigue,
            memo: "ニュースを見すぎた",
            createdAt: Date(timeIntervalSince1970: 1_000)
        )
        let action = RecoveryCatalog.default.action(for: .informationFatigue)
        _ = try await store.recordCompletion(
            action: action,
            linkedFatigueCheckID: check.id,
            completedAt: Date(timeIntervalSince1970: 1_100)
        )

        let snapshot = await store.snapshot()
        #expect(snapshot.checks.count == 1)
        #expect(snapshot.completions.count == 1)
        #expect(snapshot.companionState.growthLevel == 1)
        #expect(snapshot.companionState.lastInteractionAt == Date(timeIntervalSince1970: 1_100))
    }
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run:

```bash
swift test --package-path Core/YasumidokiCore --filter YasumidokiStoreTests
```

Expected: FAIL because store types do not exist.

- [ ] **Step 3: Implement domain records and store protocol**

Create `FatigueCheck.swift`, `RecoveryCompletion.swift`, `CompanionState.swift`, `YasumidokiSnapshot.swift`, and `YasumidokiStore.swift` with Codable, Sendable value types:

```swift
import Foundation

public struct FatigueCheck: Codable, Equatable, Identifiable, Sendable {
    public let id: UUID
    public let createdAt: Date
    public let fatigueType: FatigueType
    public let optionalMemo: String?

    public init(id: UUID = UUID(), createdAt: Date, fatigueType: FatigueType, optionalMemo: String?) {
        self.id = id
        self.createdAt = createdAt
        self.fatigueType = fatigueType
        self.optionalMemo = optionalMemo
    }
}
```

```swift
import Foundation

public struct RecoveryCompletion: Codable, Equatable, Identifiable, Sendable {
    public let id: UUID
    public let actionID: UUID
    public let actionTitle: String
    public let completedAt: Date
    public let linkedFatigueCheckID: UUID?

    public init(
        id: UUID = UUID(),
        actionID: UUID,
        actionTitle: String,
        completedAt: Date,
        linkedFatigueCheckID: UUID?
    ) {
        self.id = id
        self.actionID = actionID
        self.actionTitle = actionTitle
        self.completedAt = completedAt
        self.linkedFatigueCheckID = linkedFatigueCheckID
    }
}
```

```swift
import Foundation

public struct CompanionState: Codable, Equatable, Sendable {
    public var growthLevel: Int
    public var roomTheme: String
    public var unlockedItems: [String]
    public var lastInteractionAt: Date?

    public init(
        growthLevel: Int = 0,
        roomTheme: String = "soft-room",
        unlockedItems: [String] = [],
        lastInteractionAt: Date? = nil
    ) {
        self.growthLevel = growthLevel
        self.roomTheme = roomTheme
        self.unlockedItems = unlockedItems
        self.lastInteractionAt = lastInteractionAt
    }
}
```

```swift
public struct YasumidokiSnapshot: Codable, Equatable, Sendable {
    public var checks: [FatigueCheck]
    public var completions: [RecoveryCompletion]
    public var companionState: CompanionState

    public init(
        checks: [FatigueCheck] = [],
        completions: [RecoveryCompletion] = [],
        companionState: CompanionState = CompanionState()
    ) {
        self.checks = checks
        self.completions = completions
        self.companionState = companionState
    }
}
```

```swift
import Foundation

public protocol YasumidokiStore: Sendable {
    func snapshot() async -> YasumidokiSnapshot
    func recordFatigueCheck(fatigueType: FatigueType, memo: String?, createdAt: Date) async throws -> FatigueCheck
    func recordCompletion(action: RecoveryAction, linkedFatigueCheckID: UUID?, completedAt: Date) async throws -> RecoveryCompletion
}
```

- [ ] **Step 4: Implement in-memory store**

Create `InMemoryYasumidokiStore.swift`:

```swift
import Foundation

public actor InMemoryYasumidokiStore: YasumidokiStore {
    private var currentSnapshot: YasumidokiSnapshot

    public init(snapshot: YasumidokiSnapshot = YasumidokiSnapshot()) {
        self.currentSnapshot = snapshot
    }

    public func snapshot() async -> YasumidokiSnapshot {
        currentSnapshot
    }

    public func recordFatigueCheck(
        fatigueType: FatigueType,
        memo: String?,
        createdAt: Date = Date()
    ) async throws -> FatigueCheck {
        let trimmedMemo = memo?.trimmingCharacters(in: .whitespacesAndNewlines)
        let check = FatigueCheck(
            createdAt: createdAt,
            fatigueType: fatigueType,
            optionalMemo: trimmedMemo?.isEmpty == true ? nil : trimmedMemo
        )
        currentSnapshot.checks.append(check)
        return check
    }

    public func recordCompletion(
        action: RecoveryAction,
        linkedFatigueCheckID: UUID?,
        completedAt: Date = Date()
    ) async throws -> RecoveryCompletion {
        let completion = RecoveryCompletion(
            actionID: action.id,
            actionTitle: action.title,
            completedAt: completedAt,
            linkedFatigueCheckID: linkedFatigueCheckID
        )
        currentSnapshot.completions.append(completion)
        currentSnapshot.companionState.growthLevel += 1
        currentSnapshot.companionState.lastInteractionAt = completedAt
        if currentSnapshot.companionState.growthLevel == 1 {
            currentSnapshot.companionState.unlockedItems.append("lamp")
        }
        return completion
    }
}
```

- [ ] **Step 5: Run tests**

Run:

```bash
swift test --package-path Core/YasumidokiCore --filter YasumidokiStoreTests
```

Expected: PASS.

- [ ] **Step 6: Run all core tests**

Run:

```bash
swift test --package-path Core/YasumidokiCore
```

Expected: PASS.

- [ ] **Step 7: Commit**

```bash
git add Core/YasumidokiCore
git commit -m "Add Yasumidoki core store workflow"
```

## Task 3: File Persistence And Seven-Day Reflection

**Files:**
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/FileBackedYasumidokiStore.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/ReflectionSummary.swift`
- Create: `Core/YasumidokiCore/Sources/YasumidokiCore/ReflectionBuilder.swift`
- Test: `Core/YasumidokiCore/Tests/YasumidokiCoreTests/FileBackedYasumidokiStoreTests.swift`
- Test: `Core/YasumidokiCore/Tests/YasumidokiCoreTests/ReflectionBuilderTests.swift`

- [ ] **Step 1: Write failing persistence tests**

Create `FileBackedYasumidokiStoreTests.swift`:

```swift
import Foundation
import Testing
@testable import YasumidokiCore

@Suite("File-backed store")
struct FileBackedYasumidokiStoreTests {
    @Test("persists snapshot across store instances")
    func persistsSnapshot() async throws {
        let directory = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let fileURL = directory.appendingPathComponent("yasumidoki.json")

        let store = try FileBackedYasumidokiStore(fileURL: fileURL)
        let check = try await store.recordFatigueCheck(
            fatigueType: .vagueDepletion,
            memo: nil,
            createdAt: Date(timeIntervalSince1970: 2_000)
        )
        let action = RecoveryCatalog.default.action(for: .vagueDepletion)
        _ = try await store.recordCompletion(
            action: action,
            linkedFatigueCheckID: check.id,
            completedAt: Date(timeIntervalSince1970: 2_030)
        )

        let reloaded = try FileBackedYasumidokiStore(fileURL: fileURL)
        let snapshot = await reloaded.snapshot()

        #expect(snapshot.checks.count == 1)
        #expect(snapshot.completions.count == 1)
        #expect(snapshot.companionState.growthLevel == 1)
    }
}
```

- [ ] **Step 2: Write failing reflection tests**

Create `ReflectionBuilderTests.swift`:

```swift
import Foundation
import Testing
@testable import YasumidokiCore

@Suite("Reflection builder")
struct ReflectionBuilderTests {
    @Test("summarizes the latest seven days without streak pressure")
    func summarizesSevenDays() {
        let now = Date(timeIntervalSince1970: 10_000)
        let checks = [
            FatigueCheck(createdAt: now.addingTimeInterval(-86_400), fatigueType: .informationFatigue, optionalMemo: nil),
            FatigueCheck(createdAt: now.addingTimeInterval(-172_800), fatigueType: .informationFatigue, optionalMemo: nil),
            FatigueCheck(createdAt: now.addingTimeInterval(-259_200), fatigueType: .comparisonFatigue, optionalMemo: nil)
        ]
        let summary = ReflectionBuilder().summary(
            snapshot: YasumidokiSnapshot(checks: checks, completions: [], companionState: CompanionState()),
            now: now
        )

        #expect(summary.daysIncluded == 7)
        #expect(summary.mostCommonFatigueType == .informationFatigue)
        #expect(summary.companionMessage.contains("できない日") == true)
    }
}
```

- [ ] **Step 3: Run tests to verify they fail**

Run:

```bash
swift test --package-path Core/YasumidokiCore --filter FileBackedYasumidokiStoreTests
swift test --package-path Core/YasumidokiCore --filter ReflectionBuilderTests
```

Expected: FAIL because persistence and reflection types do not exist.

- [ ] **Step 4: Implement file-backed persistence**

Create `FileBackedYasumidokiStore.swift` as an actor that loads JSON during init and writes after every mutation:

```swift
import Foundation

public actor FileBackedYasumidokiStore: YasumidokiStore {
    private let fileURL: URL
    private var currentSnapshot: YasumidokiSnapshot

    public init(fileURL: URL) throws {
        self.fileURL = fileURL

        if FileManager.default.fileExists(atPath: fileURL.path) {
            let data = try Data(contentsOf: fileURL)
            self.currentSnapshot = try JSONDecoder().decode(YasumidokiSnapshot.self, from: data)
        } else {
            self.currentSnapshot = YasumidokiSnapshot()
        }
    }

    public static func defaultStore() throws -> FileBackedYasumidokiStore {
        let directory = try FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("Yasumidoki", isDirectory: true)

        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return try FileBackedYasumidokiStore(fileURL: directory.appendingPathComponent("yasumidoki.json"))
    }

    public func snapshot() async -> YasumidokiSnapshot {
        currentSnapshot
    }

    public func recordFatigueCheck(
        fatigueType: FatigueType,
        memo: String?,
        createdAt: Date = Date()
    ) async throws -> FatigueCheck {
        let trimmedMemo = memo?.trimmingCharacters(in: .whitespacesAndNewlines)
        let check = FatigueCheck(
            createdAt: createdAt,
            fatigueType: fatigueType,
            optionalMemo: trimmedMemo?.isEmpty == true ? nil : trimmedMemo
        )
        currentSnapshot.checks.append(check)
        try save()
        return check
    }

    public func recordCompletion(
        action: RecoveryAction,
        linkedFatigueCheckID: UUID?,
        completedAt: Date = Date()
    ) async throws -> RecoveryCompletion {
        let completion = RecoveryCompletion(
            actionID: action.id,
            actionTitle: action.title,
            completedAt: completedAt,
            linkedFatigueCheckID: linkedFatigueCheckID
        )
        currentSnapshot.completions.append(completion)
        currentSnapshot.companionState.growthLevel += 1
        currentSnapshot.companionState.lastInteractionAt = completedAt
        if currentSnapshot.companionState.growthLevel == 1 {
            currentSnapshot.companionState.unlockedItems.append("lamp")
        }
        try save()
        return completion
    }

    private func save() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(currentSnapshot)
        try data.write(to: fileURL, options: [.atomic])
    }
}
```

Important behavior:

- Missing file means an empty snapshot.
- Save after `recordFatigueCheck`.
- Save after `recordCompletion`.
- Throw file errors instead of silently discarding user data.

- [ ] **Step 5: Implement reflection summary**

Create `ReflectionSummary.swift`:

```swift
public struct ReflectionSummary: Equatable, Sendable {
    public let daysIncluded: Int
    public let checkCount: Int
    public let completionCount: Int
    public let mostCommonFatigueType: FatigueType?
    public let companionMessage: String
}
```

Create `ReflectionBuilder.swift` with:

```swift
import Foundation

public struct ReflectionBuilder: Sendable {
    public init() {}

    public func summary(snapshot: YasumidokiSnapshot, now: Date = Date()) -> ReflectionSummary {
        let start = Calendar.current.date(byAdding: .day, value: -6, to: Calendar.current.startOfDay(for: now)) ?? now
        let recentChecks = snapshot.checks.filter { $0.createdAt >= start && $0.createdAt <= now }
        let recentCompletions = snapshot.completions.filter { $0.completedAt >= start && $0.completedAt <= now }
        let mostCommon = recentChecks
            .reduce(into: [FatigueType: Int]()) { counts, check in counts[check.fatigueType, default: 0] += 1 }
            .max { $0.value < $1.value }?
            .key

        let message: String
        if recentChecks.isEmpty {
            message = "記録がない日も、休むための時間です。できない日があっても大丈夫。"
        } else {
            message = "この7日間もおつかれさまでした。できない日があっても大丈夫。"
        }

        return ReflectionSummary(
            daysIncluded: 7,
            checkCount: recentChecks.count,
            completionCount: recentCompletions.count,
            mostCommonFatigueType: mostCommon,
            companionMessage: message
        )
    }
}
```

- [ ] **Step 6: Run all core tests**

Run:

```bash
swift test --package-path Core/YasumidokiCore
```

Expected: PASS.

- [ ] **Step 7: Commit**

```bash
git add Core/YasumidokiCore
git commit -m "Add Yasumidoki local persistence and reflection"
```

## Task 4: Xcode SwiftUI Project Gate

**Files:**
- Create manually via Xcode: `Yasumidoki/Yasumidoki.xcodeproj`
- Create manually via Xcode: `Yasumidoki/Yasumidoki/YasumidokiApp.swift`

- [ ] **Step 1: Stop if Xcode is not installed**

Run:

```bash
xcodebuild -version
```

Expected: Xcode version output. If it fails, ask the user to install Xcode and stop app-target execution.

- [ ] **Step 2: Create an empty app project in Xcode**

Open Xcode and create:

- Platform: iOS
- Template: App
- Product Name: `Yasumidoki`
- Organization Identifier: `com.hiroshiimaizumi`
- Interface: SwiftUI
- Language: Swift
- Tests: enabled
- Storage: none
- Save location: repository root, creating `Yasumidoki/`

Expected files:

```text
Yasumidoki/Yasumidoki.xcodeproj
Yasumidoki/Yasumidoki/YasumidokiApp.swift
Yasumidoki/Yasumidoki/ContentView.swift
Yasumidoki/YasumidokiTests/
Yasumidoki/YasumidokiUITests/
```

- [ ] **Step 3: Link local core package**

In Xcode, add local package:

```text
../Core/YasumidokiCore
```

Link product:

```text
YasumidokiCore
```

to target:

```text
Yasumidoki
```

If this requires project automation, use `@xcode-project-setup`. Do not manually edit `.pbxproj` with Ruby or ad hoc text scripts.

- [ ] **Step 4: Build the empty project**

Run:

```bash
xcodebuild -project Yasumidoki/Yasumidoki.xcodeproj -scheme Yasumidoki -destination 'generic/platform=iOS Simulator' build
```

Expected: BUILD SUCCEEDED.

- [ ] **Step 5: Commit**

```bash
git add Yasumidoki
git commit -m "Create Yasumidoki SwiftUI app project"
```

## Task 5: App Model, Theme, And Root Navigation

**Files:**
- Create: `Yasumidoki/Yasumidoki/App/AppModel.swift`
- Create: `Yasumidoki/Yasumidoki/App/AppRoute.swift`
- Create: `Yasumidoki/Yasumidoki/App/AppRootView.swift`
- Create: `Yasumidoki/Yasumidoki/App/YasumidokiStoreFactory.swift`
- Create: `Yasumidoki/Yasumidoki/Design/YasumidokiTheme.swift`
- Modify: `Yasumidoki/Yasumidoki/YasumidokiApp.swift`
- Modify: `Yasumidoki/Yasumidoki/ContentView.swift` or replace with `Yasumidoki/Yasumidoki/App/AppRootView.swift`

- [ ] **Step 1: Create app route enum**

Create `AppRoute.swift`:

```swift
import Foundation
import YasumidokiCore

enum AppRoute: Hashable {
    case fatigueCheck
    case recoveryAction(FatigueType)
    case recoveryComplete
    case reflection
}
```

- [ ] **Step 2: Create app model**

Create `AppModel.swift`:

```swift
import Foundation
import Observation
import YasumidokiCore

@MainActor
@Observable
final class AppModel {
    private let store: any YasumidokiStore
    private let catalog: RecoveryCatalog
    private let reflectionBuilder: ReflectionBuilder

    var snapshot = YasumidokiSnapshot()
    var selectedCheck: FatigueCheck?
    var selectedAction: RecoveryAction?
    var errorMessage: String?

    init(
        store: any YasumidokiStore,
        catalog: RecoveryCatalog = .default,
        reflectionBuilder: ReflectionBuilder = ReflectionBuilder()
    ) {
        self.store = store
        self.catalog = catalog
        self.reflectionBuilder = reflectionBuilder
    }

    func load() async {
        snapshot = await store.snapshot()
    }

    func recordFatigue(_ fatigueType: FatigueType, memo: String?) async -> RecoveryAction? {
        do {
            let check = try await store.recordFatigueCheck(fatigueType: fatigueType, memo: memo, createdAt: Date())
            let action = catalog.action(for: fatigueType)
            selectedCheck = check
            selectedAction = action
            snapshot = await store.snapshot()
            return action
        } catch {
            errorMessage = "保存できませんでした。少し時間を置いてもう一度お試しください。"
            return nil
        }
    }

    func completeSelectedAction() async {
        guard let action = selectedAction else { return }
        do {
            _ = try await store.recordCompletion(
                action: action,
                linkedFatigueCheckID: selectedCheck?.id,
                completedAt: Date()
            )
            snapshot = await store.snapshot()
        } catch {
            errorMessage = "完了を保存できませんでした。"
        }
    }

    var reflectionSummary: ReflectionSummary {
        reflectionBuilder.summary(snapshot: snapshot)
    }
}
```

- [ ] **Step 3: Create theme**

Create `YasumidokiTheme.swift` with semantic colors and spacing. Use SwiftUI colors that adapt well enough for light/dark mode:

```swift
import SwiftUI

enum YasumidokiTheme {
    static let pageBackground = Color(.systemGroupedBackground)
    static let cardBackground = Color(.secondarySystemGroupedBackground)
    static let sage = Color(red: 0.56, green: 0.60, blue: 0.42)
    static let butter = Color(red: 0.95, green: 0.86, blue: 0.67)
    static let peach = Color(red: 0.92, green: 0.79, blue: 0.71)
    static let cornerRadius: CGFloat = 22
    static let contentPadding: CGFloat = 20
}
```

- [ ] **Step 4: Create safe store factory**

Create `YasumidokiStoreFactory.swift`:

```swift
import YasumidokiCore

enum YasumidokiStoreFactory {
    static func makeStore() -> any YasumidokiStore {
        do {
            return try FileBackedYasumidokiStore.defaultStore()
        } catch {
            return InMemoryYasumidokiStore()
        }
    }
}
```

- [ ] **Step 5: Wire app entry to the model**

In `YasumidokiApp.swift`, create the model:

```swift
import SwiftUI

@main
struct YasumidokiApp: App {
    @State private var model = AppModel(
        store: YasumidokiStoreFactory.makeStore()
    )

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environment(model)
                .task {
                    await model.load()
                }
        }
    }
}
```

- [ ] **Step 6: Create root navigation**

Create `AppRootView.swift` with `NavigationStack` and route destinations.

- [ ] **Step 7: Build**

Run:

```bash
xcodebuild -project Yasumidoki/Yasumidoki.xcodeproj -scheme Yasumidoki -destination 'generic/platform=iOS Simulator' build
```

Expected: BUILD SUCCEEDED.

- [ ] **Step 8: Commit**

```bash
git add Yasumidoki
git commit -m "Add Yasumidoki app model and navigation shell"
```

## Task 6: Home Screen And Companion Room

**Files:**
- Create: `Yasumidoki/Yasumidoki/Components/PrimaryButton.swift`
- Create: `Yasumidoki/Yasumidoki/Components/CompanionRoomView.swift`
- Create: `Yasumidoki/Yasumidoki/Features/Home/HomeView.swift`
- Modify: `Yasumidoki/Yasumidoki/App/AppRootView.swift`

- [ ] **Step 1: Create reusable primary button**

Create `PrimaryButton.swift` using native Button, 44pt minimum height, and Dynamic Type-friendly text.

- [ ] **Step 2: Create companion room view**

Create `CompanionRoomView.swift` with SwiftUI shapes:

- Warm rounded room card.
- Round window.
- Lamp circle that becomes brighter when `growthLevel > 0`.
- Small plant or leaf when `unlockedItems` contains `lamp` or `plant`.
- Simple plush-like companion using circles/capsules.
- `accessibilityLabel("やすみどきの相棒が部屋で休んでいます")`.

- [ ] **Step 3: Create home view**

Create `HomeView.swift`:

- Large title: `やすみどき`
- Subtitle: `今日はここまででOK`
- `CompanionRoomView(companionState: model.snapshot.companionState)`
- Primary button: `今日のつかれを見る`
- Secondary button/link: `7日間をふりかえる`
- No streak count.
- No pressure copy.

- [ ] **Step 4: Wire home into root**

Set `HomeView` as root and route buttons to `.fatigueCheck` and `.reflection`.

- [ ] **Step 5: Build**

Run:

```bash
xcodebuild -project Yasumidoki/Yasumidoki.xcodeproj -scheme Yasumidoki -destination 'generic/platform=iOS Simulator' build
```

Expected: BUILD SUCCEEDED.

- [ ] **Step 6: Manual visual QA**

Open in simulator and check:

- Content respects safe areas.
- Buttons are at least 44pt high.
- Text remains readable with large Dynamic Type.
- Home feels calm, not dashboard-like.

- [ ] **Step 7: Commit**

```bash
git add Yasumidoki
git commit -m "Add Yasumidoki home screen"
```

## Task 7: Fatigue Check And Recovery Action Flow

**Files:**
- Create: `Yasumidoki/Yasumidoki/Features/FatigueCheck/FatigueCheckView.swift`
- Create: `Yasumidoki/Yasumidoki/Features/Recovery/RecoveryActionView.swift`
- Modify: `Yasumidoki/Yasumidoki/App/AppRootView.swift`

- [ ] **Step 1: Create fatigue check view**

Create a `List` or `ScrollView` of `FatigueType.allCases`, with each row as a native Button:

- Display `fatigueType.displayName`.
- Optional memo `TextField("ひとことメモ（任意）", text: $memo, axis: .vertical)`.
- Primary action disabled until a fatigue type is selected.
- Accessibility label includes the fatigue type.

- [ ] **Step 2: Create recovery action view**

Create `RecoveryActionView` that receives a `RecoveryAction`:

- Shows title and prompt.
- Shows duration like `あと 30秒`.
- Uses a timer that counts down.
- Shows `できた` button after the countdown completes.
- Respect Reduce Motion: no required animation.

- [ ] **Step 3: Wire route from fatigue check to recovery action**

When the user taps continue:

```swift
if let action = await model.recordFatigue(selectedFatigueType, memo: memo) {
    path.append(AppRoute.recoveryAction(selectedFatigueType))
}
```

Use `model.selectedAction` in the destination.

- [ ] **Step 4: Build**

Run:

```bash
xcodebuild -project Yasumidoki/Yasumidoki.xcodeproj -scheme Yasumidoki -destination 'generic/platform=iOS Simulator' build
```

Expected: BUILD SUCCEEDED.

- [ ] **Step 5: Manual flow QA**

In simulator:

1. Launch app.
2. Tap `今日のつかれを見る`.
3. Select `情報疲れ`.
4. Add optional memo.
5. Continue to recovery action.
6. Wait for countdown.

Expected: user reaches the recovery action without errors.

- [ ] **Step 6: Commit**

```bash
git add Yasumidoki
git commit -m "Add fatigue check and recovery action flow"
```

## Task 8: Completion Screen And Reflection View

**Files:**
- Create: `Yasumidoki/Yasumidoki/Features/Recovery/RecoveryCompleteView.swift`
- Create: `Yasumidoki/Yasumidoki/Features/Reflection/ReflectionView.swift`
- Modify: `Yasumidoki/Yasumidoki/App/AppRootView.swift`
- Modify: `Yasumidoki/Yasumidoki/Features/Home/HomeView.swift`

- [ ] **Step 1: Create completion view**

Create `RecoveryCompleteView`:

- Title: `今日はここまででOK`
- Body: `ひと息つけたことを、相棒が覚えてくれました。`
- Show small `CompanionRoomView`.
- Button: `部屋に戻る`.
- On appear or button tap, call `await model.completeSelectedAction()` once.

- [ ] **Step 2: Create reflection view**

Create `ReflectionView`:

- Title: `7日間のふりかえり`
- Show check count and completion count.
- If `mostCommonFatigueType` exists, show `よく出ていたつかれ`.
- Show `summary.companionMessage`.
- Avoid streak language.

- [ ] **Step 3: Wire completion route**

From `RecoveryActionView`, pressing `できた` should route to `.recoveryComplete`.

- [ ] **Step 4: Wire return home**

`RecoveryCompleteView` should clear navigation path and return home.

- [ ] **Step 5: Build**

Run:

```bash
xcodebuild -project Yasumidoki/Yasumidoki.xcodeproj -scheme Yasumidoki -destination 'generic/platform=iOS Simulator' build
```

Expected: BUILD SUCCEEDED.

- [ ] **Step 6: Manual end-to-end QA**

In simulator:

1. Launch app.
2. Complete the full loop.
3. Return home.
4. Confirm room lamp/item changed.
5. Open reflection.

Expected:

- Completion is saved.
- Growth level affects the room.
- Reflection copy is gentle.
- No streak pressure appears.

- [ ] **Step 7: Commit**

```bash
git add Yasumidoki
git commit -m "Add completion and reflection screens"
```

## Task 9: Accessibility, Motion, And Dark Mode Pass

**Files:**
- Modify: SwiftUI files under `Yasumidoki/Yasumidoki/`

- [ ] **Step 1: Run app with large Dynamic Type**

In simulator:

```text
Settings > Accessibility > Display & Text Size > Larger Text
```

Expected:

- Buttons do not clip.
- Fatigue rows remain tappable.
- Recovery countdown remains readable.

- [ ] **Step 2: Run app with Reduce Motion**

In simulator:

```text
Settings > Accessibility > Motion > Reduce Motion
```

Expected:

- Any decorative motion stops or becomes subtle.
- Flow still works.

- [ ] **Step 3: Check VoiceOver labels**

Enable VoiceOver and inspect:

- Home primary action.
- Fatigue choices.
- Recovery countdown.
- Complete button.
- Reflection summary.

Expected: no unlabeled interactive elements.

- [ ] **Step 4: Check Dark Mode**

Run with Dark Mode:

```text
Settings > Developer > Dark Appearance
```

Expected:

- Text contrast remains readable.
- Card/background hierarchy remains visible.

- [ ] **Step 5: Build and test**

Run:

```bash
swift test --package-path Core/YasumidokiCore
xcodebuild -project Yasumidoki/Yasumidoki.xcodeproj -scheme Yasumidoki -destination 'generic/platform=iOS Simulator' build
```

Expected: PASS and BUILD SUCCEEDED.

- [ ] **Step 6: Commit**

```bash
git add Yasumidoki
git commit -m "Polish Yasumidoki accessibility and appearance"
```

## Task 10: README And Final Verification

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Document core tests**

Add:

````markdown
## Core Tests

```sh
swift test --package-path Core/YasumidokiCore
```
````

- [ ] **Step 2: Document iOS build**

Add:

````markdown
## iOS App

The app target lives in `Yasumidoki/`.

```sh
xcodebuild -project Yasumidoki/Yasumidoki.xcodeproj -scheme Yasumidoki -destination 'generic/platform=iOS Simulator' build
```
````

- [ ] **Step 3: Run final verification**

Run:

```bash
swift test --package-path Core/YasumidokiCore
xcodebuild -project Yasumidoki/Yasumidoki.xcodeproj -scheme Yasumidoki -destination 'generic/platform=iOS Simulator' build
git status --short
```

Expected:

- Core tests pass.
- App build succeeds.
- `git status --short` only shows intentional changes before commit, then clean after commit.

- [ ] **Step 4: Commit**

```bash
git add README.md
git commit -m "Document Yasumidoki iOS app development"
```

## Execution Notes

- If Xcode is not available, complete Tasks 1-3 first. These create real tested domain code and reduce UI risk.
- Do not add third-party dependencies for the MVP.
- Do not use Ruby or direct `.pbxproj` text editing.
- Prefer native SwiftUI controls and semantic text styles.
- Keep Japanese copy gentle and non-medical.
- Every task should end with tests/build and a commit.
