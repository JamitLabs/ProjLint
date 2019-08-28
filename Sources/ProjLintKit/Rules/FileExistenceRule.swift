import Foundation

struct FileExistenceRule: Rule {
    static let name: String = "File Existence"
    static let identifier: String = "file_existence"

    private let defaultViolationLevel: ViolationLevel = .warning
    private let options: FileExistenceOptions

    init(_ optionsDict: [String: Any]) {
        options = FileExistenceOptions(optionsDict, rule: type(of: self))
    }

    func violations(in directory: URL) -> [Violation] {
        var violations = [Violation]()

        if let existingPaths = options.existingPaths {
            for path in existingPaths {
                let url = URL(fileURLWithPath: path, relativeTo: directory)
                if !FileManager.default.fileExists(atPath: url.path) {
                    violations.append(
                        FileViolation(
                            rule: self,
                            message: "Expected file to exist but didn't.",
                            level: options.violationLevel(defaultTo: defaultViolationLevel),
                            url: url
                        )
                    )
                }
            }
        }

        if let nonExistingPaths = options.nonExistingPaths {
            for path in nonExistingPaths {
                let url = URL(fileURLWithPath: path, relativeTo: directory)
                if FileManager.default.fileExists(atPath: url.path) {
                    violations.append(
                        FileViolation(
                            rule: self,
                            message: "Expected file not to exist but existed.",
                            level: options.violationLevel(defaultTo: defaultViolationLevel),
                            url: url
                        )
                    )
                }
            }
        }

        return violations
    }
}
