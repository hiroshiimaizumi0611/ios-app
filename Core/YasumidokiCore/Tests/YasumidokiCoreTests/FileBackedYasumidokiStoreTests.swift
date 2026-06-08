import Foundation
import Testing
@testable import YasumidokiCore

@Suite("File-backed store")
struct FileBackedYasumidokiStoreTests {
    @Test("persists snapshot across store instances")
    func persistsSnapshot() async throws {
        let directory = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let fileURL = directory.appendingPathComponent("yasumidoki.json")

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
    }
}
