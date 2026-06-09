import SwiftUI

struct RoomBackdropView: View {
    var imageOpacity: Double = 0.48
    var blurRadius: CGFloat = 0

    var body: some View {
        GeometryReader { proxy in
            Image("HomeRoomIllustration")
                .resizable()
                .scaledToFill()
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipped()
                .blur(radius: blurRadius)
                .opacity(imageOpacity)
                .overlay(
                    LinearGradient(
                        colors: [
                            YasumidokiTheme.pageBackground.opacity(0.48),
                            YasumidokiTheme.pageBackground.opacity(0.72),
                            YasumidokiTheme.pageBackground.opacity(0.96)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .accessibilityHidden(true)
        }
    }
}

#Preview {
    RoomBackdropView()
}
