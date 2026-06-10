import SwiftUI
import YasumidokiCore

struct HomeView: View {
    let companionState: CompanionState
    let onStartCheck: () -> Void
    let onOpenReflection: () -> Void
    @ScaledMetric(relativeTo: .largeTitle) private var heroHeight: CGFloat = 472
    private let messageBuilder = CompanionMessageBuilder()

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    HomeRoomHeroView(companionState: companionState)
                        .frame(height: heroHeight)

                    VStack(spacing: 16) {
                        SoftActionCard(
                            title: "今日のつかれを見てみる",
                            subtitle: messageBuilder.homeActionSubtitle(for: companionState),
                            systemImage: "camera.macro",
                            accent: YasumidokiTheme.sage,
                            isProminent: true,
                            action: onStartCheck
                        )

                        SoftActionCard(
                            title: "7日間をふりかえる",
                            subtitle: "疲れの流れを、軽くながめる",
                            systemImage: "calendar",
                            accent: YasumidokiTheme.honey,
                            action: onOpenReflection
                        )

                        QuietStatusPill(text: "今日はここまででOK")
                    }
                    .padding(.horizontal, YasumidokiTheme.contentPadding)
                    .padding(.top, -56)
                    .padding(.bottom, 24)
                }
                .frame(maxWidth: .infinity)
            }

            HomeShortcutDock(
                onStartCheck: onStartCheck,
                onOpenReflection: onOpenReflection
            )
            .padding(.horizontal, YasumidokiTheme.contentPadding)
            .padding(.top, 8)
            .padding(.bottom, 8)
        }
        .background(YasumidokiTheme.pageBackground.ignoresSafeArea())
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
