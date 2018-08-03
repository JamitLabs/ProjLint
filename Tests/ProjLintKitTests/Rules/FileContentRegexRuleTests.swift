@testable import ProjLintKit
import XCTest

final class FileContentRegexRuleTests: XCTestCase {
    let fruitEnumResource = Resource(
        path: "FruitEnum.swift",
        contents: """
            enum Fruit {
                case apple
                case banana
                case orange
            }
            """
    )

    let vegetableEnumResource = Resource(
        path: "VegetableEnum.swift",
        contents: """
            enum Vegetable {
                case carrot
                case potato
                case wasabi
            }
            """
    )

    func testMatchingRegex() {
        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["matching": [fruitEnumResource.path: "enum\\s+Fruit\\s+\\{"]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssert(violations.isEmpty)
        }

        resourcesLoaded([vegetableEnumResource]) {
            let optionsDict = ["matching": [vegetableEnumResource.path: "enum\\s+Fruit\\s+\\{"]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssert(violations.count == 1)
            XCTAssert(violations.first?.level == ViolationLevel.warning)
            XCTAssert(violations.first is FileViolation)
        }
    }

    func testMatchingAllPathRegexes() {
        // TODO: not yet implemented
    }

    func testMatchingAnyPathRegexes() {
        // TODO: not yet implemented
    }

    func testNotMatchingRegex() {
        // TODO: not yet implemented
    }

    func testNotMatchingAllPathRegexes() {
        // TODO: not yet implemented
    }

    func testNotMatchingAnyPathRegexes() {
        // TODO: not yet implemented
    }

    func testAllOptions() {
        // TODO: not yet implemented
    }
}
