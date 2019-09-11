import Foundation

class FileExistenceOptions: RuleOptions {
    let existingPaths: [String]?
    let nonExistingPaths: [String]?
    let allowedPathsRegex: [String]?

    override init(_ optionsDict: [String: Any], rule: Rule.Type) {
        let existingPaths = RuleOptions.optionalStringArray(forOption: "existing_paths", in: optionsDict, rule: rule)
        let nonExistingPaths = RuleOptions.optionalStringArray(forOption: "non_existing_paths", in: optionsDict, rule: rule)
        let allowedPathsRegex = RuleOptions.optionalStringArray(forOption: "allowed_paths_regex", in: optionsDict, rule: rule)

        let options = [existingPaths, nonExistingPaths, allowedPathsRegex]
        guard options.contains(where: { $0 != nil }) else {
            print("Rule \(rule.identifier) must have at least one option specified.", level: .error)
            exit(EX_USAGE)
        }

        self.existingPaths = existingPaths
        self.nonExistingPaths = nonExistingPaths
        self.allowedPathsRegex = allowedPathsRegex

        super.init(optionsDict, rule: rule)
    }
}
