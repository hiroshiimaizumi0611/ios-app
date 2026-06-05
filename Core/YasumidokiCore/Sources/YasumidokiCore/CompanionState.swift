import Foundation

public struct CompanionState: Codable, Equatable, Sendable {
    public var growthLevel: Int
    public var roomTheme: String
    public var unlockedItems: [String]
    public var lastInteractionAt: Date?

    public init(
        growthLevel: Int = 0,
        roomTheme: String = "soft-room",
        unlockedItems: [String] = [],
        lastInteractionAt: Date? = nil
    ) {
        self.growthLevel = growthLevel
        self.roomTheme = roomTheme
        self.unlockedItems = unlockedItems
        self.lastInteractionAt = lastInteractionAt
    }
}
