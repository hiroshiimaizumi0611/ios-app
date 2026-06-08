import SwiftUI
import YasumidokiCore

struct FatigueCheckView: View {
    let onContinue: (FatigueType, String?) async -> Void

    @State private var selectedFatigueType: FatigueType?
    @State private var memo = ""
    @State private var isSaving = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("いま近いものをひとつ")
                        .font(.title.bold())
                        .foregroundStyle(YasumidokiTheme.primaryText)

                    Text("正確に選ばなくて大丈夫。あとで変えたくなっても、それでOKです。")
                        .font(.body)
                        .foregroundStyle(YasumidokiTheme.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }

                VStack(spacing: 10) {
                    ForEach(FatigueType.allCases) { fatigueType in
                        Button {
                            selectedFatigueType = fatigueType
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: iconName(for: fatigueType))
                                    .font(.headline)
                                    .foregroundStyle(YasumidokiTheme.sage)
                                    .frame(width: 28)

                                Text(fatigueType.displayName)
                                    .font(.headline)
                                    .foregroundStyle(YasumidokiTheme.primaryText)

                                Spacer()

                                Image(systemName: selectedFatigueType == fatigueType ? "checkmark.circle.fill" : "circle")
                                    .font(.title3)
                                    .foregroundStyle(selectedFatigueType == fatigueType ? YasumidokiTheme.sage : YasumidokiTheme.secondaryText)
                            }
                            .padding(16)
                            .frame(minHeight: 58)
                            .background(
                                selectedFatigueType == fatigueType ? YasumidokiTheme.butter.opacity(0.30) : YasumidokiTheme.cardBackground,
                                in: RoundedRectangle(cornerRadius: 18, style: .continuous)
                            )
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("\(fatigueType.displayName)を選択")
                        .accessibilityValue(selectedFatigueType == fatigueType ? "選択中" : "未選択")
                    }
                }

                TextField("ひとことメモ（任意）", text: $memo, axis: .vertical)
                    .font(.body)
                    .lineLimit(2...4)
                    .padding(14)
                    .background(YasumidokiTheme.cardBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))

                PrimaryButton(isSaving ? "保存しています" : "小さな回復へ", systemImage: "arrow.right") {
                    continueToRecovery()
                }
                .disabled(selectedFatigueType == nil || isSaving)
                .opacity(selectedFatigueType == nil || isSaving ? 0.48 : 1)
            }
            .padding(YasumidokiTheme.contentPadding)
        }
        .background(YasumidokiTheme.pageBackground)
        .navigationTitle("つかれチェック")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func continueToRecovery() {
        guard let selectedFatigueType else { return }
        isSaving = true

        Task {
            await onContinue(selectedFatigueType, memo)
            isSaving = false
        }
    }

    private func iconName(for fatigueType: FatigueType) -> String {
        switch fatigueType {
        case .vagueDepletion:
            "cloud"
        case .comparisonFatigue:
            "person.2"
        case .informationFatigue:
            "text.page"
        case .unconsciousScrolling:
            "hand.tap"
        case .doNotWantAnything:
            "cup.and.saucer"
        }
    }
}

#Preview {
    NavigationStack {
        FatigueCheckView { _, _ in }
    }
}
