import HandySwift
@testable import ProjLintKit
import XCTest

final class XcodeProjectNavigatorOptionsTests: XCTestCase {
    func testInitWithAllOptions() {
        let optionsDict: [String: Any] = [
            "project_path": Faker.first.data(ofType: .filePath),
            "sorted": Faker.first.data(ofType: .array(elementType: .filePath, count: 5)),
            "inner_group_order": [
                "assets",
                ["strings", "others"],
                "folders",
                ["interfaces", "code_files"]
            ],
            "structure": [
                [
                    "App": [
                        [
                            "Resources": ["Test.swift"]
                        ],
                        "SupportingFiles"
                    ]
                ],
                "Tests",
                [
                    "UITests": ["UITestExample.swift"]
                ],
                "Products"
            ]
        ]

        let options = XcodeProjectNavigatorOptions(optionsDict, rule: XcodeProjectNavigatorRule.self)

        XCTAssertEqual(options.innerGroupOrder.count, 4)
        XCTAssertEqual(options.sorted?.count, 5)
        XCTAssertEqual(options.structure.count, 4)
    }
}
