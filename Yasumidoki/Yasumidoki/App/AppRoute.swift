import Foundation
import YasumidokiCore

enum AppRoute: Hashable {
    case fatigueCheck
    case recoveryAction(FatigueType)
    case recoveryComplete
    case reflection
}
