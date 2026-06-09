import SwiftUI

struct SoftIconBubble: View {
    let systemImage: String
    var tint = YasumidokiTheme.sage
    var size: CGFloat = 64

    var body: some View {
        Image(systemName: systemImage)
            .font(.title3.weight(.medium))
            .foregroundStyle(YasumidokiTheme.primaryText.opacity(0.68))
            .frame(width: size, height: size)
            .background(
                Circle()
                    .fill(tint.opacity(0.24))
            )
            .overlay {
                Circle()
                    .strokeBorder(.white.opacity(0.72), lineWidth: 1)
            }
            .accessibilityHidden(true)
    }
}

#Preview {
    HStack {
        SoftIconBubble(systemImage: "leaf")
        SoftIconBubble(systemImage: "cup.and.saucer", tint: YasumidokiTheme.honey)
    }
    .padding()
    .background(YasumidokiTheme.pageBackground)
}
