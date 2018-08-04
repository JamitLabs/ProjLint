import Foundation

class FileExistenceOptions: RuleOptions {
    let existingPaths: [String]?
    let nonExistingPaths: [String]?

    override init(_ optionsDict: [String: Any], rule: Rule.Type) {
        let existingPaths = RuleOptions.optionalStringArray(forOption: "existing_paths", in: optionsDict, rule: FileExistenceRule.self)
        let nonExistingPaths = RuleOptions.optionalStringArray(forOption: "non_existing_paths", in: optionsDict, rule: FileExistenceRule.self)

        guard existingPaths != nil || nonExistingPaths != nil else {
            print("Rule \(rule.identifier) must have at least one option specified.", level: .error)
            exit(EX_USAGE)
        }

        self.existingPaths = existingPaths
        self.nonExistingPaths = nonExistingPaths

        super.init(optionsDict, rule: rule)
    }
}
