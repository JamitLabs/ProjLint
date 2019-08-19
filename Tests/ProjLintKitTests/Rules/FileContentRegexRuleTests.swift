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
            let optionsDict = ["matching": [fruitEnumResource.path: "enum\\s+Fruit\\s+\\{"]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 0)
        }

        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["matching": [fruitEnumResource.path: "enum\\s+Vegetable\\s+\\{"]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 1)
        }
    }

    func testMatchingAllPathRegexes() {
        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["matching_all": [fruitEnumResource.path: ["case\\s+apple", "case\\s+banana", "case\\s+orange"]]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 0)
        }

        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["matching_all": [fruitEnumResource.path: ["case\\s+apple", "case\\s+grapefruit", "case\\s+pineapple"]]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 2)
        }
    }

    func testMatchingAnyPathRegexes() {
        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["matching_any": [fruitEnumResource.path: ["case\\s+apple", "case\\s+grapefruit", "case\\s+pineapple"]]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 0)
        }

        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["matching_any": [fruitEnumResource.path: ["case\\s+kiwi", "case\\s+grapefruit", "case\\s+pineapple"]]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 1)
        }
    }

    func testNotMatchingRegex() {
        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["not_matching": [fruitEnumResource.path: "enum\\s+Fruit\\s+\\{"]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 1)
            XCTAssertEqual(violations.compactMap { ($0 as? FileViolation)?.line }, [1])
        }

        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["not_matching": [fruitEnumResource.path: "case"]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 3)
            XCTAssertEqual(violations.compactMap { ($0 as? FileViolation)?.line }, [2, 3, 4])
        }

        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["not_matching": [fruitEnumResource.path: "enum\\s+Vegetable\\s+\\{"]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 0)
        }
    }

    func testNotMatchingAllPathRegexes() {
        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["not_matching_all": [fruitEnumResource.path: ["case\\s+apple", "case\\s+banana", "case\\s+orange"]]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 3)
            XCTAssertEqual(violations.compactMap { ($0 as? FileViolation)?.line }, [2, 3, 4])
        }

        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["not_matching_all": [fruitEnumResource.path: ["case", "banana", "orange"]]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 5)
            XCTAssertEqual(violations.compactMap { ($0 as? FileViolation)?.line }, [2, 3, 4, 3, 4])
        }

        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["not_matching_all": [fruitEnumResource.path: ["case", "banana", "grapefruit"]]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 0)
        }

        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["not_matching_all": [fruitEnumResource.path: ["case\\s+apple", "case\\s+grapefruit", "case\\s+pineapple"]]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 0)
        }
    }

    func testNotMatchingAnyPathRegexes() {
        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["not_matching_any": [fruitEnumResource.path: ["case\\s+apple", "case\\s+banana", "case\\s+pineapple"]]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 2)
            XCTAssertEqual(violations.compactMap { ($0 as? FileViolation)?.line }, [2, 3])
        }

        resourcesLoaded([fruitEnumResource]) {
            let optionsDict = ["not_matching_any": [fruitEnumResource.path: ["case\\s+kiwi", "case\\s+grapefruit", "case\\s+pineapple"]]]
            let rule = FileContentRegexRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 0)
        }
    }
}
