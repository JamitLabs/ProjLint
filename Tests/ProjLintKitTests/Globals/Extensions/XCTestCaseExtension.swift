import Foundation
import XCTest

// swiftlint:disable force_try

extension XCTestCase {
    func resourcesLoaded(_ resources: [Resource], testCode: () -> Void) {
        try! FileManager.default.removeContentsOfDirectory(at: Resource.baseUrl)

        for resource in resources {
            try! FileManager.default.createFile(atPath: resource.path, withIntermediateDirectories: true, contents: resource.data, attributes: nil)
        }

        testCode()
        try! FileManager.default.removeContentsOfDirectory(at: Resource.baseUrl)
    }
}
