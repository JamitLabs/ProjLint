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

        for (path, templateWithParams) in options.matchingPathTemplate {
            let url = URL(fileURLWithPath: path)
            let file = File(at: url)
            let templateFile = File(at: templateWithParams.url)
            let template = Template(templateString: templateFile.contents)
            guard let expectedFileContents = try? template.render(templateWithParams.parameters) else {
                print("Could not render template at path '\(templateFile.url)'.", level: .error)
                exit(EXIT_FAILURE)
            }

            let diff = file.contents.diff(expectedFileContents)
            var patchOffset = 0
            let differingLines: [Int] = diff.elements.compactMap { element in
                let index: Int = {
                    switch element {
                    case let .insert(index):
                        return index + patchOffset

                    case let .delete(index):
                        patchOffset -= 1
                        return index
                    }
                }()

                if let character = file.contents.char(at: index) {
                    let characterScalar = Unicode.Scalar(String(character))!
                    guard !CharacterSet.whitespacesAndNewlines.contains(characterScalar) else { return nil }
                } else {
                    print("Could not read character at index \(index) in template contents:\n\n\(file.contents)\n\n", level: .warning)
                }

                return file.contents.line(forIndex: index)
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
            }
        }

        return violations
    }
}
