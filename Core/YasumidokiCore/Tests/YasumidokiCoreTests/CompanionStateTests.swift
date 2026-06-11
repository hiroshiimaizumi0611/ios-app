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
