import SwiftUI

struct PrimaryButton: View {
    let title: String
    let systemImage: String?
    let action: () -> Void

    init(
        _ title: String,
        systemImage: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            if let systemImage {
                Label(title, systemImage: systemImage)
                    .frame(maxWidth: .infinity)
            } else {
                Text(title)
                    .frame(maxWidth: .infinity)
            }
        }
        .font(.headline)
        .lineLimit(2)
        .multilineTextAlignment(.center)
        .foregroundStyle(.white)
        .frame(minHeight: 56)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.vertical, 12)
        .padding(.horizontal, 18)
        .background(YasumidokiTheme.sage, in: Capsule())
        .shadow(color: YasumidokiTheme.shadow.opacity(0.12), radius: 16, y: 8)
        .contentShape(Capsule())
    }
}

#Preview {
    PrimaryButton("今日のつかれを見る", systemImage: "leaf") {}
        .padding()
}
