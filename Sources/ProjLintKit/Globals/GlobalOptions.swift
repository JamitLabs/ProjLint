import SwiftCLI

public enum GlobalOptions {
    static let verbose = Flag("-v", "--verbose", description: "Prints more detailed information about the executed command")

    public static var all: [Option] {
        return [verbose]
    }
}
