import Foundation
import HandySwift

extension FileManager {
    var currentDirectoryUrl: URL {
        // Rationale: here we are sure that the string passed to the URL is absolute, so there is no need for a base directory
        // swiftlint:disable:next url_should_have_relative
        return URL(fileURLWithPath: currentDirectoryPath)
    }

    func removeContentsOfDirectory(at url: URL, options mask: FileManager.DirectoryEnumerationOptions = []) throws {
        guard fileExists(atPath: url.path) else { return }
        for suburl in try contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: mask) {
            try FileManager.default.removeItem(at: suburl)
        }
    }

    func createFile(at url: URL, withIntermediateDirectories: Bool, contents: Data?, attributes: [FileAttributeKey: Any]?) throws {
        let directoryUrl = url.deletingLastPathComponent()

        if withIntermediateDirectories && !FileManager.default.fileExists(atPath: directoryUrl.path) {
            try createDirectory(at: directoryUrl, withIntermediateDirectories: true, attributes: attributes)
        }

        createFile(atPath: url.path, contents: contents, attributes: attributes)
    }
}
