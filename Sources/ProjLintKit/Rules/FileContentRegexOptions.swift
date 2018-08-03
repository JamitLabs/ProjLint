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
        let matchingPathRegex = RuleOptions.optionalPathRegex(forOption: "matching", in: optionsDict, rule: FileContentRegexRule.self)
        let matchingAllPathRegexes = RuleOptions.optionalPathRegexes(forOption: "matching_all", in: optionsDict, rule: FileContentRegexRule.self)
        let matchingAnyPathRegexes = RuleOptions.optionalPathRegexes(forOption: "matching_any", in: optionsDict, rule: FileContentRegexRule.self)
        let notMatchingPathRegex = RuleOptions.optionalPathRegex(forOption: "not_matching", in: optionsDict, rule: FileContentRegexRule.self)
        let notMatchingAllPathRegexes = RuleOptions.optionalPathRegexes(forOption: "not_matching_all", in: optionsDict, rule: FileContentRegexRule.self)
        let notMatchingAnyPathRegexes = RuleOptions.optionalPathRegexes(forOption: "not_matching_any", in: optionsDict, rule: FileContentRegexRule.self)

        guard
            matchingPathRegex != nil ||
            matchingAllPathRegexes != nil ||
            matchingAnyPathRegexes != nil ||
            notMatchingPathRegex != nil ||
            notMatchingAllPathRegexes != nil ||
            notMatchingAnyPathRegexes != nil
        else {
            print("Rule \(FileContentRegexRule.identifier) must have at least one option specified.", level: .error)
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
