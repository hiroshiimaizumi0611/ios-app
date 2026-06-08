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

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            VStack(alignment: .leading, spacing: 8) {
                Text(action.title)
                    .font(.title.bold())
                    .foregroundStyle(YasumidokiTheme.primaryText)
                    .fixedSize(horizontal: false, vertical: true)

                Text(action.prompt)
                    .font(.body)
                    .foregroundStyle(YasumidokiTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            ZStack {
                Circle()
                    .fill(YasumidokiTheme.butter.opacity(0.34))
                    .frame(width: 190, height: 190)

                Circle()
                    .stroke(YasumidokiTheme.sage.opacity(0.20), lineWidth: 12)
                    .frame(width: 160, height: 160)

                Text(isFinished ? "できました" : "あと \(remainingSeconds)秒")
                    .font(.title2.bold())
                    .foregroundStyle(YasumidokiTheme.primaryText)
                    .contentTransition(reduceMotion ? .identity : .numericText())
            }
            .frame(maxWidth: .infinity)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(isFinished ? "回復アクションが完了しました" : "残り\(remainingSeconds)秒")

            Text("タイマーが終わるまで、画面を見続けなくて大丈夫です。")
                .font(.footnote)
                .foregroundStyle(YasumidokiTheme.secondaryText)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()

            if isFinished {
                PrimaryButton("できた", systemImage: "checkmark", action: onComplete)
                    .transition(reduceMotion ? .opacity : .scale.combined(with: .opacity))
            }
        }
        .padding(YasumidokiTheme.contentPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(YasumidokiTheme.pageBackground)
        .navigationTitle("小さな回復")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: action.id) {
            await startCountdown()
        }
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.25), value: isFinished)
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
