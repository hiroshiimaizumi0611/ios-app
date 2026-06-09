import SwiftUI

struct SoftActionCard: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let accent: Color
    let isProminent: Bool
    let action: () -> Void

    init(
        title: String,
        subtitle: String,
        systemImage: String,
        accent: Color,
        isProminent: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.accent = accent
        self.isProminent = isProminent
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(accent.opacity(0.18))

                    Image(systemName: systemImage)
                        .font(.title3.weight(.medium))
                        .foregroundStyle(accent)
                }
                .frame(width: 66, height: 66)
                .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(YasumidokiTheme.primaryText)
                        .lineLimit(2)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(YasumidokiTheme.secondaryText)
                        .lineLimit(2)
                }
                .multilineTextAlignment(.leading)

                Spacer(minLength: 8)

                ZStack {
                    Circle()
                        .fill(YasumidokiTheme.butter.opacity(isProminent ? 0.45 : 0.28))

                    Image(systemName: "chevron.right")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(YasumidokiTheme.primaryText.opacity(0.62))
                }
                .frame(width: 44, height: 44)
                .accessibilityHidden(true)
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(cardFill, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(YasumidokiTheme.cardStroke, lineWidth: 1)
            }
            .shadow(color: YasumidokiTheme.shadow.opacity(isProminent ? 0.2 : 0.12), radius: 18, y: 10)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityHint(subtitle)
    }

    private var cardFill: Color {
        isProminent ? YasumidokiTheme.cardBackground : YasumidokiTheme.sage.opacity(0.14)
    }
}

#Preview {
    SoftActionCard(
        title: "今日のつかれを見てみる",
        subtitle: "ひとつ選ぶだけでOK",
        systemImage: "camera.macro",
        accent: YasumidokiTheme.sage,
        isProminent: true
    ) {}
    .padding()
    .background(YasumidokiTheme.pageBackground)
}
