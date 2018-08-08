import HandySwift
@testable import ProjLintKit
import XCTest

final class XcodeBuildPhasesOptionsTests: XCTestCase {
    func testInitWithAllOptions() {
        let runScriptsValueType = FakerType.dict(keyType: .filePath, valueType: .text, count: 3)
        let optionsDict = [
            "project_path": Faker.first.data(ofType: .filePath),
            "target_name": Faker.first.data(ofType: .text),
            "run_scripts": Faker.first.data(ofType: runScriptsValueType)
        ]

        let options = XcodeBuildPhasesOptions(optionsDict, rule: XcodeBuildPhasesRule.self)

        XCTAssertEqual(options.runScripts.count, 3)
    }
}
