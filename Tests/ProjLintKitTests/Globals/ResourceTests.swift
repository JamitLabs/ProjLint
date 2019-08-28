import XCTest

final class ResourceTest: XCTestCase {
    private let resource = Resource(
        path: "directory/Resource.swift",
        contents: ""
    )

    func testRelativePath() {
        XCTAssertEqual(resource.relativePath, "directory/Resource.swift")
    }
}
