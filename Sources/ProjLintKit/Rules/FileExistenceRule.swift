import Foundation

struct FileExistenceRule: Rule {
    static let name = "File Existence"
    static let identifier = "file_existence"

    private let defaultViolationLevel = ViolationLevel.warning
    private let options: FileExistenceOptions

    init(_ optionsDict: [String: Any]) {
        options = FileExistenceOptions(optionsDict, rule: type(of: self))
    }

    func violations(in directory: URL) -> [Violation] {
        var violations = [Violation]()

        if let existingPaths = options.existingPaths {
            for path in existingPaths {
                if !FileManager.default.fileExists(atPath: path) {
                    violations.append(
                        FileViolation(
                            rule: self,
                            message: "Expected file to exist but didn't.",
                            level: options.violationLevel(defaultTo: defaultViolationLevel),
                            path: path
                        )
                    )
                }
            }
        }

        if let nonExistingPaths = options.nonExistingPaths {
            for path in nonExistingPaths {
                if FileManager.default.fileExists(atPath: path) {
                    violations.append(
                        FileViolation(
                            rule: self,
                            message: "Expected file not to exist but existed.",
                            level: options.violationLevel(defaultTo: defaultViolationLevel),
                            path: path
                        )
                    )
                }
            }
        }

        return violations
    }
}
