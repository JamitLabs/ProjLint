import HandySwift
@testable import ProjLintKit
import XCTest

final class FileContentRegexOptionsTests: XCTestCase {
    func testInitWithMatchingRegex() {
        let valueType = FakerType.dict(keyType: .filePath, valueType: .regexString, count: 5)
        let optionsDict = ["matching": Faker.first.data(ofType: valueType)]

        let options = FileContentRegexOptions(optionsDict, rule: FileContentRegexRule.self)

        XCTAssert(options.matchingRegex != nil)
        XCTAssertEqual(options.matchingRegex!.count, 5)
    }

    func testInitWithMatchingAllPathRegexes() {
        // TODO: not yet implemented
    }

    func testInitWithMatchingAnyPathRegexes() {
        // TODO: not yet implemented
    }

    func testInitWithNotMatchingRegex() {
        // TODO: not yet implemented
    }

    func testInitWithNotMatchingAllPathRegexes() {
        // TODO: not yet implemented
    }

    func testInitWithNotMatchingAnyPathRegexes() {
        // TODO: not yet implemented
    }

    func testInitWithAllOptions() {
        // TODO: not yet implemented
    }
}
