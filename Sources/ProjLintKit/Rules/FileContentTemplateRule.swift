import Foundation
import HandySwift
import Stencil

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
            let url = URL(fileURLWithPath: path, relativeTo: directory)
            let file = File(at: url)
            let templateFile = File(at: templateWithParams.originUrl(base: directory))

            guard templateFile.contents != Globals.networkErrorFakeString else {
                if Globals.ignoreNetworkErrors {
                    print("Skipped rule \(FileContentRegexRule.identifier) for file '\(url.path)'. Request resulted in a network error.", level: .info)
                    continue
                }

                print("Could not load contents of file '\(templateFile.url)' – the request resultes in a network error.", level: .error)
                exit(EXIT_FAILURE)
            }

            let template = Template(templateString: templateFile.contents)
            guard let expectedFileContents = try? template.render(templateWithParams.parameters) else {
                print("Could not render template at path '\(templateFile.url)'.", level: .error)
                exit(EXIT_FAILURE)
            }

            if file.contents != expectedFileContents {
                if #available(OSX 10.12, *) {
                    printDiffSummary(
                        fileName: url.lastPathComponent,
                        found: file.contents,
                        expected: expectedFileContents,
                        printLevel: defaultViolationLevel.printLevel
                    )
                }

                violations.append(
                    FileViolation(
                        rule: self,
                        message: "Contents of file differ from expected contents.",
                        level: defaultViolationLevel,
                        url: url
                    )
                )
            }
        }

        return violations
    }
}
