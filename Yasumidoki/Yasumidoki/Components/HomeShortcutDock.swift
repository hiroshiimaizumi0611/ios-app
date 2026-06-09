import SwiftUI

struct HomeShortcutDock: View {
    let onStartCheck: () -> Void
    let onOpenReflection: () -> Void

    var body: some View {
        HStack(spacing: 6) {
            currentItem

            shortcutButton(
                title: "チェック",
                systemImage: "leaf.fill",
                action: onStartCheck
            )

            shortcutButton(
                title: "ふりかえり",
                systemImage: "calendar",
                action: onOpenReflection
            )
        }
        .padding(8)
        .background(YasumidokiTheme.cardBackground.opacity(0.96), in: Capsule())
        .overlay {
            Capsule()
                .stroke(.white.opacity(0.58), lineWidth: 1)
        }
        .shadow(color: YasumidokiTheme.shadow.opacity(0.16), radius: 22, y: 10)
        .accessibilityElement(children: .contain)
    }

    private var currentItem: some View {
        VStack(spacing: 4) {
            Image(systemName: "house.fill")
                .font(.headline.weight(.semibold))

            Text("ホーム")
                .font(.caption2.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 54)
        .background(YasumidokiTheme.sage, in: Capsule())
        .accessibilityLabel("ホーム、現在の画面")
    }

    private func shortcutButton(
        title: String,
        systemImage: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.headline.weight(.semibold))

                Text(title)
                    .font(.caption2.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .foregroundStyle(YasumidokiTheme.primaryText.opacity(0.72))
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}

#Preview {
    HomeShortcutDock(onStartCheck: {}, onOpenReflection: {})
        .padding()
        .background(YasumidokiTheme.pageBackground)
}
