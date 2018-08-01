import CLISpinner
import Foundation
import Rainbow

// swiftlint:disable leveled_print

enum PrintLevel {
    case verbose
    case info
    case warning
    case error

    var color: Color {
        switch self {
        case .verbose:
            return Color.lightCyan

        case .info:
            return Color.lightBlue

        case .warning:
            return Color.yellow

        case .error:
            return Color.red
        }
    }
}

func print(_ message: String, level: PrintLevel) {
    switch level {
    case .verbose:
        if GlobalOptions.verbose.value {
            print("🗣 ", message.lightCyan)
        }

    case .info:
        print("ℹ️ ", message.lightBlue)

    case .warning:
        print("⚠️ Warning: ", message.yellow)

    case .error:
        print("❌ Error: ", message.red)
    }
}

private let dispatchGroup = DispatchGroup()

func performWithSpinner(
    _ message: String,
    level: PrintLevel = .info,
    pattern: CLISpinner.Pattern = .dots,
    _ body: @escaping (@escaping (() -> Void) -> Void) -> Void
) {
    let spinner = Spinner(pattern: pattern, text: message, color: level.color)
    spinner.start()
    spinner.unhideCursor()

    dispatchGroup.enter()
    body { completion in
        spinner.stopAndClear()
        completion()
        dispatchGroup.leave()
    }

    dispatchGroup.wait()
}
