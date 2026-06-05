import Foundation

public struct RecoveryCompletion: Codable, Equatable, Identifiable, Sendable {
    public let id: UUID
    public let actionID: UUID
    public let actionTitle: String
    public let completedAt: Date
    public let linkedFatigueCheckID: UUID?

    public init(
        id: UUID = UUID(),
        actionID: UUID,
        actionTitle: String,
        completedAt: Date,
        linkedFatigueCheckID: UUID?
    ) {
        self.id = id
        self.actionID = actionID
        self.actionTitle = actionTitle
        self.completedAt = completedAt
        self.linkedFatigueCheckID = linkedFatigueCheckID
    }
}
