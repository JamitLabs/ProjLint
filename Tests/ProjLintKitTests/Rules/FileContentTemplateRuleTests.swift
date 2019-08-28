@testable import ProjLintKit
import XCTest

final class FileContentTemplateRuleTests: XCTestCase {
    let swiftlintConfigExample = Resource(
        path: ".swiftlint.yml",
        contents: """
            # Basic Configuration
            opt_in_rules:
            - attributes
            - empty_count
            - sorted_imports

            disabled_rules:
            - type_name

            included:
            - Sources
            - Tests

            # Rule Configurations
            identifier_name:
              excluded:
                - id

            line_length: 160

            """
    )

    let swiftlintConfigTemplate = Resource(
        path: "SwiftLint.stencil",
        contents: """
            # Basic Configuration
            opt_in_rules:{% for rule in additionalRules %}\n- {{ rule }}{% endfor %}

            disabled_rules:
            - type_name

            included:
            - Sources
            - Tests

            # Rule Configurations
            identifier_name:
              excluded:
                - id

            line_length: {{ lineLength }}

            """
    )

    func testMatchingPathTemplateViaPath() {
        resourcesLoaded([swiftlintConfigExample, swiftlintConfigTemplate]) {
            let optionsDict = [
                "matching": [
                    swiftlintConfigExample.relativePath: [
                        "template_path": swiftlintConfigTemplate.relativePath,
                        "parameters": [
                            "additionalRules": ["attributes", "empty_count", "sorted_imports"],
                            "lineLength": "160"
                        ]
                    ]
                ]
            ]
            let rule = FileContentTemplateRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 0)
        }

        resourcesLoaded([swiftlintConfigExample, swiftlintConfigTemplate]) {
            let optionsDict = [
                "matching": [
                    swiftlintConfigExample.relativePath: [
                        "template_path": swiftlintConfigTemplate.relativePath,
                        "parameters": [
                            "additionalRules": ["attributes", "sorted_imports", "yoda_condition"],
                            "lineLength": "80"
                        ]
                    ]
                ]
            ]
            let rule = FileContentTemplateRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 1)
            XCTAssert(violations.first is FileViolation)
        }
    }
}
