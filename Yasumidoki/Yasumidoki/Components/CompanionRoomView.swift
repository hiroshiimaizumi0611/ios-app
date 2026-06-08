import SwiftUI
import YasumidokiCore

struct CompanionRoomView: View {
    let companionState: CompanionState

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isBreathing = false

    private var hasLamp: Bool {
        companionState.unlockedItems.contains("lamp") || companionState.growthLevel > 0
    }

    private var hasPlant: Bool {
        companionState.unlockedItems.contains("plant") || companionState.growthLevel > 2
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: YasumidokiTheme.cornerRadius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            YasumidokiTheme.butter.opacity(0.42),
                            YasumidokiTheme.peach.opacity(0.32),
                            YasumidokiTheme.sky.opacity(0.22)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            RoundedRectangle(cornerRadius: YasumidokiTheme.cornerRadius, style: .continuous)
                .strokeBorder(.white.opacity(0.42), lineWidth: 1)

            Circle()
                .fill(YasumidokiTheme.sky.opacity(0.24))
                .frame(width: 96, height: 96)
                .overlay(
                    Circle()
                        .stroke(.white.opacity(0.55), lineWidth: 8)
                )
                .offset(x: 70, y: -70)

            if hasLamp {
                Circle()
                    .fill(YasumidokiTheme.butter.opacity(reduceMotion ? 0.65 : (isBreathing ? 0.82 : 0.55)))
                    .frame(width: 70, height: 70)
                    .blur(radius: 12)
                    .offset(x: -92, y: -48)

                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(YasumidokiTheme.butter.opacity(0.78))
                    .frame(width: 42, height: 54)
                    .overlay(alignment: .bottom) {
                        Capsule()
                            .fill(YasumidokiTheme.moss.opacity(0.42))
                            .frame(width: 18, height: 16)
                            .offset(y: 8)
                    }
                    .offset(x: -96, y: -46)
            }

            if hasPlant {
                Capsule()
                    .fill(YasumidokiTheme.moss.opacity(0.86))
                    .frame(width: 18, height: 42)
                    .rotationEffect(.degrees(-28))
                    .offset(x: 96, y: 58)

                Capsule()
                    .fill(YasumidokiTheme.sage.opacity(0.86))
                    .frame(width: 18, height: 42)
                    .rotationEffect(.degrees(24))
                    .offset(x: 116, y: 58)
            }

            Capsule()
                .fill(YasumidokiTheme.peach.opacity(0.20))
                .frame(width: 148, height: 22)
                .offset(y: 78)

            Circle()
                .fill(.white.opacity(0.95))
                .frame(width: 118, height: 118)
                .scaleEffect(reduceMotion ? 1 : (isBreathing ? 1.025 : 0.985))
                .shadow(color: .black.opacity(0.08), radius: 18, y: 10)
                .overlay(alignment: .top) {
                    HStack(spacing: 28) {
                        Circle()
                            .fill(YasumidokiTheme.primaryText.opacity(0.72))
                            .frame(width: 10, height: 10)
                        Circle()
                            .fill(YasumidokiTheme.primaryText.opacity(0.72))
                            .frame(width: 10, height: 10)
                    }
                    .offset(y: 44)
                }
                .overlay(alignment: .bottom) {
                    Capsule()
                        .fill(YasumidokiTheme.peach.opacity(0.42))
                        .frame(width: 28, height: 8)
                        .offset(y: -34)
                }

            Circle()
                .fill(YasumidokiTheme.peach.opacity(0.82))
                .frame(width: 28, height: 28)
                .offset(x: -56, y: 8)

            Circle()
                .fill(YasumidokiTheme.peach.opacity(0.82))
                .frame(width: 28, height: 28)
                .offset(x: 56, y: 8)
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1.15, contentMode: .fit)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("やすみどきの相棒が部屋で休んでいます")
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true)) {
                isBreathing = true
            }
        }
    }
}

#Preview {
    CompanionRoomView(
        companionState: CompanionState(growthLevel: 1, unlockedItems: ["lamp"])
    )
    .padding()
}
