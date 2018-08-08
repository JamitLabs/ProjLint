import Foundation
import HandySwift

struct XcodeProjectNavigatorRule: Rule {
    static let name: String = "Xcode Project Navigator"
    static let identifier: String = "xcode_project_navigator"

    private let defaultViolationLevel: ViolationLevel = .warning
    private let options: XcodeProjectNavigatorOptions

    init(_ optionsDict: [String: Any]) {
        options = XcodeProjectNavigatorOptions(optionsDict, rule: type(of: self))
    }

    func violations(in directory: URL) -> [Violation] {
        var violations = [Violation]()

        // TODO: find violations here

        return violations
    }
}
