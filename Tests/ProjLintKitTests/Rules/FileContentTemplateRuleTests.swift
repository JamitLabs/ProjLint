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
            opt_in_rules:
            - attributes{% for rule in additionalRules %}\n- {{ rule }}{% endfor %}

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

    func testMatchingPathTemplate() {
        resourcesLoaded([swiftlintConfigExample, swiftlintConfigTemplate]) {
            let optionsDict = [
                "matching": [
                    swiftlintConfigExample.path: [
                        "template": swiftlintConfigTemplate.path,
                        "parameters": [
                            "additionalRules": ["empty_count", "sorted_imports"],
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
                    swiftlintConfigExample.path: [
                        "template": swiftlintConfigTemplate.path,
                        "parameters": [
                            "additionalRules": ["empty_count"],
                            "lineLength": "80"
                        ]
                    ]
                ]
            ]
            let rule = FileContentTemplateRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 2)

            let fileViolations = violations.compactMap { $0 as? FileViolation }
            XCTAssertEqual(fileViolations.count, 2)
            XCTAssertEqual(fileViolations.compactMap { $0.line }, [5, 19])
        }
    }
}
