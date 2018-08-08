import Foundation
import HandySwift

class XcodeBuildPhasesOptions: RuleOptions {
    let projectPath: String
    let targetName: String
    let runScripts: [String: String]

    override init(_ optionsDict: [String: Any], rule: Rule.Type) {
        projectPath = RuleOptions.requiredString(forOption: "project_path", in: optionsDict, rule: rule)
        targetName = RuleOptions.requiredString(forOption: "target_name", in: optionsDict, rule: rule)
        runScripts = RuleOptions.requiredPathsToStrings(forOption: "run_scripts", in: optionsDict, rule: rule)

        super.init(optionsDict, rule: rule)
    }
}
