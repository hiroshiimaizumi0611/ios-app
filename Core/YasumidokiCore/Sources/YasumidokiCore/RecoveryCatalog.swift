public struct RecoveryCatalog: Sendable {
    public static let `default` = RecoveryCatalog()

    public init() {}

    public func action(for fatigueType: FatigueType) -> RecoveryAction {
        switch fatigueType {
        case .vagueDepletion:
            RecoveryAction(
                title: "ゆっくり3回、息をする",
                durationSeconds: 30,
                category: "breathing",
                prompt: "画面から少し目を離して、ゆっくり3回だけ息をしましょう。"
            )
        case .comparisonFatigue:
            RecoveryAction(
                title: "自分に戻るひと言",
                durationSeconds: 30,
                category: "self-kindness",
                prompt: "比べる時間をいったん置いて、自分にやさしい一文を向けましょう。"
            )
        case .informationFatigue:
            RecoveryAction(
                title: "目を閉じて休む",
                durationSeconds: 30,
                category: "eye-rest",
                prompt: "目を閉じて、入ってきた情報を静かにほどきましょう。"
            )
        case .unconsciousScrolling:
            RecoveryAction(
                title: "肩をゆるめる",
                durationSeconds: 30,
                category: "body",
                prompt: "スマホを置いて、肩を一度上げてからゆっくり下ろしましょう。"
            )
        case .doNotWantAnything:
            RecoveryAction(
                title: "水をひと口飲む",
                durationSeconds: 30,
                category: "care",
                prompt: "何かを頑張らなくて大丈夫。水をひと口だけ飲みましょう。"
            )
        }
    }
}
