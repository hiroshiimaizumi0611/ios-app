import Foundation

public actor InMemoryYasumidokiStore: YasumidokiStore {
    private var currentSnapshot: YasumidokiSnapshot

    public init(snapshot: YasumidokiSnapshot = YasumidokiSnapshot()) {
        self.currentSnapshot = snapshot
    }

    public func snapshot() async -> YasumidokiSnapshot {
        currentSnapshot
    }

    public func recordFatigueCheck(
        fatigueType: FatigueType,
        memo: String?,
        createdAt: Date = Date()
    ) async throws -> FatigueCheck {
        let trimmedMemo = memo?.trimmingCharacters(in: .whitespacesAndNewlines)
        let check = FatigueCheck(
            createdAt: createdAt,
            fatigueType: fatigueType,
            optionalMemo: trimmedMemo?.isEmpty == true ? nil : trimmedMemo
        )
        currentSnapshot.checks.append(check)
        return check
    }

    public func recordCompletion(
        action: RecoveryAction,
        linkedFatigueCheckID: UUID?,
        completedAt: Date = Date()
    ) async throws -> RecoveryCompletion {
        let completion = RecoveryCompletion(
            actionID: action.id,
            actionTitle: action.title,
            completedAt: completedAt,
            linkedFatigueCheckID: linkedFatigueCheckID
        )
        currentSnapshot.completions.append(completion)
        currentSnapshot.companionState.growthLevel += 1
        currentSnapshot.companionState.lastInteractionAt = completedAt
        if currentSnapshot.companionState.growthLevel == 1 {
            currentSnapshot.companionState.unlockedItems.append("lamp")
        }
        return completion
    }
}
