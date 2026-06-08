import SwiftUI
import YasumidokiCore

struct ReflectionView: View {
    let summary: ReflectionSummary

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("7日間のふりかえり")
                        .font(.title.bold())
                        .foregroundStyle(YasumidokiTheme.primaryText)

                    Text("できたことも、できなかった日も、やさしく置いておきましょう。")
                        .font(.body)
                        .foregroundStyle(YasumidokiTheme.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }

                HStack(spacing: 12) {
                    ReflectionStatCard(title: "つかれ記録", value: "\(summary.checkCount)回")
                    ReflectionStatCard(title: "小さな回復", value: "\(summary.completionCount)回")
                }

                if let fatigueType = summary.mostCommonFatigueType {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("よく出ていたつかれ")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(YasumidokiTheme.secondaryText)

                        Text(fatigueType.displayName)
                            .font(.title3.bold())
                            .foregroundStyle(YasumidokiTheme.primaryText)
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(YasumidokiTheme.cardBackground, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                }

                Text(summary.companionMessage)
                    .font(.body)
                    .foregroundStyle(YasumidokiTheme.primaryText)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(YasumidokiTheme.butter.opacity(0.24), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            .padding(YasumidokiTheme.contentPadding)
        }
        .background(YasumidokiTheme.pageBackground)
        .navigationTitle("7日間")
        .navigationBarTitleDisplayMode(.inline)
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
