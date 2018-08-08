// Generated using Sourcery 0.13.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Foundation

enum RuleFactory {
    static func makeRule(identifier: String, optionsDict: [String: Any]?, sharedVariables: [String: String]?) -> Rule {
        let optionsDict = sharedVariablesAppliedDict(optionsDict ?? [:], sharedVariables: sharedVariables ?? [:])

        switch identifier {
        case FileContentRegexRule.identifier:
            return FileContentRegexRule(optionsDict)

        case FileContentTemplateRule.identifier:
            return FileContentTemplateRule(optionsDict)

        case FileExistenceRule.identifier:
            return FileExistenceRule(optionsDict)

        case XcodeBuildPhasesRule.identifier:
            return XcodeBuildPhasesRule(optionsDict)

        case XcodeProjectNavigatorRule.identifier:
            return XcodeProjectNavigatorRule(optionsDict)

        default:
            print("Rule with identifier \(identifier) unknown.", level: .error)
            exit(EX_USAGE)
        }
    }

    private static func sharedVariablesAppliedDict(_ dictionary: [String: Any], sharedVariables: [String: String]) -> [String: Any] {
        var newDict = [String: Any]()

        for (key, value) in dictionary {
            let newKey = sharedVariablesAppliedString(key, sharedVariables: sharedVariables)
            let newValue: Any = {
                if let stringValue = value as? String {
                    return sharedVariablesAppliedString(stringValue, sharedVariables: sharedVariables)
                } else if let stringArrayValue = value as? [String] {
                    return stringArrayValue.map { sharedVariablesAppliedString($0, sharedVariables: sharedVariables) }
                } else if let dictValue = value as? [String: Any] {
                    return sharedVariablesAppliedDict(dictValue, sharedVariables: sharedVariables)
                } else {
                    return value
                }
            }()

            newDict[newKey] = newValue
        }

        return newDict
    }

    private static func sharedVariablesAppliedString(_ string: String, sharedVariables: [String: String]) -> String {
        var newString = string

        for (placeholder, replacement) in sharedVariables {
            newString = newString.replacingOccurrences(of: "<:\(placeholder):>", with: replacement)
        }

        return newString
    }
}
