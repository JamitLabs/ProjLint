import Foundation
import HandySwift

struct FileContentTemplateRule: Rule {
    static let name: String = "File Content Template"
    static let identifier: String = "file_content_template"

    private let defaultViolationLevel: ViolationLevel = .warning
    private let options: FileContentTemplateOptions

    init(_ optionsDict: [String: Any]) {
        options = FileContentTemplateOptions(optionsDict, rule: type(of: self))
    }

    func violations(in directory: URL) -> [Violation] {
        var violations = [Violation]()

        // TODO: find violations here

        return violations
    }
}
