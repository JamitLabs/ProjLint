import HandySwift
@testable import ProjLintKit
import XCTest

final class FileContentRegexOptionsTests: XCTestCase {
    func testInitWithMatchingPathRegex() {
        let valueType = FakerType.dict(keyType: .filePath, valueType: .regexString, count: 5)
        let optionsDict = ["matching": Faker.first.data(ofType: valueType)]

        let options = FileContentRegexOptions(optionsDict, rule: FileContentRegexRule.self)

        XCTAssert(options.matchingPathRegex != nil)
        XCTAssertEqual(options.matchingPathRegex!.count, 5)
    }

    func testInitWithMatchingAllPathRegexes() {
        let valueType = FakerType.dict(keyType: .filePath, valueType: .array(elementType: .regexString, count: 3), count: 5)
        let optionsDict = ["matching_all": Faker.first.data(ofType: valueType)]

        let options = FileContentRegexOptions(optionsDict, rule: FileContentRegexRule.self)

        XCTAssert(options.matchingAllPathRegexes != nil)
        XCTAssertEqual(options.matchingAllPathRegexes!.count, 5)

        let firstPathRegexes: [Regex] = options.matchingAllPathRegexes!.values.first!
        XCTAssertEqual(firstPathRegexes.count, 3)
    }

    func testInitWithMatchingAnyPathRegexes() {
        let valueType = FakerType.dict(keyType: .filePath, valueType: .array(elementType: .regexString, count: 3), count: 5)
        let optionsDict = ["matching_any": Faker.first.data(ofType: valueType)]

        let options = FileContentRegexOptions(optionsDict, rule: FileContentRegexRule.self)

        XCTAssert(options.matchingAnyPathRegexes != nil)
        XCTAssertEqual(options.matchingAnyPathRegexes!.count, 5)

        let firstPathRegexes: [Regex] = options.matchingAnyPathRegexes!.values.first!
        XCTAssertEqual(firstPathRegexes.count, 3)
    }

    func testInitWithNotMatchingPathRegex() {
        let valueType = FakerType.dict(keyType: .filePath, valueType: .regexString, count: 5)
        let optionsDict = ["not_matching": Faker.first.data(ofType: valueType)]

        let options = FileContentRegexOptions(optionsDict, rule: FileContentRegexRule.self)

        XCTAssert(options.notMatchingPathRegex != nil)
        XCTAssertEqual(options.notMatchingPathRegex!.count, 5)
    }

    func testInitWithNotMatchingAllPathRegexes() {
        let valueType = FakerType.dict(keyType: .filePath, valueType: .array(elementType: .regexString, count: 3), count: 5)
        let optionsDict = ["not_matching_all": Faker.first.data(ofType: valueType)]

        let options = FileContentRegexOptions(optionsDict, rule: FileContentRegexRule.self)

        XCTAssert(options.notMatchingAllPathRegexes != nil)
        XCTAssertEqual(options.notMatchingAllPathRegexes!.count, 5)

        let firstPathRegexes: [Regex] = options.notMatchingAllPathRegexes!.values.first!
        XCTAssertEqual(firstPathRegexes.count, 3)
    }

    func testInitWithNotMatchingAnyPathRegexes() {
        let valueType = FakerType.dict(keyType: .filePath, valueType: .array(elementType: .regexString, count: 3), count: 5)
        let optionsDict = ["not_matching_any": Faker.first.data(ofType: valueType)]

        let options = FileContentRegexOptions(optionsDict, rule: FileContentRegexRule.self)

        XCTAssert(options.notMatchingAnyPathRegexes != nil)
        XCTAssertEqual(options.notMatchingAnyPathRegexes!.count, 5)

        let firstPathRegexes: [Regex] = options.notMatchingAnyPathRegexes!.values.first!
        XCTAssertEqual(firstPathRegexes.count, 3)
    }
}
