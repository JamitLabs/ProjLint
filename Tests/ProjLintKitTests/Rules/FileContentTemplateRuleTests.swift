@testable import ProjLintKit
import XCTest

final class FileContentTemplateRuleTests: XCTestCase {
    // TODO: initialize resources here

    func testOptionName() { // TODO: update option name
        resourcesLoaded([]) { // TODO: add positive example resource to array
            let optionsDict = ["": ""] // TODO: set positive options of type [String: Any]
            let rule = FileContentTemplateRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 0)
        }

        resourcesLoaded([]) { // TODO: add negative example resource to array
            let optionsDict = ["matching": ""] // TODO: set negative options of type [String: Any]
            let rule = FileContentTemplateRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 1) // TODO: set violations count for example
        }
    }
}
