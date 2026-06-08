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
