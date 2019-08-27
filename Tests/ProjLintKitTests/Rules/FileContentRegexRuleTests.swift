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

    func testMatchingRegex() {
        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["matching": [fruitEnumResource.relativePath: "enum\\s+Fruit\\s+\\{"]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 0)
        }

        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["matching": [fruitEnumResource.relativePath: "enum\\s+Vegetable\\s+\\{"]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 1)
        }
    }

    func testMatchingAllPathRegexes() {
        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["matching_all": [fruitEnumResource.relativePath: ["case\\s+apple", "case\\s+banana", "case\\s+orange"]]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 0)
        }

        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["matching_all": [fruitEnumResource.relativePath: ["case\\s+apple", "case\\s+grapefruit", "case\\s+pineapple"]]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 2)
        }
    }

    func testMatchingAnyPathRegexes() {
        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["matching_any": [fruitEnumResource.relativePath: ["case\\s+apple", "case\\s+grapefruit", "case\\s+pineapple"]]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 0)
        }

        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["matching_any": [fruitEnumResource.relativePath: ["case\\s+kiwi", "case\\s+grapefruit", "case\\s+pineapple"]]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 1)
        }
    }

    func testNotMatchingRegex() {
        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["not_matching": [fruitEnumResource.relativePath: "enum\\s+Fruit\\s+\\{"]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 1)
        }

        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["not_matching": [fruitEnumResource.relativePath: "enum\\s+Vegetable\\s+\\{"]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 0)
        }
    }

    func testNotMatchingAllPathRegexes() {
        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["not_matching_all": [fruitEnumResource.relativePath: ["case\\s+apple", "case\\s+banana", "case\\s+orange"]]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 1)
        }

        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["not_matching_all": [fruitEnumResource.relativePath: ["case\\s+apple", "case\\s+grapefruit", "case\\s+pineapple"]]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 0)
        }
    }

    func testNotMatchingAnyPathRegexes() {
        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["not_matching_any": [fruitEnumResource.relativePath: ["case\\s+apple", "case\\s+banana", "case\\s+pineapple"]]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 2)
        }

        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["not_matching_any": [fruitEnumResource.relativePath: ["case\\s+kiwi", "case\\s+grapefruit", "case\\s+pineapple"]]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 0)
        }
    }
}
