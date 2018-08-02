@testable import ProjLintKit
import XCTest

final class FileExistenceOptionsTests: XCTestCase {
    func testInitWithExistingPaths() {
        let valueType = FakerType.array(elementType: .filePath, count: 5)
        let optionsDict = ["existing_paths": Faker.first.data(ofType: valueType)]

        let options = FileExistenceOptions(optionsDict, rule: FileExistenceRule.self)

        XCTAssert(options.existingPaths != nil)
        XCTAssertEqual(options.existingPaths!.count, 5)
    }

    func testInitWithNonExistingPaths() {
        let valueType = FakerType.array(elementType: .filePath, count: 5)
        let optionsDict = ["non_existing_paths": Faker.first.data(ofType: valueType)]

        let options = FileExistenceOptions(optionsDict, rule: FileExistenceRule.self)

        XCTAssert(options.nonExistingPaths != nil)
        XCTAssertEqual(options.nonExistingPaths!.count, 5)
    }
}
