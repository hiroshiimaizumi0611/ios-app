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
        currentSnapshot.companionState.memory = CompanionMemory(
            latestFatigueType: fatigueType,
            latestMemoPreview: check.optionalMemo,
            latestCheckAt: createdAt,
            latestCompletedActionTitle: currentSnapshot.companionState.memory?.latestCompletedActionTitle,
            latestCompletionAt: currentSnapshot.companionState.memory?.latestCompletionAt
        )
        currentSnapshot.companionState.reaction = CompanionReaction(
            kind: .noticedFatigue,
            message: "\(fatigueType.displayName)、ちゃんと受け取りました。",
            mood: "noticed",
            createdAt: createdAt
        )
        currentSnapshot.companionState.lastInteractionAt = createdAt
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
        currentSnapshot.companionState.memory = CompanionMemory(
            latestFatigueType: currentSnapshot.companionState.memory?.latestFatigueType,
            latestMemoPreview: currentSnapshot.companionState.memory?.latestMemoPreview,
            latestCheckAt: currentSnapshot.companionState.memory?.latestCheckAt,
            latestCompletedActionTitle: action.title,
            latestCompletionAt: completedAt
        )
        currentSnapshot.companionState.reaction = CompanionReaction(
            kind: .completedRecovery,
            message: "\(action.title)できたこと、相棒が覚えました。",
            mood: "warm",
            createdAt: completedAt
        )
        currentSnapshot.companionState.growthLevel += 1
        currentSnapshot.companionState.lastInteractionAt = completedAt
        if currentSnapshot.companionState.growthLevel == 1 {
            currentSnapshot.companionState.unlockedItems.append("lamp")
        }
        return completion
    }
}
