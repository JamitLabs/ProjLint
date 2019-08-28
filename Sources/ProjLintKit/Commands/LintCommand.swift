import Foundation
import SwiftCLI

public class LintCommand: Command {
    // MARK: - Command
    public let name: String = "lint"
    public let shortDescription: String = "Lints the current directory and shows warnings and errors as console output"

    public let xcode = Flag("-x", "--xcode", description: "Output are done in a format that is compatible with Xcode")
    public let timeout = Key<Double>("-t", "--timeout", description: "Seconds to wait for network requests until skipped")
    public let ignoreNetworkErrors = Flag("-i", "--ignore-network-errors", description: "Ignores network timeouts or missing network connection errors")
    public let strict = Flag("-s", "--strict", description: "Exit with non-zero status if any issue is found")

    // MARK: - Initializers
    public init() {}

    // MARK: - Instance Methods
    public func execute() throws {
        if xcode.value {
            Globals.outputFormatTarget = .xcode
        }

        if let timeout = timeout.value {
            Globals.timeout = timeout
        }

        if ignoreNetworkErrors.value {
            Globals.ignoreNetworkErrors = true
        }

        print("Started linting current directory...", level: .info)
        let configuration = ConfigurationManager.loadConfiguration()

        guard !configuration.rules.isEmpty else {
            print("No rules found in configuration file. Nothing to lint.", level: .warning)
            exit(EX_USAGE)
        }

        var errorViolationsCount = 0
        var warningViolationsCount = 0

        configuration.rules.forEach { rule in
            let violations = rule.violations(in: FileManager.default.currentDirectoryUrl)

            for violation in violations {
                violation.logViolation()

                if violation.level == .error {
                    errorViolationsCount += 1
                } else {
                    warningViolationsCount += 1
                }
            }
        }

        let allViolationsCount = warningViolationsCount + errorViolationsCount
        guard allViolationsCount <= 0 else {
            let printLevel: PrintLevel = errorViolationsCount > 0 ? .error : .warning
            print("Linting failed with \(errorViolationsCount) errors and \(warningViolationsCount) warnings in current directory.", level: printLevel)

            let shouldFail: Bool = {
                guard !strict.value else { return true }
                return errorViolationsCount > 0
            }()

            if shouldFail {
                exit(EXIT_FAILURE)
            } else {
                exit(EXIT_SUCCESS)
            }
        }

        print("Successfully linted current directory. No violations found.", level: .info)
    }
}
