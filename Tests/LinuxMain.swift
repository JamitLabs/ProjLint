// Generated using Sourcery 0.13.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

@testable import ProjLintKitTests
import XCTest

// swiftlint:disable line_length file_length

extension FileContentRegexOptionsTests {
    static var allTests: [(String, (FileContentRegexOptionsTests) -> () throws -> Void)] = [
        ("testInitWithMatchingPathRegex", testInitWithMatchingPathRegex),
        ("testInitWithMatchingAllPathRegexes", testInitWithMatchingAllPathRegexes),
        ("testInitWithMatchingAnyPathRegexes", testInitWithMatchingAnyPathRegexes),
        ("testInitWithNotMatchingPathRegex", testInitWithNotMatchingPathRegex),
        ("testInitWithNotMatchingAllPathRegexes", testInitWithNotMatchingAllPathRegexes),
        ("testInitWithNotMatchingAnyPathRegexes", testInitWithNotMatchingAnyPathRegexes)
    ]
}

extension FileContentRegexRuleTests {
    static var allTests: [(String, (FileContentRegexRuleTests) -> () throws -> Void)] = [
        ("testMatchingRegex", testMatchingRegex),
        ("testMatchingAllPathRegexes", testMatchingAllPathRegexes),
        ("testMatchingAnyPathRegexes", testMatchingAnyPathRegexes),
        ("testNotMatchingRegex", testNotMatchingRegex),
        ("testNotMatchingAllPathRegexes", testNotMatchingAllPathRegexes),
        ("testNotMatchingAnyPathRegexes", testNotMatchingAnyPathRegexes)
    ]
}

extension FileContentTemplateOptionsTests {
    static var allTests: [(String, (FileContentTemplateOptionsTests) -> () throws -> Void)] = [
        ("testInitWithMatchingPathTemplateViaPath", testInitWithMatchingPathTemplateViaPath),
        ("testInitWithMatchingPathTemplateViaURL", testInitWithMatchingPathTemplateViaURL)
    ]
}

extension FileContentTemplateRuleTests {
    static var allTests: [(String, (FileContentTemplateRuleTests) -> () throws -> Void)] = [
        ("testMatchingPathTemplateViaPath", testMatchingPathTemplateViaPath),
        ("testMatchingPathTemplateViaURL", testMatchingPathTemplateViaURL)
    ]
}

extension FileExistenceOptionsTests {
    static var allTests: [(String, (FileExistenceOptionsTests) -> () throws -> Void)] = [
        ("testInitWithExistingPaths", testInitWithExistingPaths),
        ("testInitWithNonExistingPaths", testInitWithNonExistingPaths)
    ]
}

extension FileExistenceRuleTests {
    static var allTests: [(String, (FileExistenceRuleTests) -> () throws -> Void)] = [
        ("testExistingPaths", testExistingPaths),
        ("testNonExistingPaths", testNonExistingPaths)
    ]
}

extension XcodeBuildPhasesOptionsTests {
    static var allTests: [(String, (XcodeBuildPhasesOptionsTests) -> () throws -> Void)] = [
        ("testInitWithAllOptions", testInitWithAllOptions)
    ]
}

extension XcodeBuildPhasesRuleTests {
    static var allTests: [(String, (XcodeBuildPhasesRuleTests) -> () throws -> Void)] = [
        ("testAllOptions", testAllOptions)
    ]
}

extension XcodeProjectNavigatorOptionsTests {
    static var allTests: [(String, (XcodeProjectNavigatorOptionsTests) -> () throws -> Void)] = [
        ("testInitWithAllOptions", testInitWithAllOptions)
    ]
}

extension XcodeProjectNavigatorRuleTests {
    static var allTests: [(String, (XcodeProjectNavigatorRuleTests) -> () throws -> Void)] = [
        ("testWithAllOptions", testWithAllOptions)
    ]
}

XCTMain([
    testCase(FileContentRegexOptionsTests.allTests),
    testCase(FileContentRegexRuleTests.allTests),
    testCase(FileContentTemplateOptionsTests.allTests),
    testCase(FileContentTemplateRuleTests.allTests),
    testCase(FileExistenceOptionsTests.allTests),
    testCase(FileExistenceRuleTests.allTests),
    testCase(XcodeBuildPhasesOptionsTests.allTests),
    testCase(XcodeBuildPhasesRuleTests.allTests),
    testCase(XcodeProjectNavigatorOptionsTests.allTests),
    testCase(XcodeProjectNavigatorRuleTests.allTests)
])
