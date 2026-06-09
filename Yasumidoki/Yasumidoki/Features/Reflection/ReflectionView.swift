import SwiftUI
import YasumidokiCore

struct ReflectionView: View {
    let summary: ReflectionSummary

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            RoomBackdropView(imageOpacity: 0.20, blurRadius: 5)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                SoftScreenHeader(title: "7日間のふりかえり")

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        weekPanel

                        fatiguePanel

                        recoveryPanel

                        companionMessage

                        SoftPanel(horizontalPadding: 18, verticalPadding: 16, cornerRadius: 28) {
                            HStack(spacing: 16) {
                                SoftIconBubble(systemImage: "leaf", tint: YasumidokiTheme.butter, size: 64)

                                PrimaryButton("また明日", systemImage: "leaf") {
                                    dismiss()
                                }
                            }
                        }
                    }
                    .padding(.horizontal, YasumidokiTheme.contentPadding)
                    .padding(.bottom, 28)
                }
            }
        }
        .background(YasumidokiTheme.pageBackground)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
    }

    private var weekPanel: some View {
        SoftPanel(horizontalPadding: 18, verticalPadding: 20) {
            HStack(spacing: 8) {
                ForEach(Array(weekdayLabels.enumerated()), id: \.offset) { index, label in
                    VStack(spacing: 8) {
                        Text(label)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(YasumidokiTheme.secondaryText)

                        Image(systemName: "leaf")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(YasumidokiTheme.primaryText.opacity(0.58))
                            .frame(width: 36, height: 36)
                            .background(
                                Circle()
                                    .fill(index.isMultiple(of: 2) ? YasumidokiTheme.sage.opacity(0.22) : YasumidokiTheme.butter.opacity(0.36))
                            )
                            .accessibilityHidden(true)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("7日間のふりかえり")
        }
    }

    private var fatiguePanel: some View {
        SoftPanel(horizontalPadding: 18, verticalPadding: 22) {
            adaptiveStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 8) {
                        Text("よく出たつかれ")
                            .font(.system(.title3, design: .rounded).weight(.semibold))
                            .foregroundStyle(YasumidokiTheme.primaryText)

                        Image(systemName: "leaf.fill")
                            .foregroundStyle(YasumidokiTheme.sage)
                            .accessibilityHidden(true)
                    }

                    HStack(spacing: 12) {
                        SoftIconBubble(
                            systemImage: fatigueIconName,
                            tint: YasumidokiTheme.sage,
                            size: 62
                        )

                        VStack(alignment: .leading, spacing: 4) {
                            Text(primaryFatigueText)
                                .font(.headline)
                                .foregroundStyle(YasumidokiTheme.primaryText)
                                .fixedSize(horizontal: false, vertical: true)

                            Text("つかれ記録 \(summary.checkCount)回")
                                .font(.subheadline)
                                .foregroundStyle(YasumidokiTheme.secondaryText)
                        }

                        Spacer(minLength: 0)
                    }
                }

                Image("HomeRoomIllustration")
                    .resizable()
                    .scaledToFill()
                    .frame(width: dynamicTypeSize.isAccessibilitySize ? nil : 148, height: dynamicTypeSize.isAccessibilitySize ? 160 : 178)
                    .frame(maxWidth: dynamicTypeSize.isAccessibilitySize ? .infinity : nil)
                    .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 26, style: .continuous)
                            .strokeBorder(.white.opacity(0.62), lineWidth: 1)
                    }
                    .accessibilityHidden(true)
            }
        }
    }

    private var recoveryPanel: some View {
        SoftPanel(horizontalPadding: 18, verticalPadding: 20) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Text("効いたひと息")
                        .font(.system(.title3, design: .rounded).weight(.semibold))
                        .foregroundStyle(YasumidokiTheme.primaryText)

                    Image(systemName: "leaf.fill")
                        .foregroundStyle(YasumidokiTheme.sage)
                        .accessibilityHidden(true)
                }

                HStack(spacing: 12) {
                    ReflectionStatCard(title: "小さな回復", value: "\(summary.completionCount)回", systemImage: "eye")

                    ReflectionStatCard(title: "見た期間", value: "\(summary.daysIncluded)日", systemImage: "calendar")
                }
            }
        }
    }

    private var companionMessage: some View {
        Text(summary.companionMessage)
            .font(.body.weight(.medium))
            .multilineTextAlignment(.center)
            .foregroundStyle(YasumidokiTheme.primaryText)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 20)
            .padding(.vertical, 22)
            .frame(maxWidth: .infinity)
            .overlay {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(
                        YasumidokiTheme.butter.opacity(0.82),
                        style: StrokeStyle(lineWidth: 1.2, dash: [6, 8])
                    )
            }
            .background(YasumidokiTheme.cardBackground.opacity(0.38), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var primaryFatigueText: String {
        summary.mostCommonFatigueType?.displayName ?? "まだ記録なし"
    }

    private var fatigueIconName: String {
        switch summary.mostCommonFatigueType {
        case .vagueDepletion:
            "leaf"
        case .comparisonFatigue:
            "scalemass"
        case .informationFatigue:
            "info.circle"
        case .unconsciousScrolling:
            "iphone"
        case .doNotWantAnything:
            "cloud"
        case nil:
            "leaf"
        }
    }

    private var weekdayLabels: [String] {
        ["月", "火", "水", "木", "金", "土", "日"]
    }

    @ViewBuilder
    private func adaptiveStack<Content: View>(
        spacing: CGFloat,
        @ViewBuilder content: () -> Content
    ) -> some View {
        if dynamicTypeSize.isAccessibilitySize {
            VStack(alignment: .leading, spacing: spacing, content: content)
        } else {
            HStack(alignment: .center, spacing: spacing, content: content)
        }
    }
}

#Preview {
    NavigationStack {
        ReflectionView(
            summary: ReflectionSummary(
                daysIncluded: 7,
                checkCount: 3,
                completionCount: 2,
                mostCommonFatigueType: .informationFatigue,
                companionMessage: "この7日間もおつかれさまでした。できない日があっても大丈夫。"
            )
        )
    }
}
