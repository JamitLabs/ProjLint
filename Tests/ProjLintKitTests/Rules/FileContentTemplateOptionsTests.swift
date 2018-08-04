import HandySwift
@testable import ProjLintKit
import XCTest

final class FileContentTemplateOptionsTests: XCTestCase {
    func testInitWithMatchingPathTemplate() {
        let parametersType = FakerType.dict(keyType: .variable, valueType: .text, count: 3)
        let optionsDict: [String: Any] = [
            "matching": [
                (Faker.first.data(ofType: .filePath) as! String): [
                    "template": Faker.first.data(ofType: .filePath),
                    "parameters": Faker.first.data(ofType: parametersType)
                ]
            ]
        ]
        let options = FileContentTemplateOptions(optionsDict, rule: FileContentTemplateRule.self)

        XCTAssert(options.matchingPathTemplate != nil)
        XCTAssertEqual(options.matchingPathTemplate!.count, 1)
    }

    func testInitWithNotMatchingPathTemplate() {
        let parametersType = FakerType.dict(keyType: .variable, valueType: .text, count: 3)
        let optionsDict: [String: Any] = [
            "not_matching": [
                (Faker.first.data(ofType: .filePath) as! String): [
                    "template": Faker.first.data(ofType: .filePath),
                    "parameters": Faker.first.data(ofType: parametersType)
                ]
            ]
        ]
        let options = FileContentTemplateOptions(optionsDict, rule: FileContentTemplateRule.self)

        XCTAssert(options.notMatchingPathTemplate != nil)
        XCTAssertEqual(options.notMatchingPathTemplate!.count, 1)
    }
}
