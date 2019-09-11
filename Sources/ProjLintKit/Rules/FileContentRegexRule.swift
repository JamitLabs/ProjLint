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
                let url = URL(fileURLWithPath: path, relativeTo: directory)
                let file = File(at: url)

                if !regex.matches(file.contents) {
                    violations.append(
                        FileViolation(
                            rule: self,
                            message: "Content didn't match regex '\(regex)' where it should.",
                            level: options.violationLevel(defaultTo: defaultViolationLevel),
                            url: url
                        )
                    )
                }
            }
        }

        if let matchingAllPathRegexes = options.matchingAllPathRegexes {
            for (path, regexes) in matchingAllPathRegexes {
                let url = URL(fileURLWithPath: path, relativeTo: directory)
                let file = File(at: url)

                for regex in regexes {
                    if !regex.matches(file.contents) {
                        violations.append(
                            FileViolation(
                                rule: self,
                                message: "Content didn't match regex '\(regex)' where it should.",
                                level: options.violationLevel(defaultTo: defaultViolationLevel),
                                url: url
                            )
                        )
                    }
                }
            }
        }

        if let matchingAnyPathRegexes = options.matchingAnyPathRegexes {
            for (path, regexes) in matchingAnyPathRegexes {
                let url = URL(fileURLWithPath: path, relativeTo: directory)
                let file = File(at: url)
                if regexes.first(where: { $0.matches(file.contents) }) == nil {
                    violations.append(
                        FileViolation(
                            rule: self,
                            message: "Content didn't match any of the regexes: '\(regexes)'.",
                            level: options.violationLevel(defaultTo: defaultViolationLevel),
                            url: url
                        )
                    )
                }
            }
        }

        if let notMatchingRegex = options.notMatchingPathRegex {
            for (path, regex) in notMatchingRegex {
                let url = URL(fileURLWithPath: path, relativeTo: directory)
                let file = File(at: url)

                regex.matches(in: file.contents).forEach {
                    let violation = FileViolation(
                        rule: self,
                        message: "Content matched regex '\(regex)' where it shouldn't.",
                        level: options.violationLevel(defaultTo: defaultViolationLevel),
                        url: url,
                        line: file.contents.lineIndex(for: $0.range.lowerBound)
                    )
                    violations.append(violation)
                }
            }
        }

        if let notMatchingAllPathRegexes = options.notMatchingAllPathRegexes {
            for (path, regexes) in notMatchingAllPathRegexes {
                let url = URL(fileURLWithPath: path, relativeTo: directory)
                let file = File(at: url)

                var notMatchingAllViolations: [FileViolation] = []
                var allRegexMatched = true
                for regex in regexes {
                    let matches = regex.matches(in: file.contents)
                    if matches.isEmpty {
                        allRegexMatched = false
                        break
                    }

                    matches.forEach {
                        let violation = FileViolation(
                            rule: self,
                            message: "Not matching all. Content matched regex '\(regex)' where it shouldn't.",
                            level: options.violationLevel(defaultTo: defaultViolationLevel),
                            url: url,
                            line: file.contents.lineIndex(for: $0.range.lowerBound)
                        )
                        notMatchingAllViolations.append(violation)
                    }
                }

                if allRegexMatched {
                    violations.append(contentsOf: notMatchingAllViolations)
                }
            }
        }

        if let notMatchingAnyPathRegexes = options.notMatchingAnyPathRegexes {
            for (path, regexes) in notMatchingAnyPathRegexes {
                let url = URL(fileURLWithPath: path, relativeTo: directory)
                let file = File(at: url)

                for regex in regexes {
                    regex.matches(in: file.contents).forEach {
                        let violation = FileViolation(
                            rule: self,
                            message: "Content matched regex '\(regex)' where it shouldn't.",
                            level: options.violationLevel(defaultTo: defaultViolationLevel),
                            url: url,
                            line: file.contents.lineIndex(for: $0.range.lowerBound)
                        )
                        violations.append(violation)
                    }
                }
            }
        }

        return violations
    }
}
