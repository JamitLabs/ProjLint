import Foundation
import HandySwift

class FileContentTemplateOptions: RuleOptions {
    let matchingPathTemplate: [String: URL]?
    let notMatchingPathTemplate: [String: URL]?

    override init(_ optionsDict: [String: Any], rule: Rule.Type) {
        let matchingPathTemplate = RuleOptions.optionalPathURL(forOption: "matching", in: optionsDict, rule: rule)
        let notMatchingPathTemplate = RuleOptions.optionalPathURL(forOption: "not_matching", in: optionsDict, rule: rule)

        guard matchingPathTemplate != nil || notMatchingPathTemplate != nil else {
            print("Rule \(rule.identifier) must have at least one option specified.", level: .error)
            exit(EX_USAGE)
        }

        self.matchingPathTemplate = matchingPathTemplate
        self.notMatchingPathTemplate = notMatchingPathTemplate

        super.init(optionsDict, rule: rule)
    }
}
