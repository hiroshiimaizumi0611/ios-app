import SwiftUI
import YasumidokiCore

struct FatigueCheckView: View {
    let onContinue: (FatigueType, String?) async -> Void

    @State private var selectedFatigueType: FatigueType?
    @State private var memo = ""
    @State private var isSaving = false

    var body: some View {
        ZStack {
            RoomBackdropView(imageOpacity: 0.50, blurRadius: 2)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                SoftScreenHeader(title: "やすみどき")

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        SoftPanel(horizontalPadding: 18, verticalPadding: 28) {
                            VStack(spacing: 22) {
                                VStack(spacing: 10) {
                                    Image(systemName: "leaf.fill")
                                        .font(.title3.weight(.semibold))
                                        .foregroundStyle(YasumidokiTheme.sage)
                                        .accessibilityHidden(true)

                                    Text("いまのつかれは？")
                                        .font(.system(.title2, design: .rounded).weight(.semibold))
                                        .foregroundStyle(YasumidokiTheme.primaryText)

                                    Text("正確に選ばなくて大丈夫。いま近いものをひとつだけ。")
                                        .font(.subheadline)
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(YasumidokiTheme.secondaryText)
                                        .fixedSize(horizontal: false, vertical: true)
                                }

                                VStack(spacing: 12) {
                                    ForEach(FatigueType.allCases) { fatigueType in
                                        fatigueButton(for: fatigueType)
                                    }
                                }
                            }
                        }

                        SoftPanel(horizontalPadding: 18, verticalPadding: 16, cornerRadius: 26) {
                            HStack(alignment: .top, spacing: 14) {
                                SoftIconBubble(systemImage: "pencil", tint: YasumidokiTheme.peach, size: 54)

                                TextField("ひとことメモ（任意）", text: $memo, axis: .vertical)
                                    .font(.body)
                                    .foregroundStyle(YasumidokiTheme.primaryText)
                                    .lineLimit(2...4)
                            }
                        }

                        PrimaryButton(isSaving ? "保存しています" : "相棒に伝える", systemImage: "sparkle") {
                            continueToRecovery()
                        }
                        .disabled(selectedFatigueType == nil || isSaving)
                        .opacity(selectedFatigueType == nil || isSaving ? 0.48 : 1)
                        .padding(.horizontal, 26)
                        .padding(.bottom, 28)
                    }
                    .padding(.horizontal, YasumidokiTheme.contentPadding)
                }
            }
        }
        .background(YasumidokiTheme.pageBackground)
        .scrollDismissesKeyboard(.interactively)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
    }

    private func continueToRecovery() {
        guard let selectedFatigueType else { return }
        isSaving = true

        Task {
            await onContinue(selectedFatigueType, memo)
            isSaving = false
        }
    }

    private func fatigueButton(for fatigueType: FatigueType) -> some View {
        let isSelected = selectedFatigueType == fatigueType

        return Button {
            selectedFatigueType = fatigueType
        } label: {
            HStack(spacing: 14) {
                SoftIconBubble(
                    systemImage: iconName(for: fatigueType),
                    tint: bubbleTint(for: fatigueType),
                    size: 62
                )

                Text(fatigueType.displayName)
                    .font(.headline)
                    .foregroundStyle(YasumidokiTheme.primaryText)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 12)

                Image(systemName: isSelected ? "checkmark.circle.fill" : "chevron.right")
                    .font(.title3.weight(.medium))
                    .foregroundStyle(isSelected ? YasumidokiTheme.sage : YasumidokiTheme.secondaryText.opacity(0.62))
                    .accessibilityHidden(true)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
            .frame(minHeight: 78)
            .background(
                isSelected ? YasumidokiTheme.butter.opacity(0.36) : YasumidokiTheme.elevatedBackground.opacity(0.78),
                in: RoundedRectangle(cornerRadius: 24, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .strokeBorder(isSelected ? YasumidokiTheme.sage.opacity(0.32) : .white.opacity(0.6), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(fatigueType.displayName)を選択")
        .accessibilityValue(isSelected ? "選択中" : "未選択")
    }

    private func iconName(for fatigueType: FatigueType) -> String {
        switch fatigueType {
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
        }
    }

    private func bubbleTint(for fatigueType: FatigueType) -> Color {
        switch fatigueType {
        case .vagueDepletion, .doNotWantAnything:
            YasumidokiTheme.sage
        case .comparisonFatigue:
            YasumidokiTheme.peach
        case .informationFatigue, .unconsciousScrolling:
            YasumidokiTheme.honey
        }
    }
}

#Preview {
    NavigationStack {
        FatigueCheckView { _, _ in }
    }
}
