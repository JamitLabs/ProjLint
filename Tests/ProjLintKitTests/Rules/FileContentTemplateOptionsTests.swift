import HandySwift
@testable import ProjLintKit
import XCTest

final class FileContentTemplateOptionsTests: XCTestCase {
    func testInitWithMatchingPathTemplate() {
        let valueType = FakerType.dict(keyType: .filePath, valueType: .filePath, count: 5)
        let optionsDict = ["matching": Faker.first.data(ofType: valueType)]

        let options = FileContentTemplateOptions(optionsDict, rule: FileContentTemplateRule.self)

        XCTAssert(options.matchingPathTemplate != nil)
        XCTAssertEqual(options.matchingPathTemplate!.count, 5)
    }

    func testInitWithNotMatchingPathTemplate() {
        let valueType = FakerType.dict(keyType: .filePath, valueType: .filePath, count: 5)
        let optionsDict = ["not_matching": Faker.first.data(ofType: valueType)]

        let options = FileContentTemplateOptions(optionsDict, rule: FileContentTemplateRule.self)

        XCTAssert(options.notMatchingPathTemplate != nil)
        XCTAssertEqual(options.notMatchingPathTemplate!.count, 5)
    }
}
