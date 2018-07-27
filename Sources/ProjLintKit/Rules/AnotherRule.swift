import Foundation
import HandySwift

struct AnotherRule: Rule {
    static let name = "Another Rule"
    static let identifier = "another_rule"

    init(_ optionsDict: [String : Any]) {}

    func violations(in directory: URL, includedPaths: [Regex], excludedPaths: [Regex]) -> [Violation] {
        return [] // TODO: not yet implemented
    }


}
