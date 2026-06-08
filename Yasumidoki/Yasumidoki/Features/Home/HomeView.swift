import SwiftUI
import YasumidokiCore

struct HomeView: View {
    let companionState: CompanionState
    let onStartCheck: () -> Void
    let onOpenReflection: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("やすみどき")
                        .font(.largeTitle.bold())
                        .foregroundStyle(YasumidokiTheme.primaryText)

                    Text("今日はここまででOK")
                        .font(.title3)
                        .foregroundStyle(YasumidokiTheme.secondaryText)
                }
                .accessibilityElement(children: .combine)

                CompanionRoomView(companionState: companionState)

                VStack(alignment: .leading, spacing: 14) {
                    Text("いまの疲れを、ひとつだけ選びましょう。")
                        .font(.body)
                        .foregroundStyle(YasumidokiTheme.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)

                    PrimaryButton("今日のつかれを見る", systemImage: "leaf", action: onStartCheck)

                    Button(action: onOpenReflection) {
                        Label("7日間をふりかえる", systemImage: "calendar")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: 50)
                    }
                    .buttonStyle(.bordered)
                    .tint(YasumidokiTheme.sage)
                    .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .padding(18)
                .background(YasumidokiTheme.cardBackground, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .padding(YasumidokiTheme.contentPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(YasumidokiTheme.pageBackground)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HomeView(
            companionState: CompanionState(growthLevel: 1, unlockedItems: ["lamp"]),
            onStartCheck: {},
            onOpenReflection: {}
        )
    }
}
