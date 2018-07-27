import Foundation
import HandySwift

class ExampleRuleOptions: RuleOptions {
    let someBool: Bool

    override init(_ optionsDict: [String: Any]) {
        self.someBool = {
            guard let someBool = optionsDict["some_bool"] as? Bool else { return false }
            return someBool
        }()

        super.init(optionsDict)
    }
}

struct ExampleRule: Rule {
    init(_ optionsDict: [String: Any]) {
        options = ExampleRuleOptions(optionsDict)
    }

    static let name = "Example Rule"
    static let identifier = "example_rule"
    let options: RuleOptions

    func violations(in directory: URL, includedPaths: [Regex], excludedPaths: [Regex]) -> [Violation] {
        return [] // TODO: not yet implemented
    }
}
