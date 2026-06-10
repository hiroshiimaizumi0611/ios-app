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
