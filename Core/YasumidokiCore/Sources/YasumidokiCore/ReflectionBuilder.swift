import Foundation

public struct ReflectionBuilder: Sendable {
    public init() {}

    public func summary(snapshot: YasumidokiSnapshot, now: Date = Date()) -> ReflectionSummary {
        let startOfToday = Calendar.current.startOfDay(for: now)
        let start = Calendar.current.date(byAdding: .day, value: -6, to: startOfToday) ?? now
        let recentChecks = snapshot.checks.filter { $0.createdAt >= start && $0.createdAt <= now }
        let recentCompletions = snapshot.completions.filter { $0.completedAt >= start && $0.completedAt <= now }
        let mostCommon = recentChecks
            .reduce(into: [FatigueType: Int]()) { counts, check in
                counts[check.fatigueType, default: 0] += 1
            }
            .max { $0.value < $1.value }?
            .key

        let message: String
        if recentChecks.isEmpty {
            message = "記録がない日も、休むための時間です。できない日があっても大丈夫。"
        } else {
            message = "この7日間もおつかれさまでした。できない日があっても大丈夫。"
        }

        return ReflectionSummary(
            daysIncluded: 7,
            checkCount: recentChecks.count,
            completionCount: recentCompletions.count,
            mostCommonFatigueType: mostCommon,
            companionMessage: message
        )
    }
}
