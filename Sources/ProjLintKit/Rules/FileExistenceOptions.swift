import Foundation

class FileExistenceOptions: RuleOptions {
    let existingPaths: [String]?
    let nonExistingPaths: [String]?
    let allowedPathsRegex: [String]?

    override init(_ optionsDict: [String: Any], rule: Rule.Type) {
        self.existingPaths = RuleOptions.optionalStringArray(forOption: "existing_paths", in: optionsDict, rule: rule)
        self.nonExistingPaths = RuleOptions.optionalStringArray(forOption: "non_existing_paths", in: optionsDict, rule: rule)
        self.allowedPathsRegex = RuleOptions.optionalStringArray(forOption: "allowed_paths_regex", in: optionsDict, rule: rule)
        super.init(optionsDict, rule: rule)
    }
}
