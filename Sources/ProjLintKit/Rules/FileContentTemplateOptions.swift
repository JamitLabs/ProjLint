import Foundation
import HandySwift

class FileContentTemplateOptions: RuleOptions {
    struct TemplateWithParameters {
        let url: URL
        let parameters: [String: Any]
    }

    let matchingPathTemplate: [String: TemplateWithParameters]

    override init(_ optionsDict: [String: Any], rule: Rule.Type) {
        self.matchingPathTemplate = FileContentTemplateOptions.pathTemplate(forOption: "matching", in: optionsDict)

        super.init(optionsDict, rule: rule)
    }

    private static func pathTemplate(forOption optionName: String, in optionsDict: [String: Any]) -> [String: TemplateWithParameters] {
        guard RuleOptions.optionExists(optionName, in: optionsDict, required: true, rule: FileContentTemplateRule.self) else { return [:] }
        guard let matchingDict = optionsDict[optionName] as? [String: Any] else { return [:] }

        return matchingDict.mapValues { value in
            print(value)
            guard let templateDict = value as? [String: Any], let parameters = templateDict["parameters"] as? [String: Any] else {
                print("Could not read template and parameters in config file.", level: .error)
                exit(EX_USAGE)
            }

            if let templatePath = templateDict["template_path"] as? String {
                let templateUrl = URL(fileURLWithPath: templatePath)
                return TemplateWithParameters(url: templateUrl, parameters: parameters)
            }

            if let templateUrlString = templateDict["template_url"] as? String {
                guard let templateUrl = URL(string: templateUrlString) else {
                    print("Could make a URL from String '\(templateUrlString)'.", level: .error)
                    exit(EX_USAGE)
                }

                return TemplateWithParameters(url: templateUrl, parameters: parameters)
            }

            print("No template was specified – use `template_path` or `template_url` options to specify one.", level: .error)
            exit(EX_USAGE)
        }
    }
}
