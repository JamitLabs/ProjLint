import Foundation
import HandySwift

class RuleOptions {
    /// Specifies when the lint command should fail.
    let lintFailLevel: ViolationLevel?
    let forcedViolationLevel: ViolationLevel?

    init(_ optionsDict: [String: Any], rule: Rule.Type) {
        lintFailLevel = RuleOptions.optionalViolationLevel(forOption: "lint_fail_level", in: optionsDict, rule: rule)
        forcedViolationLevel = RuleOptions.optionalViolationLevel(forOption: "forced_violation_level", in: optionsDict, rule: rule)
    }

    /// Returns the corrected violation level considering the option `forced_violation_level` in case it is set.
    func violationLevel(defaultTo defaultLevel: ViolationLevel) -> ViolationLevel {
        guard let forcedViolationLevel = forcedViolationLevel else { return defaultLevel }
        return forcedViolationLevel
    }

    // String
    static func optionalString(forOption optionName: String, in optionsDict: [String: Any], rule: Rule.Type) -> String? {
        return string(forOption: optionName, in: optionsDict, required: false, rule: rule)
    }

    static func requiredString(forOption optionName: String, in optionsDict: [String: Any], rule: Rule.Type) -> String {
        return string(forOption: optionName, in: optionsDict, required: true, rule: rule)!
    }

    private static func string(forOption optionName: String, in optionsDict: [String: Any], required: Bool, rule: Rule.Type) -> String? {
        guard optionExists(optionName, in: optionsDict, required: required, rule: rule) else { return nil }

        guard let string = optionsDict[optionName] as? String else {
            print("Could not read option `\(optionName)` for rule \(rule.identifier) from config file.", level: .error)
            exit(EX_USAGE)
        }

        return string
    }

    // String Array
    static func optionalStringArray(forOption optionName: String, in optionsDict: [String: Any], rule: Rule.Type) -> [String]? {
        return stringArray(forOption: optionName, in: optionsDict, required: false, rule: rule)
    }

    static func requiredStringArray(forOption optionName: String, in optionsDict: [String: Any], rule: Rule.Type) -> [String] {
        return stringArray(forOption: optionName, in: optionsDict, required: true, rule: rule)!
    }

    private static func stringArray(forOption optionName: String, in optionsDict: [String: Any], required: Bool, rule: Rule.Type) -> [String]? {
        guard optionExists(optionName, in: optionsDict, required: required, rule: rule) else { return nil }

        guard let stringArray = optionsDict[optionName] as? [String] else {
            print("Could not read option `\(optionName)` for rule \(rule.identifier) from config file.", level: .error)
            exit(EX_USAGE)
        }

        return stringArray
    }

    // Regex Array
    static func optionalRegexArray(forOption optionName: String, in optionsDict: [String: Any], rule: Rule.Type) -> [Regex]? {
        return regexArray(forOption: optionName, in: optionsDict, required: false, rule: rule)
    }

    static func requiredRegexArray(forOption optionName: String, in optionsDict: [String: Any], rule: Rule.Type) -> [Regex] {
        return regexArray(forOption: optionName, in: optionsDict, required: true, rule: rule)!
    }

    private static func regexArray(forOption optionName: String, in optionsDict: [String: Any], required: Bool, rule: Rule.Type) -> [Regex]? {
        guard optionExists(optionName, in: optionsDict, required: required, rule: rule) else { return nil }

        guard let stringArray = optionsDict[optionName] as? [String] else {
            print("Could not read option `\(optionName)` for rule \(rule.identifier) from config file.", level: .error)
            exit(EX_USAGE)
        }

        return stringArray.map { pathString in
            guard let pathRegex = try? Regex(pathString) else {
                print("The `\(optionName)` entry `\(pathString)` for rule \(rule.identifier) is not a valid Regex.", level: .error)
                exit(EX_USAGE)
            }

            return pathRegex
        }
    }

    // Violation Level
    static func optionalViolationLevel(forOption optionName: String, in optionsDict: [String: Any], rule: Rule.Type) -> ViolationLevel? {
        return violationLevel(forOption: optionName, in: optionsDict, required: false, rule: rule)
    }

    static func requiredViolationLevel(forOption optionName: String, in optionsDict: [String: Any], rule: Rule.Type) -> ViolationLevel {
        return violationLevel(forOption: optionName, in: optionsDict, required: true, rule: rule)!
    }

    private static func violationLevel(
        forOption optionName: String,
        in optionsDict: [String: Any],
        required: Bool,
        rule: Rule.Type
    ) -> ViolationLevel? {
        guard optionExists(optionName, in: optionsDict, required: required, rule: rule) else { return nil }

        guard let violationLevelString = optionsDict[optionName] as? String else {
            print("Could not read option `\(optionName)` for rule \(rule.identifier) from config file.", level: .error)
            exit(EX_USAGE)
        }

        guard let violationLevel = ViolationLevel(rawValue: violationLevelString) else {
            print("The `\(optionName)` entry `\(violationLevelString)` for rule \(rule.identifier) has an invalid value.", level: .error)
            exit(EX_USAGE)
        }

        return violationLevel
    }

    // MARK: - Helpers
    private static func optionExists(_ optionName: String, in optionsDict: [String: Any], required: Bool, rule: Rule.Type) -> Bool {
        guard optionsDict.keys.contains(optionName) else {
            guard !required else {
                print("Could not find required option `\(optionName)` for rule \(rule.identifier) in config file.", level: .error)
                exit(EX_USAGE)
            }

            return false
        }

        return true
    }
}
