import Foundation
import HandySwift

class FileExistenceOptions: RuleOptions {
    let filePaths: [String]

    override init(_ optionsDict: [String: Any]) {
        guard let filePaths = optionsDict["paths"] as? [String] else {
            print("Rule \(FileExistenceRule.identifier) must have option `paths` specified.", level: .error)
            exit(EX_USAGE)
        }

        self.filePaths = filePaths

        super.init(optionsDict)
    }
}

struct FileExistenceRule: Rule {
    static let name = "File Existence"
    static let identifier = "file_existence"

    let defaultViolationLevel = ViolationLevel.warning
    let options: FileExistenceOptions

    init(_ optionsDict: [String: Any]) {
        options = FileExistenceOptions(optionsDict)
    }

    func violations(in directory: URL) -> [Violation] {
        var violations = [Violation]()

        for filePath in options.filePaths {
            if !FileManager.default.fileExists(atPath: filePath) {
                violations.append(
                    FileViolation(
                        rule: self,
                        message: "File does not exist.",
                        level: defaultViolationLevel,
                        path: filePath
                    )
                )
            }
        }

        return violations
    }
}
