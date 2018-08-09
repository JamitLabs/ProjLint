import Foundation
import HandySwift

class XcodeProjectNavigatorOptions: RuleOptions {
    enum GroupType: String {
        case interface = "interfaces"
        case codeFile = "code_files"
        case assets = "assets"
        case strings = "strings"
        case folder = "folders"
        case plist = "plists"
        case entitlement = "entitlements"
        case other = "others"
    }

    enum TreeNode {
        case leaf(String)
        case subtree(group: String, nodes: [TreeNode])
    }

    let projectPath: String
    let sorted: [String]?
    let innerGroupOrder: [[GroupType]]
    let structure: [TreeNode]

    override init(_ optionsDict: [String: Any], rule: Rule.Type) {
        projectPath = RuleOptions.requiredString(forOption: "project_path", in: optionsDict, rule: rule)
        sorted = RuleOptions.optionalStringArray(forOption: "sorted", in: optionsDict, rule: rule)
        innerGroupOrder = XcodeProjectNavigatorOptions.orderedGroupTypes(forOption: "inner_group_order", in: optionsDict, rule: rule)
        structure = XcodeProjectNavigatorOptions.orderedStructure(forOption: "structure", in: optionsDict, rule: rule)

        super.init(optionsDict, rule: rule)
    }

    private static func orderedGroupTypes(forOption optionName: String, in optionsDict: [String: Any], rule: Rule.Type) -> [[GroupType]] {
        guard RuleOptions.optionExists(optionName, in: optionsDict, required: true, rule: rule) else {
            let message = """
                Could not read option `\(optionName)` for rule \(rule.identifier) from config file.
                """
            print(message, level: .error)
            exit(EX_USAGE)
        }

        guard let anyArray = optionsDict[optionName] as? [Any] else {
            let message = """
                Could not read option `\(optionName)` for rule \(rule.identifier) from config file.
                Expected value to be of type `[Any]`. Value: \(String(describing: optionsDict[optionName]))
                """
            print(message, level: .error)
            exit(EX_USAGE)
        }

        let orderedStrings: [[String]] = anyArray.map { any in
            if let string = any as? String {
                return [string]
            }

            if let stringArray = any as? [String] {
                return stringArray
            }

            let message = """
                Could not read option `\(optionName)` for rule \(rule.identifier) from config file.
                Expected value to be of type `[String]` or `String`. Value: \(String(describing: any))
                """
            print(message, level: .error)
            exit(EX_USAGE)
        }

        return orderedStrings.map { strings in
            return strings.map { string in
                guard let groupType = GroupType(rawValue: string) else {
                    print("Found invalid group order type '\(string)' for option '\(optionName)' for rule \(rule.identifier).", level: .error)
                    exit(EX_USAGE)
                }

                return groupType
            }
        }
    }

    private static func orderedStructure(forOption optionName: String, in optionsDict: [String: Any], rule: Rule.Type) -> [TreeNode] {
        guard RuleOptions.optionExists(optionName, in: optionsDict, required: true, rule: rule) else {
            print("Could not read option `\(optionName)` for rule \(rule.identifier) from config file.", level: .error)
            exit(EX_USAGE)
        }

        guard let anyArray = optionsDict[optionName] as? [Any] else {
            let message = """
                Could not read option `\(optionName)` for rule \(rule.identifier) from config file.
                Expected value to be of type `[Any]`. Value: \(String(describing: optionsDict[optionName]))
                """
            print(message, level: .error)
            exit(EX_USAGE)
        }

        return treeNodes(from: anyArray)
    }

    private static func treeNodes(from array: [Any]) -> [TreeNode] {
        return array.map { node in
            switch node {
            case let dict as [String: [Any]]:
                let group = dict.keys.first!
                let array = dict[group]!
                return TreeNode.subtree(group: group, nodes: treeNodes(from: array))

            case let string as String:
                return TreeNode.leaf(string)

            default:
                print("Structure is invalid. Error at: \(node)", level: .error)
                exit(EX_USAGE)
            }
        }
    }
}
