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
