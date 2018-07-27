import Foundation
import HandySwift

protocol Rule {
    var name: String { get }
    var options: RuleOptions { get set }
    func violations(in directory: URL, includedPaths: [Regex], excludedPaths: [Regex]) -> [Violation]
}
