import Foundation

public struct CompanionReaction: Codable, Equatable, Sendable {
    public enum Kind: String, Codable, Equatable, Sendable {
        case welcome
        case noticedFatigue
        case completedRecovery
    }

    public var kind: Kind
    public var message: String
    public var mood: String
    public var createdAt: Date

    public init(kind: Kind, message: String, mood: String = "soft", createdAt: Date) {
        self.kind = kind
        self.message = message
        self.mood = mood
        self.createdAt = createdAt
    }
}
