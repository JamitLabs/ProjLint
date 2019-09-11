@testable import ProjLintKit
import XCTest

final class FileExistenceRuleTests: XCTestCase {
    let infoPlistResource = Resource(path: "Sources/SuportingFiles/Info.plist", contents: "<plist></plist>")

    func testExistingPaths() {
        resourcesLoaded([infoPlistResource]) {
            let optionsDict = ["existing_paths": [infoPlistResource.relativePath]]
            let rule = FileExistenceRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssert(violations.isEmpty)
        }

        resourcesLoaded([]) {
            let optionsDict = ["existing_paths": [infoPlistResource.relativePath]]
            let rule = FileExistenceRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 1)
        }
    }

    func testNonExistingPaths() {
        resourcesLoaded([infoPlistResource]) {
            let optionsDict = ["non_existing_paths": [infoPlistResource.relativePath]]
            let rule = FileExistenceRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 1)
        }

        resourcesLoaded([]) {
            let optionsDict = ["non_existing_paths": [infoPlistResource.relativePath]]
            let rule = FileExistenceRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssert(violations.isEmpty)
        }
    }

    func testAllowedPathsWithValidRegex() {
        resourcesLoaded([infoPlistResource]) {
            let optionsDict = ["allowed_paths_regex": [#"Sources/SuportingFiles/Info\.plist"#]]
            let rule = FileExistenceRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 0)
        }

        resourcesLoaded([infoPlistResource]) {
            let optionsDict = ["allowed_paths_regex": [#"Sources/SuportingFiles/Info2\.plist"#]]
            let rule = FileExistenceRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 1)
            XCTAssertEqual(violations.compactMap { ($0 as? FileViolation)?.url.relativePath }, [infoPlistResource.relativePath])
            XCTAssertEqual(violations.compactMap { ($0 as? FileViolation)?.message }, ["File exists, but it mustn\'t."])
        }

        resourcesLoaded([infoPlistResource]) {
            let optionsDict = ["allowed_paths_regex": [#"Sources/SuportingFiles/.*"#]]
            let rule = FileExistenceRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 0)
        }

        resourcesLoaded([infoPlistResource]) {
            let optionsDict = ["allowed_paths_regex": [#".*"#]]
            let rule = FileExistenceRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 0)
        }

        resourcesLoaded([infoPlistResource]) {
            let optionsDict = ["allowed_paths_regex": [#".*\.png"#]]
            let rule = FileExistenceRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 1)
            XCTAssertEqual(violations.compactMap { ($0 as? FileViolation)?.url.relativePath }, [infoPlistResource.relativePath])
            XCTAssertEqual(violations.compactMap { ($0 as? FileViolation)?.message }, ["File exists, but it mustn\'t."])
        }
    }

    func testAllowedPathsWithInvalidRegex() {
        let invalidRegex = #"["#
        let optionsDict = ["allowed_paths_regex": [invalidRegex]]
        let rule = FileExistenceRule(optionsDict)

        let violations = rule.violations(in: Resource.baseUrl)
        XCTAssertEqual(violations.count, 1)
        XCTAssertEqual(violations.map { $0.message }, ["The following regex is not valid: \'[\'"])
    }

    func testAllowedPathsWithSamePathInOtherRules() {
        resourcesLoaded([infoPlistResource]) {
            let optionsDict = [
                "existing_paths": [infoPlistResource.relativePath],
                "allowed_paths_regex": [#"ThisIsARandomPathThatDoesNotMatch"#]
            ]
            let rule = FileExistenceRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 0)
        }
    }
}
