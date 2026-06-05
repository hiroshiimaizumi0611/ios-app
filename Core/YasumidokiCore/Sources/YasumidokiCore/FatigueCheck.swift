import Foundation

public struct FatigueCheck: Codable, Equatable, Identifiable, Sendable {
    public let id: UUID
    public let createdAt: Date
    public let fatigueType: FatigueType
    public let optionalMemo: String?

    public init(id: UUID = UUID(), createdAt: Date, fatigueType: FatigueType, optionalMemo: String?) {
        self.id = id
        self.createdAt = createdAt
        self.fatigueType = fatigueType
        self.optionalMemo = optionalMemo
    }
}
