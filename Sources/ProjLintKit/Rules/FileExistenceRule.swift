import Foundation
import HandySwift

struct FileExistenceRule: Rule {
    static let name: String = "File Existence"
    static let identifier: String = "file_existence"

    private let defaultViolationLevel: ViolationLevel = .warning
    private let options: FileExistenceOptions

    init(_ optionsDict: [String: Any]) {
        options = FileExistenceOptions(optionsDict, rule: type(of: self))
    }

    func violations(in directory: URL) -> [Violation] {
        var violations = [Violation]()

        if let existingPaths = options.existingPaths {
            for path in existingPaths {
                let url = URL(fileURLWithPath: path, relativeTo: directory)
                if !FileManager.default.fileExists(atPath: url.path) {
                    violations.append(
                        FileViolation(
                            rule: self,
                            message: "Expected file to exist but didn't.",
                            level: options.violationLevel(defaultTo: defaultViolationLevel),
                            url: url
                        )
                    )
                }
            }
        }

        if let nonExistingPaths = options.nonExistingPaths {
            for path in nonExistingPaths {
                let url = URL(fileURLWithPath: path, relativeTo: directory)
                if FileManager.default.fileExists(atPath: url.path) {
                    violations.append(
                        FileViolation(
                            rule: self,
                            message: "Expected file not to exist but existed.",
                            level: options.violationLevel(defaultTo: defaultViolationLevel),
                            url: url
                        )
                    )
                }
            }
        }

        if let allowedPathsRegex = options.allowedPathsRegex {
            let allowedPathsViolations = violationsForAllowedPaths(allowedPathsRegex, in: directory)
            violations.append(contentsOf: allowedPathsViolations)
        }

        return violations
    }

    private func violationsForAllowedPaths(_ allowedPathsRegex: [String], in directory: URL) -> [Violation] {
        var violations: [Violation] = []

        // Start by getting an array of all files under the directory.
        // After, remove all files that are allowed, until ending up with the list of notAllowedFiles
        var notAllowedFiles = recursivelyGetFiles(at: directory)

        // Do not check for paths that are already linted by previous projlint rules
        let existingPaths = options.existingPaths?.map { URL(fileURLWithPath: $0, relativeTo: directory) } ?? []
        let nonExistingPaths = options.nonExistingPaths?.map { URL(fileURLWithPath: $0, relativeTo: directory) } ?? []
        let pathsAlreadyLinted = existingPaths + nonExistingPaths
        notAllowedFiles.removeAll { existingFile in
            pathsAlreadyLinted.contains { $0.path == existingFile.path }
        }

        for allowedPathPattern in allowedPathsRegex {
            guard let allowedPathRegex = try? Regex("^\(allowedPathPattern)$") else {
                let violation = Violation(
                    rule: self,
                    message: "The following regex is not valid: '\(allowedPathPattern)'",
                    level: .error
                )
                violations.append(violation)
                break
            }

            notAllowedFiles.removeAll { allowedPathRegex.matches($0.relativePath) }
        }

        notAllowedFiles.forEach {
            let violation = FileViolation(
                rule: self,
                message: "File exists, but it mustn't.",
                level: options.violationLevel(defaultTo: defaultViolationLevel),
                path: $0.path
            )
            violations.append(violation)
        }

        return violations
    }

    private func recursivelyGetFiles(at currentUrl: URL) -> [URL] {
        var files: [URL] = []

        let resourceKeys: [URLResourceKey] = [.creationDateKey, .isRegularFileKey]
        let enumerator = FileManager.default.enumerator(
            at: currentUrl,
            includingPropertiesForKeys: resourceKeys
            )!

        for case let fileUrl as URL in enumerator {
            // Rationale: force-try is ok. This can never fail, as the resourceKeys passed here are also passed to the enumerator
            // swiftlint:disable:next force_try
            let resourceValues = try! fileUrl.resourceValues(forKeys: Set(resourceKeys))
            // Force-unwrap is ok: this can never fail, as the isRegularFileKey resource key is passed previously to the enumerator
            if resourceValues.isRegularFile! {
                let url = URL(fileURLWithPath: fileUrl.path.replacingOccurrences(of: "\(currentUrl.path)/", with: ""), relativeTo: currentUrl)
                files.append(url)
            }
        }

        return files
    }
}
