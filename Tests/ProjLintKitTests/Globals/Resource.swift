import Foundation
import HandySwift

struct Resource {
    static let baseUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(".testResources")

    let path: String
    let contents: String

    var data: Data? {
        return contents.data(using: .utf8)
    }

    init(path: String, contents: String) {
        self.path = Resource.baseUrl.appendingPathComponent(path).path
        self.contents = contents
    }
}
