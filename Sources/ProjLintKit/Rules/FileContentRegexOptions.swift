import Foundation
import HandySwift

class FileContentRegexOptions: RuleOptions {
    let matchingPathRegex: [String: Regex]?
    let matchingAllPathRegexes: [String: [Regex]]?
    let matchingAnyPathRegexes: [String: [Regex]]?
    let notMatchingPathRegex: [String: Regex]?
    let notMatchingAllPathRegexes: [String: [Regex]]?
    let notMatchingAnyPathRegexes: [String: [Regex]]?

    override init(_ optionsDict: [String: Any], rule: Rule.Type) {
        let matchingPathRegex = RuleOptions.optionalPathsToRegexes(forOption: "matching", in: optionsDict, rule: rule)
        let matchingAllPathRegexes = RuleOptions.optionalPathsToRegexArrays(forOption: "matching_all", in: optionsDict, rule: rule)
        let matchingAnyPathRegexes = RuleOptions.optionalPathsToRegexArrays(forOption: "matching_any", in: optionsDict, rule: rule)
        let notMatchingPathRegex = RuleOptions.optionalPathsToRegexes(forOption: "not_matching", in: optionsDict, rule: rule)
        let notMatchingAllPathRegexes = RuleOptions.optionalPathsToRegexArrays(forOption: "not_matching_all", in: optionsDict, rule: rule)
        let notMatchingAnyPathRegexes = RuleOptions.optionalPathsToRegexArrays(forOption: "not_matching_any", in: optionsDict, rule: rule)

        guard
            matchingPathRegex != nil ||
            matchingAllPathRegexes != nil ||
            matchingAnyPathRegexes != nil ||
            notMatchingPathRegex != nil ||
            notMatchingAllPathRegexes != nil ||
            notMatchingAnyPathRegexes != nil
        else {
            print("Rule \(rule.identifier) must have at least one option specified.", level: .error)
            exit(EX_USAGE)
        }

        self.matchingPathRegex = matchingPathRegex
        self.matchingAllPathRegexes = matchingAllPathRegexes
        self.matchingAnyPathRegexes = matchingAnyPathRegexes
        self.notMatchingPathRegex = notMatchingPathRegex
        self.notMatchingAllPathRegexes = notMatchingAllPathRegexes
        self.notMatchingAnyPathRegexes = notMatchingAnyPathRegexes

        super.init(optionsDict, rule: rule)
    }
}
