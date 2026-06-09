import SwiftUI
import YasumidokiCore

struct RecoveryCompleteView: View {
    let companionState: CompanionState
    let onRecordCompletion: () async -> Void
    let onReturnHome: () -> Void

    @State private var didRecordCompletion = false

    var body: some View {
        ZStack {
            RoomBackdropView(imageOpacity: 0.52, blurRadius: 1)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                SoftScreenHeader(title: "やすみどき", showsBackButton: false)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        SoftPanel(horizontalPadding: 22, verticalPadding: 28) {
                            VStack(spacing: 20) {
                                Image(systemName: "sparkles")
                                    .font(.title.weight(.medium))
                                    .foregroundStyle(YasumidokiTheme.honey)
                                    .accessibilityHidden(true)

                                VStack(spacing: 8) {
                                    Text("今日はここまででOK")
                                        .font(.system(.title2, design: .rounded).weight(.semibold))
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(YasumidokiTheme.primaryText)

                                    Text("ひと息つけたことを、相棒が覚えてくれました。")
                                        .font(.body)
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(YasumidokiTheme.secondaryText)
                                        .fixedSize(horizontal: false, vertical: true)
                                }

                                Image("HomeRoomIllustration")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 250)
                                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                                            .strokeBorder(.white.opacity(0.72), lineWidth: 1)
                                    }
                                    .shadow(color: YasumidokiTheme.shadow.opacity(0.08), radius: 16, y: 8)
                                    .accessibilityLabel("相棒が部屋で休んでいます")

                                SoftPanel(horizontalPadding: 16, verticalPadding: 14, cornerRadius: 22) {
                                    HStack(spacing: 12) {
                                        SoftIconBubble(systemImage: "lamp.table", tint: YasumidokiTheme.honey, size: 52)

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(roomChangeText)
                                                .font(.subheadline.weight(.semibold))
                                                .foregroundStyle(YasumidokiTheme.primaryText)

                                            Text("できない日があっても、記録は責めません。")
                                                .font(.footnote)
                                                .foregroundStyle(YasumidokiTheme.secondaryText)
                                                .fixedSize(horizontal: false, vertical: true)
                                        }

                                        Spacer(minLength: 0)
                                    }
                                }

                                PrimaryButton("部屋に戻る", systemImage: "house", action: returnHome)
                            }
                        }
                    }
                    .padding(.horizontal, YasumidokiTheme.contentPadding)
                    .padding(.bottom, 28)
                }
            }
        }
        .background(YasumidokiTheme.pageBackground)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await recordCompletionIfNeeded()
        }
    }

    private var roomChangeText: String {
        companionState.growthLevel > 0 ? "部屋の灯りが、少しあたたかくなりました。" : "相棒が、今日のひと息を覚えました。"
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
