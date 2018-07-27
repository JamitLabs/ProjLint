import Foundation

enum RuleFactory {
    static func makeRule(identifier: String, optionsDict: [String: Any]?) -> Rule {
        let optionsDict = optionsDict ?? [:]

        switch identifier {
        case FileExistenceRule.identifier:
            return FileExistenceRule(optionsDict)

        default:
            print("Rule with identifier \(identifier) unknown.", level: .error)
            exit(EX_USAGE)
        }
    }
}
