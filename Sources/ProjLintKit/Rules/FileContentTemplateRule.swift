import Differ
import Foundation
import HandySwift
import Stencil
import SwiftCLI

struct FileContentTemplateRule: Rule {
    static let name: String = "File Content Template"
    static let identifier: String = "file_content_template"

    private let defaultViolationLevel: ViolationLevel = .warning
    private let options: FileContentTemplateOptions

    init(_ optionsDict: [String: Any]) {
        options = FileContentTemplateOptions(optionsDict, rule: type(of: self))
    }

    func violations(in directory: URL) -> [Violation] {
        var violations = [Violation]()

        for (path, templateWithParams) in options.matchingPathTemplate {
            let url = URL(fileURLWithPath: path)
            let file = File(at: url)
            let templateFile = File(at: templateWithParams.url)
            let template = Template(templateString: templateFile.contents)
            guard let expectedFileContents = try? template.render(templateWithParams.parameters) else {
                print("Could not render template at path '\(templateFile.url)'.", level: .error)
                exit(EXIT_FAILURE)
            }

            if file.contents != expectedFileContents {
                printDiffSummary(fileName: url.lastPathComponent, found: file.contents, expected: expectedFileContents)

                violations.append(
                    FileViolation(
                        rule: self,
                        message: "Contents of file differ from expected contents.",
                        level: .warning,
                        path: path
                    )
                )
            }
        }

        return violations
    }

    func printDiffSummary(fileName: String, found: String, expected: String) {
        let tmpDirUrl = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".projlint/tmp")
        let foundTmpFilePath = tmpDirUrl.appendingPathComponent("\(fileName).found").path
        let expectedTmpFilePath = tmpDirUrl.appendingPathComponent("\(fileName).expected").path

        let foundTmpFileData = found.data(using: .utf8)
        let expectedTmpFileData = expected.data(using: .utf8)

        do {
            try FileManager.default.createFile(atPath: foundTmpFilePath, withIntermediateDirectories: true, contents: foundTmpFileData, attributes: [:])
            try FileManager.default.createFile(atPath: expectedTmpFilePath, withIntermediateDirectories: true, contents: expectedTmpFileData, attributes: [:])

            try run(bash: "git diff \(foundTmpFilePath) \(expectedTmpFilePath)")

            try FileManager.default.removeContentsOfDirectory(at: tmpDirUrl)
        } catch {
            print("Ignored an error: \(error)", level: .verbose)
        }
    }
}
