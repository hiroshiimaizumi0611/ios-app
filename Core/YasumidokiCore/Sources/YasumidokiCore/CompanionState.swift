import Foundation

public struct CompanionState: Codable, Equatable, Sendable {
    public var growthLevel: Int
    public var roomTheme: String
    public var unlockedItems: [String]
    public var lastInteractionAt: Date?
    public var memory: CompanionMemory?
    public var reaction: CompanionReaction?

    public init(
        growthLevel: Int = 0,
        roomTheme: String = "soft-room",
        unlockedItems: [String] = [],
        lastInteractionAt: Date? = nil,
        memory: CompanionMemory? = nil,
        reaction: CompanionReaction? = nil
    ) {
        self.growthLevel = growthLevel
        self.roomTheme = roomTheme
        self.unlockedItems = unlockedItems
        self.lastInteractionAt = lastInteractionAt
        self.memory = memory
        self.reaction = reaction
    }
}
