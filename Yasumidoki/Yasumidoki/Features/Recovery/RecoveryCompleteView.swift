import SwiftUI
import YasumidokiCore

struct RecoveryCompleteView: View {
    let companionState: CompanionState
    let onRecordCompletion: () async -> Void
    let onReturnHome: () -> Void

    @State private var didRecordCompletion = false

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            VStack(alignment: .leading, spacing: 8) {
                Text("今日はここまででOK")
                    .font(.title.bold())
                    .foregroundStyle(YasumidokiTheme.primaryText)

                Text("ひと息つけたことを、相棒が覚えてくれました。")
                    .font(.body)
                    .foregroundStyle(YasumidokiTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            CompanionRoomView(companionState: companionState)
                .frame(maxWidth: 300)
                .frame(maxWidth: .infinity)

            Text("できた日だけで十分です。できない日があっても、記録は責めません。")
                .font(.footnote)
                .foregroundStyle(YasumidokiTheme.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
                .padding(16)
                .background(YasumidokiTheme.cardBackground, in: RoundedRectangle(cornerRadius: 18, style: .continuous))

            Spacer()

            PrimaryButton("部屋に戻る", systemImage: "house", action: returnHome)
        }
        .padding(YasumidokiTheme.contentPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(YasumidokiTheme.pageBackground)
        .navigationTitle("完了")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await recordCompletionIfNeeded()
        }
    }

    private func returnHome() {
        Task {
            await recordCompletionIfNeeded()
            onReturnHome()
        }
    }

    private func recordCompletionIfNeeded() async {
        guard !didRecordCompletion else { return }
        didRecordCompletion = true
        await onRecordCompletion()
    }
}

#Preview {
    NavigationStack {
        RecoveryCompleteView(
            companionState: CompanionState(growthLevel: 1, unlockedItems: ["lamp"]),
            onRecordCompletion: {},
            onReturnHome: {}
        )
    }
}
