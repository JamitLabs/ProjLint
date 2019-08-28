import Foundation
import HandySwift
import Yams

private struct DefaultRule: Rule {
    static let name: String = "Default"
    static let identifier: String = "default"

    init(_ optionsDict: [String: Any]) {
        fatalError("This is not intended for direct usage – override in subclass instead.")
    }

    func violations(in directory: URL) -> [Violation] {
        fatalError("This is not intended for direct usage – override in subclass instead.")
    }
}

enum ConfigurationManager {
    static func loadConfiguration() -> Configuration {
        let currentDirUrl = FileManager.default.currentDirectoryUrl
        let configFileUrl = currentDirUrl.appendingPathComponent(".projlint.yml")

        guard let configContentString = try? String(contentsOf: configFileUrl, encoding: .utf8) else {
            print("Could not load contents of config file. Please make sure the file `.projlint.yml` exists.", level: .error)
            exit(EX_USAGE)
        }

        guard let configYaml = try? Yams.load(yaml: configContentString), let configDict = configYaml as? [String: Any] else {
            print("Could not load config file. Could not parse as YAML – please check if your file is valid YAML.", level: .error)
            exit(EX_USAGE)
        }

        var sharedVariables: [String: String] = {
            guard let sharedVariables = configDict["shared_variables"] as? [String: String] else { return [:] }
            return sharedVariables
        }()

        var defaultOptionsDict: [String: Any] = {
            guard let defaultOptionsDict = configDict["default_options"] as? [String: Any] else { return [:] }
            return defaultOptionsDict
        }()

        var ruleEntries: [Any] = configDict["rules"] as? [Any] ?? []

        // override values using local config file if available
        let localConfigFileUrl = currentDirUrl.appendingPathComponent(".projlint-local.yml")

        if let localConfigContentString = try? String(contentsOf: localConfigFileUrl, encoding: .utf8) {
            guard let localConfigYaml = try? Yams.load(yaml: localConfigContentString), let localConfigDict = localConfigYaml as? [String: Any] else {
                print("Could not load local config file. Could not parse as YAML – please check if your file is valid YAML.", level: .error)
                exit(EX_USAGE)
            }

            let localSharedVariables: [String: String] = {
                guard let localSharedVariables = localConfigDict["shared_variables"] as? [String: String] else { return [:] }
                return localSharedVariables
            }()

            sharedVariables.merge(localSharedVariables)

            let localDefaultOptionsDict: [String: Any] = {
                guard let localDefaultOptionsDict = localConfigDict["default_options"] as? [String: Any] else { return [:] }
                return localDefaultOptionsDict
            }()

            defaultOptionsDict.merge(localDefaultOptionsDict)

            let localRuleEntries: [Any] = localConfigDict["rules"] as? [Any] ?? []
            ruleEntries.append(contentsOf: localRuleEntries)
        }

        return Configuration(
            defaultOptions: RuleOptions(defaultOptionsDict, rule: DefaultRule.self),
            rules: rules(in: ruleEntries, sharedVariables: sharedVariables)
        )
    }

    private static func rules(in ruleEntries: [Any], sharedVariables: [String: String]) -> [Rule] {
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
