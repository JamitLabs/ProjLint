import Foundation
import HandySwift
@testable import ProjLintKit
import XCTest

struct Resource {
    static let baseUrl = FileManager.default.currentDirectoryUrl.appendingPathComponent(".testResources", isDirectory: true)

    let contents: String

    // When using a projlint.yml file, all paths used there are relative.
    // Thus, in order to ensure that during tests the paths used are also relative,
    // only the relativePath is exposed, and not the whole URL object
    var relativePath: String {
        return url.relativePath
    }

    // The url is declared fileprivate in order to use it in the only place that an
    // absolute path is needed: at resource creation (the extension below)
    fileprivate let url: URL

    var data: Data? {
        return contents.data(using: .utf8)
    }

    init(path: String, contents: String) {
        self.url = URL(fileURLWithPath: path, relativeTo: Resource.baseUrl)
        self.contents = contents
    }
}

// swiftlint:disable force_try

extension XCTestCase {
    func resourcesLoaded(_ resources: [Resource], testCode: () -> Void) {
        try! FileManager.default.removeContentsOfDirectory(at: Resource.baseUrl)

        for resource in resources {
            try! FileManager.default.createFile(at: resource.url, withIntermediateDirectories: true, contents: resource.data, attributes: nil)
        }

        testCode()
        try! FileManager.default.removeContentsOfDirectory(at: Resource.baseUrl)
    }
}
