import SwiftUI
import YasumidokiCore

struct HomeRoomHeroView: View {
    let companionState: CompanionState

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                Image("HomeRoomIllustration")
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
                    .accessibilityHidden(true)

                LinearGradient(
                    colors: [
                        YasumidokiTheme.pageBackground.opacity(0.1),
                        .clear,
                        YasumidokiTheme.pageBackground.opacity(0.96)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Text("やすみどき")
                            .font(.system(.largeTitle, design: .rounded).weight(.semibold))
                            .foregroundStyle(YasumidokiTheme.primaryText)
                            .lineLimit(1)
                            .minimumScaleFactor(0.72)

                        Image(systemName: "leaf.fill")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(YasumidokiTheme.sage)
                            .accessibilityHidden(true)
                    }

                    Text(greeting)
                        .font(.headline)
                        .foregroundStyle(YasumidokiTheme.secondaryText)

                    Text(todayText)
                        .font(.title3.weight(.medium))
                        .foregroundStyle(YasumidokiTheme.primaryText)
                }
                .padding(.top, 52)
                .padding(.horizontal, 24)
                .shadow(color: .white.opacity(0.72), radius: 10)
                .accessibilityElement(children: .combine)
            }
        }
    }

    private var greeting: String {
        companionState.growthLevel > 0 ? "相棒がそばで休んでいます" : "おかえりなさい"
    }

    private var todayText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "M月d日（E）"
        return formatter.string(from: Date())
    }
}

#Preview {
    HomeRoomHeroView(companionState: CompanionState(growthLevel: 1, unlockedItems: ["lamp"]))
        .frame(height: 560)
}
