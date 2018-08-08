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
        let foundTmpFilePath = tmpDirUrl.appendingPathComponent("\(fileName).found").path
        let expectedTmpFilePath = tmpDirUrl.appendingPathComponent("\(fileName).expected").path

        let foundTmpFileData = found.data(using: .utf8)
        let expectedTmpFileData = expected.data(using: .utf8)

        do {
            try FileManager.default.createFile(atPath: foundTmpFilePath, withIntermediateDirectories: true, contents: foundTmpFileData, attributes: [:])
            try FileManager.default.createFile(atPath: expectedTmpFilePath, withIntermediateDirectories: true, contents: expectedTmpFileData, attributes: [:])

            let diffOutput = try capture(bash: "git diff \(foundTmpFilePath) \(expectedTmpFilePath) || true").stdout
            print(diffOutput, level: printLevel)

            try FileManager.default.removeContentsOfDirectory(at: tmpDirUrl)
        } catch {
            print("Ignored an error: \(error)", level: .verbose)
        }
    }
}
