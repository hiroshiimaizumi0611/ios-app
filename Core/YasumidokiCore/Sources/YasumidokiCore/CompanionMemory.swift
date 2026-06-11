import Foundation

public struct CompanionMemory: Codable, Equatable, Sendable {
    public var latestFatigueType: FatigueType?
    public var latestMemoPreview: String?
    public var latestCheckAt: Date?
    public var latestCompletedActionTitle: String?
    public var latestCompletionAt: Date?

    public init(
        latestFatigueType: FatigueType? = nil,
        latestMemoPreview: String? = nil,
        latestCheckAt: Date? = nil,
        latestCompletedActionTitle: String? = nil,
        latestCompletionAt: Date? = nil
    ) {
        self.latestFatigueType = latestFatigueType
        self.latestMemoPreview = latestMemoPreview
        self.latestCheckAt = latestCheckAt
        self.latestCompletedActionTitle = latestCompletedActionTitle
        self.latestCompletionAt = latestCompletionAt
    }
}
