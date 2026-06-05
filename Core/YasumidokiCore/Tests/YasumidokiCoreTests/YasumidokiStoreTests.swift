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
