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
}
