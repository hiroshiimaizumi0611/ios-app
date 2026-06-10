import Foundation
import Testing
@testable import YasumidokiCore

@Suite("Companion message builder")
struct CompanionMessageBuilderTests {
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

    @Test("home message keeps completion memory concise")
    func compactCompletionHomeMessage() {
        let state = CompanionState(
            memory: CompanionMemory(latestCompletedActionTitle: "目を閉じて休む"),
            reaction: CompanionReaction(
                kind: .completedRecovery,
                message: "「目を閉じて休む」ができたこと、相棒が覚えました。",
                createdAt: Date(timeIntervalSince1970: 1_000)
            )
        )
        let builder = CompanionMessageBuilder()

        #expect(builder.homeGreeting(for: state) == "目を閉じて休む、ちゃんと覚えています")
    }
}
