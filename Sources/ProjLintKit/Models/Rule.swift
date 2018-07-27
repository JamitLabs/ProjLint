import Foundation
import HandySwift

protocol Rule {
    static var name: String { get }
    static var identifier: String { get }

    init(_ optionsDict: [String: Any])
    func violations(in directory: URL, includedPaths: [Regex], excludedPaths: [Regex]) -> [Violation]
}
