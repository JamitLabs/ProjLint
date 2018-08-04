import Differ
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

        if let matchingPathTemplate = options.matchingPathTemplate {
            for (path, templateWithParams) in matchingPathTemplate {
                let file = File(at: path)
                let templateFile = File(at: templateWithParams.url.path)
                let template = Template(templateString: templateFile.contents)
                guard let expectedFileContents = try? template.render(templateWithParams.parameters) else {
                    print("Could not render template at path '\(templateFile.path)'.", level: .error)
                    exit(EXIT_FAILURE)
                }

                let diff = file.contents.diff(expectedFileContents)
                let differingLines: [Int] = diff.elements.compactMap { element in
                    switch element {
                    case let .insert(index), let .delete(index):
                        let character = Unicode.Scalar(String(file.contents.char(at: index)))!
                        guard !CharacterSet.whitespacesAndNewlines.contains(character) else { return nil }
                        return file.contents.line(forIndex: index)
                    }
                }

                for differingLine in Set(differingLines).sorted() {
                    violations.append(
                        FileViolation(
                            rule: self,
                            message: "Line differs from template.",
                            level: .warning,
                            path: path,
                            line: differingLine
                        )
                    )
                    print("Found delete difference at line \(differingLine). Found:\n\(file.contents)\nExpected:\n\(expectedFileContents)", level: .info)
                }
            }
        }

        return violations
    }
}
