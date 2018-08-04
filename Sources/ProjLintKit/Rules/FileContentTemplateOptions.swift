import Foundation
import HandySwift

class FileContentTemplateOptions: RuleOptions {
    struct TemplateWithParameters {
        let url: URL
        let parameters: [String: Any]
    }

    let matchingPathTemplate: [String: TemplateWithParameters]?
    let notMatchingPathTemplate: [String: TemplateWithParameters]?

    override init(_ optionsDict: [String: Any], rule: Rule.Type) {
        let matchingPathTemplate = FileContentTemplateOptions.pathTemplate(forOption: "matching", in: optionsDict)
        let notMatchingPathTemplate = FileContentTemplateOptions.pathTemplate(forOption: "not_matching", in: optionsDict)

        guard matchingPathTemplate != nil || notMatchingPathTemplate != nil else {
            print("Rule \(rule.identifier) must have at least one option specified.", level: .error)
            exit(EX_USAGE)
        }

        self.matchingPathTemplate = matchingPathTemplate
        self.notMatchingPathTemplate = notMatchingPathTemplate

        super.init(optionsDict, rule: rule)
    }

    private static func pathTemplate(forOption optionName: String, in optionsDict: [String: Any]) -> [String: TemplateWithParameters]? {
        guard let matchingDict = optionsDict[optionName] as? [String: Any] else { return nil }
        return matchingDict.mapValues { value in
            print(value)
            guard
                let templateDict = value as? [String: Any],
                let templatePath = templateDict["template"] as? String,
                let templateUrl = URL(string: templatePath),
                let parameters = templateDict["parameters"] as? [String: Any]
            else {
                print("Could not read template and parameters in config file.", level: .error)
                exit(EX_USAGE)
            }

            return TemplateWithParameters(url: templateUrl, parameters: parameters)
        }
    }
}
