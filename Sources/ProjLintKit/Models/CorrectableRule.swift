import Foundation
import HandySwift

protocol CorrectableRule: Rule {
    func correctViolations(in directory: URL, includedPaths: [Regex], excludedPaths: [Regex]) -> [Violation]
}
