import Foundation
import HandySwift
import SwiftCLI

protocol Rule {
    static var name: String { get }
    static var identifier: String { get }

    init(_ optionsDict: [String: Any])
    func violations(in directory: URL) -> [Violation]
}

extension Rule {
    @available(OSX 10.12, *)
    func printDiffSummary(fileName: String, found: String, expected: String, printLevel: PrintLevel) {
        let tmpDirUrl = FileManager.default.temporaryDirectory.appendingPathComponent(".projlint")
        let foundTmpFileUrl = tmpDirUrl.appendingPathComponent("\(fileName).found")
        let expectedTmpFileUrl = tmpDirUrl.appendingPathComponent("\(fileName).expected")

        let foundTmpFileData = found.data(using: .utf8)
        let expectedTmpFileData = expected.data(using: .utf8)

        do {
            try FileManager.default.createFile(at: foundTmpFileUrl, withIntermediateDirectories: true, contents: foundTmpFileData, attributes: [:])
            try FileManager.default.createFile(at: expectedTmpFileUrl, withIntermediateDirectories: true, contents: expectedTmpFileData, attributes: [:])

            let diffOutput = try capture(bash: "git diff \(foundTmpFileUrl.path) \(expectedTmpFileUrl.path) || true").stdout
            print(diffOutput, level: printLevel)

            try FileManager.default.removeContentsOfDirectory(at: tmpDirUrl)
        } catch {
            print("Ignored an error: \(error)", level: .verbose)
        }
    }
}
