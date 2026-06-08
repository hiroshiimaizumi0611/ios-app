import Foundation

public actor FileBackedYasumidokiStore: YasumidokiStore {
    private let fileURL: URL
    private var currentSnapshot: YasumidokiSnapshot

    public init(fileURL: URL) throws {
        self.fileURL = fileURL

        if FileManager.default.fileExists(atPath: fileURL.path) {
            let data = try Data(contentsOf: fileURL)
            self.currentSnapshot = try JSONDecoder().decode(YasumidokiSnapshot.self, from: data)
        } else {
            self.currentSnapshot = YasumidokiSnapshot()
        }
    }

    public static func defaultStore() throws -> FileBackedYasumidokiStore {
        let directory = try FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("Yasumidoki", isDirectory: true)

        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return try FileBackedYasumidokiStore(fileURL: directory.appendingPathComponent("yasumidoki.json"))
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
        try save()
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
        try save()
        return completion
    }

    private func save() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(currentSnapshot)
        try data.write(to: fileURL, options: [.atomic])
    }
}
