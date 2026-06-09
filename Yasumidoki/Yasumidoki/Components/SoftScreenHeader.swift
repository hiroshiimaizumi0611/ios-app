import SwiftUI

struct SoftScreenHeader: View {
    let title: String
    var showsBackButton = true

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        HStack(spacing: 12) {
            if showsBackButton {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(YasumidokiTheme.primaryText)
                        .frame(width: 52, height: 52)
                        .background(.white.opacity(0.74), in: Circle())
                        .shadow(color: YasumidokiTheme.shadow.opacity(0.08), radius: 12, y: 6)
                }
                .accessibilityLabel("戻る")
            } else {
                Color.clear
                    .frame(width: 52, height: 52)
            }

            Spacer(minLength: 8)

            HStack(spacing: 8) {
                Text(title)
                    .font(.system(.title2, design: .rounded).weight(.semibold))
                    .foregroundStyle(YasumidokiTheme.primaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)

                Image(systemName: "leaf.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(YasumidokiTheme.sage)
                    .accessibilityHidden(true)
            }
            .accessibilityElement(children: .combine)

            Spacer(minLength: 8)

            Color.clear
                .frame(width: 52, height: 52)
        }
        .padding(.horizontal, YasumidokiTheme.contentPadding)
        .padding(.top, 10)
    }
}

#Preview {
    SoftScreenHeader(title: "7日間のふりかえり")
        .background(YasumidokiTheme.pageBackground)
}
