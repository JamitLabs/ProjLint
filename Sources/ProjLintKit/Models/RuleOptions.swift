import Foundation
import HandySwift

class RuleOptions {
    /// Specifies when the lint command should fail.
    let lintFailLevel: ViolationLevel?

    init(_ optionsDict: [String: Any]) {
        lintFailLevel = RuleOptions.violationLevel(forOption: "lint_fail_level", in: optionsDict)
    }

    private static func regexArray(forOption optionName: String, in optionsDict: [String: Any]) -> [Regex] {
        guard optionsDict.keys.contains(optionName) else { return [] }

        guard let stringArray = optionsDict[optionName] as? [String] else {
            print("Could not read option `\(optionName)` from config file.", level: .error)
            exit(EX_USAGE)
        }

        return stringArray.map { pathString in
            guard let pathRegex = try? Regex(pathString) else {
                print("The `\(optionName)` entry `\(pathString)` is not a valid Regex.", level: .error)
                exit(EX_USAGE)
            }

            return pathRegex
        }
    }

    private static func violationLevel(forOption optionName: String, in optionsDict: [String: Any]) -> ViolationLevel? {
        guard optionsDict.keys.contains(optionName) else { return nil }

        guard let violationLevelString = optionsDict[optionName] as? String else {
            print("Could not read option `\(optionName)` from config file.", level: .error)
            exit(EX_USAGE)
        }

        guard let violationLevel = ViolationLevel(rawValue: violationLevelString) else {
            print("The `\(optionName)` entry `\(violationLevelString)` has an invalid value.", level: .error)
            exit(EX_USAGE)
        }

        return violationLevel
    }
}
