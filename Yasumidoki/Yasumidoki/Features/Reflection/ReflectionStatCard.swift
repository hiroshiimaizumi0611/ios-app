import SwiftUI

struct ReflectionStatCard: View {
    let title: String
    let value: String
    let systemImage: String

    init(title: String, value: String, systemImage: String = "leaf") {
        self.title = title
        self.value = value
        self.systemImage = systemImage
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SoftIconBubble(systemImage: systemImage, tint: YasumidokiTheme.butter, size: 48)

            Text(title)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(YasumidokiTheme.secondaryText)

            Text(value)
                .font(.title2.bold())
                .foregroundStyle(YasumidokiTheme.primaryText)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(YasumidokiTheme.elevatedBackground.opacity(0.76), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(.white.opacity(0.62), lineWidth: 1)
        }
    }
}

#Preview {
    ReflectionStatCard(title: "つかれ記録", value: "3回")
        .padding()
}
