import SwiftUI
import YasumidokiCore

struct AppRootView: View {
    @Environment(AppModel.self) private var model
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            HomeView(
                companionState: model.snapshot.companionState,
                onStartCheck: openFatigueCheck,
                onOpenReflection: openReflection
            )
            .navigationDestination(for: AppRoute.self) { route in
                destination(for: route)
            }
            .alert(
                "保存エラー",
                isPresented: Binding(
                    get: { model.errorMessage != nil },
                    set: { isPresented in
                        if !isPresented {
                            model.errorMessage = nil
                        }
                    }
                )
            ) {
                Button("OK", role: .cancel) {
                    model.errorMessage = nil
                }
            } message: {
                Text(model.errorMessage ?? "")
            }
        }
    }

    private func openFatigueCheck() {
        path.append(AppRoute.fatigueCheck)
    }

    private func openReflection() {
        path.append(AppRoute.reflection)
    }

    private func recordFatigue(_ fatigueType: FatigueType, memo: String?) async {
        if await model.recordFatigue(fatigueType, memo: memo) != nil {
            path.append(AppRoute.recoveryAction(fatigueType))
        }
    }

    private func openRecoveryComplete() {
        path.append(AppRoute.recoveryComplete)
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .fatigueCheck:
            FatigueCheckView(onContinue: recordFatigue)
        case let .recoveryAction(fatigueType):
            RecoveryActionView(
                action: model.selectedAction ?? RecoveryCatalog.default.action(for: fatigueType),
                onComplete: openRecoveryComplete
            )
        case .recoveryComplete:
            Text("おつかれさまでした")
                .navigationTitle("完了")
        case .reflection:
            Text(model.reflectionSummary.companionMessage)
                .navigationTitle("7日間")
        }
    }
}

#Preview {
    AppRootView()
        .environment(AppModel(store: YasumidokiStoreFactory.makeStore()))
}
