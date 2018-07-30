import Foundation
import HandySwift

class FileContentRegexOptions: RuleOptions {
    let matchingRegex: [String: Regex]?
    let matchingAllPathRegexes: [String: [Regex]]?
    let matchingAnyPathRegexes: [String: [Regex]]?
    let notMatchingRegex: [String: Regex]?
    let notMatchingAllPathRegexes: [String: [Regex]]?
    let notMatchingAnyPathRegexes: [String: [Regex]]?

    override init(_ optionsDict: [String: Any], rule: Rule.Type) {
        let matchingRegex = RuleOptions.optionalPathRegex(forOption: "matching", in: optionsDict, rule: FileContentRegexRule.self)
        let matchingAllPathRegexes = RuleOptions.optionalPathRegexes(forOption: "matching_all", in: optionsDict, rule: FileContentRegexRule.self)
        let matchingAnyPathRegexes = RuleOptions.optionalPathRegexes(forOption: "matching_any", in: optionsDict, rule: FileContentRegexRule.self)
        let notMatchingRegex = RuleOptions.optionalPathRegex(forOption: "not_matching", in: optionsDict, rule: FileContentRegexRule.self)
        let notMatchingAllPathRegexes = RuleOptions.optionalPathRegexes(forOption: "not_matching_all", in: optionsDict, rule: FileContentRegexRule.self)
        let notMatchingAnyPathRegexes = RuleOptions.optionalPathRegexes(forOption: "not_matching_any", in: optionsDict, rule: FileContentRegexRule.self)

        guard
            matchingRegex != nil ||
            matchingAllPathRegexes != nil ||
            matchingAnyPathRegexes != nil ||
            notMatchingRegex != nil ||
            notMatchingAllPathRegexes != nil ||
            notMatchingAnyPathRegexes != nil
        else {
            print("Rule \(FileContentRegexRule.identifier) must have at least one option specified.", level: .error)
            exit(EX_USAGE)
        }

        self.matchingRegex = matchingRegex
        self.matchingAllPathRegexes = matchingAllPathRegexes
        self.matchingAnyPathRegexes = matchingAnyPathRegexes
        self.notMatchingRegex = notMatchingRegex
        self.notMatchingAllPathRegexes = notMatchingAllPathRegexes
        self.notMatchingAnyPathRegexes = notMatchingAnyPathRegexes

        super.init(optionsDict, rule: rule)
    }
}
