import Foundation

public protocol YasumidokiStore: Sendable {
    func snapshot() async -> YasumidokiSnapshot
    func recordFatigueCheck(fatigueType: FatigueType, memo: String?, createdAt: Date) async throws -> FatigueCheck
    func recordCompletion(action: RecoveryAction, linkedFatigueCheckID: UUID?, completedAt: Date) async throws -> RecoveryCompletion
}
