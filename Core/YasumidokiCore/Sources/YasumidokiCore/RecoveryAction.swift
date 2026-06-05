import Foundation

public struct RecoveryAction: Codable, Equatable, Identifiable, Sendable {
    public let id: UUID
    public let title: String
    public let durationSeconds: Int
    public let category: String
    public let prompt: String

    public init(
        id: UUID = UUID(),
        title: String,
        durationSeconds: Int,
        category: String,
        prompt: String
    ) {
        self.id = id
        self.title = title
        self.durationSeconds = durationSeconds
        self.category = category
        self.prompt = prompt
    }
}
