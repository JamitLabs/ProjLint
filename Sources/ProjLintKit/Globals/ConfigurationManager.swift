import Foundation
import HandySwift
import Yams

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

        return Configuration(
            defaultOptions: RuleOptions(configDict),
            rules: ruleArray(forOption: "rules", in: configDict)
        )
    }

    private static func ruleArray(forOption optionName: String, in configDict: [String: Any]) -> [Rule] {
        guard let ruleEntries = configDict[optionName] as? [Any] else { return [] }

        var rules = [Rule]()

        for ruleEntry in ruleEntries {
            if let ruleIdentifier = ruleEntry as? String {
                let rule = RuleFactory.makeRule(identifier: ruleIdentifier, optionsDict: nil)
                rules.append(rule)
            } else if
                let ruleDict = ruleEntry as? [String: Any],
                let ruleIdentifier = ruleDict.keys.first,
                let optionsDict = ruleDict[ruleIdentifier] as? [String: Any]
            {
                let rule = RuleFactory.makeRule(identifier: ruleIdentifier, optionsDict: optionsDict)
                rules.append(rule)
            } else {
                print("Unexpected format in rule options.", level: .error)
                exit(EX_USAGE)
            }
        }

        return rules
    }

    
}
