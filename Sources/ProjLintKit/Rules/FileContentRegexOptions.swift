import Foundation
import HandySwift

class FileContentRegexOptions: RuleOptions {
    let matchingAllPathRegexes: [String: [Regex]]?
    let matchingAnyPathRegexes: [String: [Regex]]?
    let notMatchingAllPathRegexes: [String: [Regex]]?
    let notMatchingAnyPathRegexes: [String: [Regex]]?

    override init(_ optionsDict: [String: Any], rule: Rule.Type) {
        let matchingAllPathRegexes = RuleOptions.optionalPathRegexes(forOption: "matching_all", in: optionsDict, rule: FileContentRegexRule.self)
        let matchingAnyPathRegexes = RuleOptions.optionalPathRegexes(forOption: "matching_any", in: optionsDict, rule: FileContentRegexRule.self)
        let notMatchingAllPathRegexes = RuleOptions.optionalPathRegexes(forOption: "not_matching_all", in: optionsDict, rule: FileContentRegexRule.self)
        let notMatchingAnyPathRegexes = RuleOptions.optionalPathRegexes(forOption: "not_matching_any", in: optionsDict, rule: FileContentRegexRule.self)

        guard matchingAllPathRegexes != nil || matchingAnyPathRegexes != nil || notMatchingAllPathRegexes != nil || notMatchingAnyPathRegexes != nil else {
            print("Rule \(FileContentRegexRule.identifier) must have at least one option specified.", level: .error)
            exit(EX_USAGE)
        }

        self.matchingAllPathRegexes = matchingAllPathRegexes
        self.matchingAnyPathRegexes = matchingAnyPathRegexes
        self.notMatchingAllPathRegexes = notMatchingAllPathRegexes
        self.notMatchingAnyPathRegexes = notMatchingAnyPathRegexes

        super.init(optionsDict, rule: rule)
    }
}
