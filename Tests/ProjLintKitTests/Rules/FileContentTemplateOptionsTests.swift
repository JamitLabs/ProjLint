import HandySwift
@testable import ProjLintKit
import XCTest

final class FileContentTemplateOptionsTests: XCTestCase {
    func testInitWithMatchingPathTemplateViaPath() {
        let parametersType = FakerType.dict(keyType: .variable, valueType: .text, count: 3)
        let optionsDict: [String: Any] = [
            "matching": [
                (Faker.first.data(ofType: .filePath) as! String): [
                    "template_path": Faker.first.data(ofType: .filePath),
                    "parameters": Faker.first.data(ofType: parametersType)
                ]
            ]
        ]
        let options = FileContentTemplateOptions(optionsDict, rule: FileContentTemplateRule.self)
        XCTAssertEqual(options.matchingPathTemplate.count, 1)
    }

    func testInitWithMatchingPathTemplateViaURL() {
        let parametersType = FakerType.dict(keyType: .variable, valueType: .text, count: 3)
        let optionsDict: [String: Any] = [
            "matching": [
                (Faker.first.data(ofType: .filePath) as! String): [
                    "template_url": Faker.first.data(ofType: .fileURL),
                    "parameters": Faker.first.data(ofType: parametersType)
                ]
            ]
        ]
        let options = FileContentTemplateOptions(optionsDict, rule: FileContentTemplateRule.self)
        XCTAssertEqual(options.matchingPathTemplate.count, 1)
    }
}
