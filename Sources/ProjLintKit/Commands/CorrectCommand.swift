import Foundation
import SwiftCLI

public class CorrectCommand: Command {
    // MARK: - Command
    public let name = "correct"
    public let shortDescription = "Corrects all correctable violations in the current directory"

    // MARK: - Initializers
    public init() {}

    // MARK: - Instance Methods
    public func execute() throws {
        print("Started correcting violations in current directory...", level: .info)
        // TODO: not yet implemented
    }
}
