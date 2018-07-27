import Foundation

enum ViolationLevel {
    case warning
    case error

    var printLevel: PrintLevel {
        switch self {
        case .error:
            return .error

        case .warning:
            return .warning
        }
    }
}
