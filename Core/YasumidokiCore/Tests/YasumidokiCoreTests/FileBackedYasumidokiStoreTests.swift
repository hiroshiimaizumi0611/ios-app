import Foundation
import Testing
@testable import YasumidokiCore

@Suite("File-backed store")
struct FileBackedYasumidokiStoreTests {
    @Test("persists snapshot across store instances")
    func persistsSnapshot() async throws {
        let fileURL = try makeFileURL()

        let store = try FileBackedYasumidokiStore(fileURL: fileURL)
        let check = try await store.recordFatigueCheck(
            fatigueType: .vagueDepletion,
            memo: nil,
            createdAt: Date(timeIntervalSince1970: 2_000)
        )
        let action = RecoveryCatalog.default.action(for: .vagueDepletion)
        _ = try await store.recordCompletion(
            action: action,
            linkedFatigueCheckID: check.id,
            completedAt: Date(timeIntervalSince1970: 2_030)
        )

        let reloaded = try FileBackedYasumidokiStore(fileURL: fileURL)
        let snapshot = await reloaded.snapshot()

        #expect(snapshot.checks.count == 1)
        #expect(snapshot.completions.count == 1)
        #expect(snapshot.companionState.growthLevel == 1)
        #expect(snapshot.companionState.memory?.latestFatigueType == .vagueDepletion)
        #expect(snapshot.companionState.memory?.latestCompletedActionTitle == action.title)
        #expect(snapshot.companionState.reaction?.kind == .completedRecovery)
    }

    @Test("loads older snapshots without companion memory fields")
    func loadsOlderSnapshotWithoutMemoryFields() async throws {
        let fileURL = try makeFileURL()
        let encoder = JSONEncoder()
        let data = try encoder.encode(
            YasumidokiSnapshot(
                checks: [],
                completions: [],
                companionState: CompanionState(growthLevel: 0)
            )
        )
        let encodedSnapshot = String(decoding: data, as: UTF8.self)
        #expect(encodedSnapshot.contains("memory") == false)
        #expect(encodedSnapshot.contains("reaction") == false)

        try data.write(to: fileURL, options: [.atomic])

        let store = try FileBackedYasumidokiStore(fileURL: fileURL)
        let snapshot = await store.snapshot()

        #expect(snapshot.companionState.memory == nil)
        #expect(snapshot.companionState.reaction == nil)
    }

    private func makeFileURL() throws -> URL {
        let directory = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory.appendingPathComponent("yasumidoki.json")
    }
}
