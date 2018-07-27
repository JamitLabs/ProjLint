import Foundation
import SwiftCLI

public class LintCommand: Command {
    // MARK: - Command
    public let name = "lint"
    public let shortDescription = "Lints the current directory and shows warnings and errors as console output"

    // MARK: - Initializers
    public init() {}

    // MARK: - Instance Methods
    public func execute() throws {
        print("Started linting current directory...", level: .info)
        let currentDirectoryUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let configuration = ConfigurationManager.loadConfiguration()

        guard !configuration.rules.isEmpty else {
            print("No rules found in configuration file. Nothing to lint.", level: .warning)
            exit(EX_USAGE)
        }

        var errorViolationsCount = 0
        var warningViolationsCount = 0

        configuration.rules.forEach { rule in
            let violations = rule.violations(
                in: currentDirectoryUrl,
                includedPaths: configuration.defaultOptions.includedPaths,
                excludedPaths: configuration.defaultOptions.excludedPaths
            )

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
                guard let lintFailLevel = configuration.defaultOptions.lintFailLevel else { return false }
                guard lintFailLevel != .warning else { return true }
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
