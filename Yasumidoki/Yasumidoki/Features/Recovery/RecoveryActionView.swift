import SwiftUI
import YasumidokiCore

struct RecoveryActionView: View {
    let action: RecoveryAction
    let onComplete: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var remainingSeconds: Int

    init(action: RecoveryAction, onComplete: @escaping () -> Void) {
        self.action = action
        self.onComplete = onComplete
        _remainingSeconds = State(initialValue: action.durationSeconds)
    }

    private var isFinished: Bool {
        remainingSeconds <= 0
    }

    private var progress: Double {
        guard action.durationSeconds > 0 else { return 1 }
        let elapsed = action.durationSeconds - max(remainingSeconds, 0)
        return min(max(Double(elapsed) / Double(action.durationSeconds), 0), 1)
    }

    var body: some View {
        ZStack {
            RoomBackdropView(imageOpacity: 0.44, blurRadius: 1)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                SoftScreenHeader(title: "30秒のひと息")

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        SoftPanel(horizontalPadding: 22, verticalPadding: 28) {
                            VStack(spacing: 22) {
                                VStack(spacing: 8) {
                                    Text(action.title)
                                        .font(.system(.title3, design: .rounded).weight(.semibold))
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(YasumidokiTheme.primaryText)
                                        .fixedSize(horizontal: false, vertical: true)

                                    Text(action.prompt)
                                        .font(.subheadline)
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(YasumidokiTheme.secondaryText)
                                        .fixedSize(horizontal: false, vertical: true)
                                }

                                timerScene

                                PrimaryButton("できた", systemImage: "checkmark") {
                                    onComplete()
                                }
                            }
                        }

                        SoftPanel(horizontalPadding: 18, verticalPadding: 16, cornerRadius: 24) {
                            HStack(spacing: 14) {
                                SoftIconBubble(systemImage: "heart.fill", tint: YasumidokiTheme.peach, size: 56)

                                VStack(alignment: .leading, spacing: 6) {
                                    Text("今日はここまででOK")
                                        .font(.headline)
                                        .foregroundStyle(YasumidokiTheme.primaryText)

                                    Text("相棒がそばにいます")
                                        .font(.subheadline)
                                        .foregroundStyle(YasumidokiTheme.secondaryText)
                                }

                                Spacer(minLength: 0)
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
        .task(id: action.id) {
            await startCountdown()
        }
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.25), value: isFinished)
    }

    private var timerScene: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .stroke(YasumidokiTheme.butter.opacity(0.32), lineWidth: 13)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        YasumidokiTheme.sage,
                        style: StrokeStyle(lineWidth: 13, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(reduceMotion ? nil : .easeInOut(duration: 0.35), value: progress)

                VStack(spacing: 2) {
                    Text(isFinished ? "できました" : "あと")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(YasumidokiTheme.sage)

                    Text(isFinished ? "OK" : "\(remainingSeconds)秒")
                        .font(.system(size: 42, weight: .light, design: .rounded))
                        .lineLimit(1)
                        .minimumScaleFactor(0.72)
                        .foregroundStyle(YasumidokiTheme.primaryText)
                        .contentTransition(reduceMotion ? .identity : .numericText())
                }
            }
            .frame(width: 190, height: 190)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(isFinished ? "回復アクションが完了しました" : "残り\(remainingSeconds)秒")

            Image("HomeRoomIllustration")
                .resizable()
                .scaledToFill()
                .frame(width: 220, height: 88)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .strokeBorder(.white.opacity(0.62), lineWidth: 1)
                }
                .shadow(color: YasumidokiTheme.shadow.opacity(0.08), radius: 12, y: 6)
                .accessibilityHidden(true)
        }
        .frame(maxWidth: 220)
        .padding(.bottom, 4)
    }

    private func startCountdown() async {
        remainingSeconds = action.durationSeconds

        while remainingSeconds > 0 {
            do {
                try await Task.sleep(for: .seconds(1))
            } catch {
                return
            }

            remainingSeconds -= 1
        }
    }
}

#Preview {
    NavigationStack {
        RecoveryActionView(
            action: RecoveryCatalog.default.action(for: .informationFatigue),
            onComplete: {}
        )
    }
}
