public struct YasumidokiSnapshot: Codable, Equatable, Sendable {
    public var checks: [FatigueCheck]
    public var completions: [RecoveryCompletion]
    public var companionState: CompanionState

    public init(
        checks: [FatigueCheck] = [],
        completions: [RecoveryCompletion] = [],
        companionState: CompanionState = CompanionState()
    ) {
        self.checks = checks
        self.completions = completions
        self.companionState = companionState
    }
}
