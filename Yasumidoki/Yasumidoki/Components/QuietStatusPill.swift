import SwiftUI

struct QuietStatusPill: View {
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.body.weight(.medium))
                .foregroundStyle(YasumidokiTheme.honey)
                .accessibilityHidden(true)

            Text(text)
                .font(.headline)
                .foregroundStyle(YasumidokiTheme.primaryText)
                .lineLimit(2)
                .multilineTextAlignment(.center)

            Image(systemName: "leaf.fill")
                .font(.body.weight(.medium))
                .foregroundStyle(YasumidokiTheme.sage)
                .accessibilityHidden(true)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .padding(.horizontal, 20)
        .background(YasumidokiTheme.elevatedBackground.opacity(0.66), in: Capsule())
        .overlay {
            Capsule()
                .stroke(
                    YasumidokiTheme.sage.opacity(0.32),
                    style: StrokeStyle(lineWidth: 1, dash: [6, 7], dashPhase: 2)
                )
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    QuietStatusPill(text: "今日はここまででOK")
        .padding()
        .background(YasumidokiTheme.pageBackground)
}
