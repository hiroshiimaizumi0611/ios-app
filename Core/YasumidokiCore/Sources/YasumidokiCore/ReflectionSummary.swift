public struct ReflectionSummary: Equatable, Sendable {
    public let daysIncluded: Int
    public let checkCount: Int
    public let completionCount: Int
    public let mostCommonFatigueType: FatigueType?
    public let companionMessage: String

    public init(
        daysIncluded: Int,
        checkCount: Int,
        completionCount: Int,
        mostCommonFatigueType: FatigueType?,
        companionMessage: String
    ) {
        self.daysIncluded = daysIncluded
        self.checkCount = checkCount
        self.completionCount = completionCount
        self.mostCommonFatigueType = mostCommonFatigueType
        self.companionMessage = companionMessage
    }
}
