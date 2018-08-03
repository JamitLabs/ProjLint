import Foundation
import HandySwift

struct FileContentRegexRule: Rule {
    static let name: String = "File Content Regex"
    static let identifier: String = "file_content_regex"

    private let defaultViolationLevel: ViolationLevel = .warning
    private let options: FileContentRegexOptions

    init(_ optionsDict: [String: Any]) {
        options = FileContentRegexOptions(optionsDict, rule: type(of: self))
    }

    func violations(in directory: URL) -> [Violation] { // swiftlint:disable:this cyclomatic_complexity function_body_length
        var violations = [Violation]()

        if let matchingRegex = options.matchingPathRegex {
            for (path, regex) in matchingRegex {
                let file = File(at: path)

                if !regex.matches(file.contents) {
                    violations.append(
                        FileViolation(
                            rule: self,
                            message: "Content didn't match regex '\(regex)' where it should.",
                            level: options.violationLevel(defaultTo: defaultViolationLevel),
                            path: path
                        )
                    )
                }
            }
        }

        if let matchingAllPathRegexes = options.matchingAllPathRegexes {
            for (path, regexes) in matchingAllPathRegexes {
                let file = File(at: path)

                for regex in regexes {
                    if !regex.matches(file.contents) {
                        violations.append(
                            FileViolation(
                                rule: self,
                                message: "Content didn't match regex '\(regex)' where it should.",
                                level: options.violationLevel(defaultTo: defaultViolationLevel),
                                path: path
                            )
                        )
                    }
                }
            }
        }

        if let matchingAnyPathRegexes = options.matchingAnyPathRegexes {
            for (path, regexes) in matchingAnyPathRegexes {
                let file = File(at: path)
                if regexes.first(where: { $0.matches(file.contents) }) == nil {
                    violations.append(
                        FileViolation(
                            rule: self,
                            message: "Content didn't match any of the regexes: '\(regexes)'.",
                            level: options.violationLevel(defaultTo: defaultViolationLevel),
                            path: path
                        )
                    )
                }
            }
        }

        if let notMatchingRegex = options.notMatchingPathRegex {
            for (path, regex) in notMatchingRegex {
                let file = File(at: path)

                if regex.matches(file.contents) {
                    violations.append(
                        FileViolation(
                            rule: self,
                            message: "Content matched regex '\(regex)' where it shouldn't.",
                            level: options.violationLevel(defaultTo: defaultViolationLevel),
                            path: path
                        )
                    )
                }
            }
        }

        if let notMatchingAllPathRegexes = options.notMatchingAllPathRegexes {
            for (path, regexes) in notMatchingAllPathRegexes {
                let file = File(at: path)
                if regexes.first(where: { !$0.matches(file.contents) }) == nil {
                    violations.append(
                        FileViolation(
                            rule: self,
                            message: "Content matched all of the regexes: '\(regexes)'.",
                            level: options.violationLevel(defaultTo: defaultViolationLevel),
                            path: path
                        )
                    )
                }
            }
        }

        if let notMatchingAnyPathRegexes = options.notMatchingAnyPathRegexes {
            for (path, regexes) in notMatchingAnyPathRegexes {
                let file = File(at: path)

                for regex in regexes {
                    if regex.matches(file.contents) {
                        violations.append(
                            FileViolation(
                                rule: self,
                                message: "Content matched regex '\(regex)' where it shouldn't.",
                                level: options.violationLevel(defaultTo: defaultViolationLevel),
                                path: path
                            )
                        )
                    }
                }
            }
        }

        return violations
    }
}
