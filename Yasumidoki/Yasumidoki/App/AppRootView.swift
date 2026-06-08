import SwiftUI
import YasumidokiCore

struct AppRootView: View {
    @Environment(AppModel.self) private var model
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading, spacing: 18) {
                Text("やすみどき")
                    .font(.largeTitle.bold())
                    .foregroundStyle(YasumidokiTheme.primaryText)

                Text("今日はここまででOK")
                    .font(.title3)
                    .foregroundStyle(YasumidokiTheme.secondaryText)

                Button("今日のつかれを見る") {
                    path.append(AppRoute.fatigueCheck)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Button("7日間をふりかえる") {
                    path.append(AppRoute.reflection)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(YasumidokiTheme.contentPadding)
            .background(YasumidokiTheme.pageBackground)
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

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .fatigueCheck:
            Text("つかれチェック")
                .navigationTitle("つかれチェック")
        case .recoveryAction:
            Text("小さな回復")
                .navigationTitle("小さな回復")
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
