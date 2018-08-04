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
        XCTAssertEqual(options.matchingPathTemplate.count, 1)
    }
}
