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

enum OutputFormatTarget {
    case human
    case xcode
}

var outputFormatTarget: OutputFormatTarget = .human

func print(_ message: String, level: PrintLevel, file: String? = nil, line: Int? = nil) {
    switch outputFormatTarget {
    case .human:
        humanPrint(message, file: file, line: line, level: level)

    case .xcode:
        xcodePrint(message, file: file, line: line, level: level)
    }
}

private func humanPrint(_ message: String, file: String? = nil, line: Int? = nil, level: PrintLevel) {
    let location = locationInfo(file: file, line: line)
    let message = location != nil ? [location!, message].joined(separator: " ") : message

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

private func xcodePrint(_ message: String, file: String? = nil, line: Int? = nil, level: PrintLevel) {
    let location = locationInfo(file: file, line: line)

    switch level {
    case .verbose:
        if GlobalOptions.verbose.value {
            if let location = location {
                print(location, "verbose: ProjLint: ", message)
            } else {
                print("verbose: ProjLint: ", message)
            }
        }

    case .info:
        if let location = location {
            print(location, "info: ProjLint: ", message)
        } else {
            print("info: ProjLint: ", message)
        }


    case .warning:
        if let location = location {
            print(location, "warning: ProjLint: ", message)
        } else {
            print("warning: ProjLint: ", message)
        }


    case .error:
        if let location = location {
            print(location, "error: ProjLint: ", message)
        } else {
            print("error: ProjLint: ", message)
        }

    }
}

private func locationInfo(file: String?, line: Int?) -> String? {
    guard let file = file else { return nil }
    guard let line = line else { return "\(file): " }
    return "\(file):\(line): "
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
