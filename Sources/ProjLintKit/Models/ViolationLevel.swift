import Foundation

enum ViolationLevel: String {
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
