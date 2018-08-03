import Foundation
import HandySwift

extension FileManager {
    func removeContentsOfDirectory(at url: URL) throws {
        let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: nil)

        while let subpath = enumerator?.nextObject() as? String {
            try FileManager.default.removeItem(at: url.appendingPathComponent(subpath))
        }
    }

    func createFile(atPath path: String, withIntermediateDirectories: Bool, contents: Data?, attributes: [FileAttributeKey: Any]?) throws {
        let directoryUrl = URL(fileURLWithPath: path).deletingLastPathComponent()

        if withIntermediateDirectories && !FileManager.default.fileExists(atPath: directoryUrl.path) {
            try createDirectory(at: directoryUrl, withIntermediateDirectories: true, attributes: attributes)
        }

        createFile(atPath: path, contents: contents, attributes: attributes)
    }
}
