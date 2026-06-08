import SwiftUI

struct ReflectionStatCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(YasumidokiTheme.secondaryText)

            Text(value)
                .font(.title2.bold())
                .foregroundStyle(YasumidokiTheme.primaryText)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(YasumidokiTheme.cardBackground, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#Preview {
    ReflectionStatCard(title: "つかれ記録", value: "3回")
        .padding()
}
