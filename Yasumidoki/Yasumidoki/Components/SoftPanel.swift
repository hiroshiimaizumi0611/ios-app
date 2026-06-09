import SwiftUI

struct SoftPanel<Content: View>: View {
    private let horizontalPadding: CGFloat
    private let verticalPadding: CGFloat
    private let cornerRadius: CGFloat
    private let content: Content

    init(
        horizontalPadding: CGFloat = 20,
        verticalPadding: CGFloat = 20,
        cornerRadius: CGFloat = YasumidokiTheme.largeCornerRadius,
        @ViewBuilder content: () -> Content
    ) {
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    var body: some View {
        content
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(
                YasumidokiTheme.cardBackground.opacity(0.94),
                in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(YasumidokiTheme.cardStroke, lineWidth: 1)
            }
            .shadow(color: YasumidokiTheme.shadow.opacity(0.08), radius: 24, y: 14)
    }
}

#Preview {
    SoftPanel {
        Text("今日はここまででOK")
            .font(.headline)
            .foregroundStyle(YasumidokiTheme.primaryText)
    }
    .padding()
    .background(YasumidokiTheme.pageBackground)
}
