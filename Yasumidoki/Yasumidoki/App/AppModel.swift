import Foundation
import Observation
import YasumidokiCore

@MainActor
@Observable
final class AppModel {
    private let store: any YasumidokiStore
    private let catalog: RecoveryCatalog
    private let reflectionBuilder: ReflectionBuilder

    var snapshot = YasumidokiSnapshot()
    var selectedCheck: FatigueCheck?
    var selectedAction: RecoveryAction?
    var errorMessage: String?

    init(
        store: any YasumidokiStore,
        catalog: RecoveryCatalog = .default,
        reflectionBuilder: ReflectionBuilder = ReflectionBuilder()
    ) {
        self.store = store
        self.catalog = catalog
        self.reflectionBuilder = reflectionBuilder
    }

    func load() async {
        snapshot = await store.snapshot()
    }

    func recordFatigue(_ fatigueType: FatigueType, memo: String?) async -> RecoveryAction? {
        do {
            let check = try await store.recordFatigueCheck(
                fatigueType: fatigueType,
                memo: memo,
                createdAt: Date()
            )
            let action = catalog.action(for: fatigueType)
            selectedCheck = check
            selectedAction = action
            snapshot = await store.snapshot()
            return action
        } catch {
            errorMessage = "保存できませんでした。少し時間を置いてもう一度お試しください。"
            return nil
        }
    }

    func completeSelectedAction() async {
        guard let action = selectedAction else { return }

        do {
            _ = try await store.recordCompletion(
                action: action,
                linkedFatigueCheckID: selectedCheck?.id,
                completedAt: Date()
            )
            snapshot = await store.snapshot()
        } catch {
            errorMessage = "完了を保存できませんでした。"
        }
    }

    var reflectionSummary: ReflectionSummary {
        reflectionBuilder.summary(snapshot: snapshot)
    }
}
