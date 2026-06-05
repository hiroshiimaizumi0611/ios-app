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
            FatigueCheck(createdAt: now.addingTimeInterval(-259_200), fatigueType: .comparisonFatigue, optionalMemo: nil),
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
