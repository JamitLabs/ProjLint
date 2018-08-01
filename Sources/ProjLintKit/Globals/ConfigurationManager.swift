import Foundation
import HandySwift
import Yams

private struct DefaultRule: Rule {
    static let name = "Default"
    static let identifier = "default"

    init(_ optionsDict: [String: Any]) {
        fatalError()
    }

    func violations(in directory: URL) -> [Violation] {
        fatalError()
    }
}

enum ConfigurationManager {
    static func loadConfiguration() -> Configuration {
        let configFilePath = (FileManager.default.currentDirectoryPath as NSString).appendingPathComponent(".projlint.yml")
        let configFileUrl = URL(fileURLWithPath: configFilePath)

        guard let configContentString = try? String(contentsOf: configFileUrl, encoding: .utf8) else {
            print("Could not load contents of config file. Please make sure the file `.projlint.yml` exists.", level: .error)
            exit(EX_USAGE)
        }

        guard let configYaml = try? Yams.load(yaml: configContentString), let configDict = configYaml as? [String: Any] else {
            print("Could not load config file. Could not parse as YAML – please check if your file is valid YAML.", level: .error)
            exit(EX_USAGE)
        }

        let sharedVariables: [String: String] = {
            guard let sharedVariables = configDict["shared_variables"] as? [String: String] else { return [:] }
            return sharedVariables
        }()

        let defaultOptionsDict: [String: Any] = {
            guard let defaultOptionsDict = configDict["default_options"] as? [String: Any] else { return [:] }
            return defaultOptionsDict
        }()

        return Configuration(
            defaultOptions: RuleOptions(defaultOptionsDict, rule: DefaultRule.self),
            rules: ruleArray(forOption: "rules", in: configDict, sharedVariables: sharedVariables)
        )
    }

    private static func ruleArray(forOption optionName: String, in configDict: [String: Any], sharedVariables: [String: String]) -> [Rule] {
        guard let ruleEntries = configDict[optionName] as? [Any] else { return [] }

        var rules = [Rule]()

        for ruleEntry in ruleEntries {
            if let ruleIdentifier = ruleEntry as? String {
                let rule = RuleFactory.makeRule(identifier: ruleIdentifier, optionsDict: nil, sharedVariables: nil)
                rules.append(rule)
            } else if
                let ruleDict = ruleEntry as? [String: Any],
                let ruleIdentifier = ruleDict.keys.first,
                let optionsDict = ruleDict[ruleIdentifier] as? [String: Any]
            {
                let rule = RuleFactory.makeRule(identifier: ruleIdentifier, optionsDict: optionsDict, sharedVariables: sharedVariables)
                rules.append(rule)
            } else {
                print("Unexpected format in rule options.", level: .error)
                exit(EX_USAGE)
            }
        }

        return rules
    }
}
