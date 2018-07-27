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
        // TODO: not yet implemented
    }
}
