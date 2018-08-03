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

XCTMain([
    testCase(FileContentRegexOptionsTests.allTests),
    testCase(FileContentRegexRuleTests.allTests),
    testCase(FileExistenceOptionsTests.allTests),
    testCase(FileExistenceRuleTests.allTests)
])
