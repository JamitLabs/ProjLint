import Foundation
import HandySwift

// swiftlint:disable type_contents_order

class RuleOptions {
    /// Specifies when the lint command should fail.
    let forcedViolationLevel: ViolationLevel?

    init(_ optionsDict: [String: Any], rule: Rule.Type) {
        forcedViolationLevel = RuleOptions.optionalViolationLevel(forOption: "forced_violation_level", in: optionsDict, rule: rule)
    }

    /// Returns the corrected violation level considering the option `forced_violation_level` in case it is set.
    func violationLevel(defaultTo defaultLevel: ViolationLevel) -> ViolationLevel {
        guard let forcedViolationLevel = forcedViolationLevel else { return defaultLevel }
        return forcedViolationLevel
    }

    // Bool
    static func optionalBool(forOption optionName: String, in optionsDict: [String: Any], rule: Rule.Type) -> Bool? {
        return bool(forOption: optionName, in: optionsDict, required: false, rule: rule)
    }

    static func requiredBool(forOption optionName: String, in optionsDict: [String: Any], rule: Rule.Type) -> Bool {
        return bool(forOption: optionName, in: optionsDict, required: true, rule: rule)!
    }

    private static func bool(forOption optionName: String, in optionsDict: [String: Any], required: Bool, rule: Rule.Type) -> Bool? {
        guard optionExists(optionName, in: optionsDict, required: required, rule: rule) else { return nil }

        guard let bool = optionsDict[optionName] as? Bool else {
            let message = """
                Could not read option `\(optionName)` for rule \(rule.identifier) from config file.
                Expected value to be of type `Bool`. Value: \(String(describing: optionsDict[optionName]))
                """
            print(message, level: .error)
            exit(EX_USAGE)
        }

        return bool
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
            let message = """
                Could not read option `\(optionName)` for rule \(rule.identifier) from config file.
                Expected value to be of type `String`. Value: \(String(describing: optionsDict[optionName]))
                """
            print(message, level: .error)
            exit(EX_USAGE)
        }

        return string
    }

    // Regex
    static func optionalRegex(forOption optionName: String, in optionsDict: [String: Any], rule: Rule.Type) -> Regex? {
        return regex(forOption: optionName, in: optionsDict, required: false, rule: rule)
    }

    static func requiredRegex(forOption optionName: String, in optionsDict: [String: Any], rule: Rule.Type) -> Regex {
        return regex(forOption: optionName, in: optionsDict, required: true, rule: rule)!
    }

    private static func regex(forOption optionName: String, in optionsDict: [String: Any], required: Bool, rule: Rule.Type) -> Regex? {
        guard optionExists(optionName, in: optionsDict, required: required, rule: rule) else { return nil }

        guard let string = optionsDict[optionName] as? String else {
            let message = """
                Could not read option `\(optionName)` for rule \(rule.identifier) from config file.
                Expected value to be of type `String`. Value: \(String(describing: optionsDict[optionName]))
                """
            print(message, level: .error)
            exit(EX_USAGE)
        }

        guard let regex = try? Regex(string) else {
            print("The `\(optionName)` entry `\(string)` for rule \(rule.identifier) is not a valid Regex.", level: .error)
            exit(EX_USAGE)
        }

        return regex
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
            let message = """
                Could not read option `\(optionName)` for rule \(rule.identifier) from config file.
                Expected value to be of type `[String]`. Value: \(String(describing: optionsDict[optionName]))
                """
            print(message, level: .error)
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

        let stringArray = requiredStringArray(forOption: optionName, in: optionsDict, rule: rule)
        return stringArray.map { pathString in
            guard let pathRegex = try? Regex(pathString) else {
                print("The `\(optionName)` entry `\(pathString)` for rule \(rule.identifier) is not a valid Regex.", level: .error)
                exit(EX_USAGE)
            }

            return pathRegex
        }
    }

    // Paths to Strings
    static func optionalPathsToStrings(forOption optionName: String, in optionsDict: [String: Any], rule: Rule.Type) -> [String: String]? {
        return pathsToStrings(forOption: optionName, in: optionsDict, required: false, rule: rule)
    }

    static func requiredPathsToStrings(forOption optionName: String, in optionsDict: [String: Any], rule: Rule.Type) -> [String: String] {
        return pathsToStrings(forOption: optionName, in: optionsDict, required: true, rule: rule)!
    }

    private static func pathsToStrings(forOption optionName: String, in optionsDict: [String: Any], required: Bool, rule: Rule.Type) -> [String: String]? {
        guard optionExists(optionName, in: optionsDict, required: required, rule: rule) else { return nil }

        guard let stringToStringDict = optionsDict[optionName] as? [String: String] else {
            let message = """
            Could not read option `\(optionName)` for rule \(rule.identifier) from config file.
            Expected value to be of type `[String: String]`. Value: \(String(describing: optionsDict[optionName]))
            """
            print(message, level: .error)
            exit(EX_USAGE)
        }

        return stringToStringDict
    }

    // Paths to Regexes
    static func optionalPathsToRegexes(forOption optionName: String, in optionsDict: [String: Any], rule: Rule.Type) -> [String: Regex]? {
        return pathsToRegexes(forOption: optionName, in: optionsDict, required: false, rule: rule)
    }

    static func requiredPathsToRegexes(forOption optionName: String, in optionsDict: [String: Any], rule: Rule.Type) -> [String: Regex] {
        return pathsToRegexes(forOption: optionName, in: optionsDict, required: true, rule: rule)!
    }

    private static func pathsToRegexes(forOption optionName: String, in optionsDict: [String: Any], required: Bool, rule: Rule.Type) -> [String: Regex]? {
        guard optionExists(optionName, in: optionsDict, required: required, rule: rule) else { return nil }

        let stringToStringDict = requiredPathsToStrings(forOption: optionName, in: optionsDict, rule: rule)
        return stringToStringDict.mapValues { regexString in
            guard let regex = try? Regex(regexString) else {
                print("The `\(optionName)` entry `\(regexString)` for rule \(rule.identifier) is not a valid Regex.", level: .error)
                exit(EX_USAGE)
            }

            return regex
        }
    }

    // Paths to Regex Arrays
    static func optionalPathsToRegexArrays(forOption optionName: String, in optionsDict: [String: Any], rule: Rule.Type) -> [String: [Regex]]? {
        return pathsToRegexArrays(forOption: optionName, in: optionsDict, required: false, rule: rule)
    }

    static func requiredPathsToRegexArrays(forOption optionName: String, in optionsDict: [String: Any], rule: Rule.Type) -> [String: [Regex]] {
        return pathsToRegexArrays(forOption: optionName, in: optionsDict, required: true, rule: rule)!
    }

    private static func pathsToRegexArrays(forOption optionName: String, in optionsDict: [String: Any], required: Bool, rule: Rule.Type) -> [String: [Regex]]? {
        guard optionExists(optionName, in: optionsDict, required: required, rule: rule) else { return nil }

        guard let stringToAnyDict = optionsDict[optionName] as? [String: Any] else {
            let message = """
                Could not read option `\(optionName)` for rule \(rule.identifier) from config file.
                Expected value to be of type `[String: Any]`. Value: \(String(describing: optionsDict[optionName]))
                """
            print(message, level: .error)
            exit(EX_USAGE)
        }

        var pathRegexes = [String: [Regex]]()
        stringToAnyDict.keys.forEach { path in
            pathRegexes[path] = requiredRegexArray(forOption: path, in: stringToAnyDict, rule: rule)
        }

        return pathRegexes
    }

    // Paths to URLs
    static func optionalPathsToURLs(forOption optionName: String, in optionsDict: [String: Any], rule: Rule.Type) -> [String: URL]? {
        return pathsToURLs(forOption: optionName, in: optionsDict, required: false, rule: rule)
    }

    static func requiredPathsToURLs(forOption optionName: String, in optionsDict: [String: Any], rule: Rule.Type) -> [String: URL] {
        return pathsToURLs(forOption: optionName, in: optionsDict, required: true, rule: rule)!
    }

    private static func pathsToURLs(forOption optionName: String, in optionsDict: [String: Any], required: Bool, rule: Rule.Type) -> [String: URL]? {
        guard optionExists(optionName, in: optionsDict, required: required, rule: rule) else { return nil }

        let stringToStringDict = requiredPathsToStrings(forOption: optionName, in: optionsDict, rule: rule)
        return stringToStringDict.mapValues { path in
            guard let url = URL(string: path) else {
                print("The `\(optionName)` entry `\(path)` for rule \(rule.identifier) is not a valid URl.", level: .error)
                exit(EX_USAGE)
            }

            return url
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
            let message = """
                Could not read option `\(optionName)` for rule \(rule.identifier) from config file.
                Expected value to be of type `String`. Value: \(String(describing: optionsDict[optionName]))
                """
            print(message, level: .error)
            exit(EX_USAGE)
        }

        guard let violationLevel = ViolationLevel(rawValue: violationLevelString) else {
            print("The `\(optionName)` entry `\(violationLevelString)` for rule \(rule.identifier) has an invalid value.", level: .error)
            exit(EX_USAGE)
        }

        return violationLevel
    }

    // MARK: - Helpers
    static func optionExists(_ optionName: String, in optionsDict: [String: Any], required: Bool, rule: Rule.Type) -> Bool {
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
