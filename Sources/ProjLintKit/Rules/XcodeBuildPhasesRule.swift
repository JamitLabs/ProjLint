import Foundation
import HandySwift
import xcodeproj

struct XcodeBuildPhasesRule: Rule {
    static let name: String = "Xcode Build Phases"
    static let identifier: String = "xcode_build_phases"

    private let defaultViolationLevel: ViolationLevel = .warning
    private let options: XcodeBuildPhasesOptions

    init(_ optionsDict: [String: Any]) {
        options = XcodeBuildPhasesOptions(optionsDict, rule: type(of: self))
    }

    func violations(in directory: URL) -> [Violation] {
        var violations = [Violation]()

        let absolutePathUrl = URL(fileURLWithPath: options.projectPath)
        guard let xcodeProj = try? XcodeProj(pathString: absolutePathUrl.path) else {
            print("Could not read project file at path '\(absolutePathUrl.path)'.", level: .error)
            exit(EXIT_FAILURE)
        }

        guard let target = xcodeProj.pbxproj.objects.targets(named: options.targetName).first else {
            print("Target with name '\(options.targetName)' could not be found in project \(options.projectPath).", level: .error)
            exit(EXIT_FAILURE)
        }

        let allRunScriptsDict = xcodeProj.pbxproj.objects.shellScriptBuildPhases
        let targetRunScripts = target.buildPhasesReferences.compactMap { allRunScriptsDict[$0] }

        for (name, expectedScript) in options.runScripts {
            guard let runScript = targetRunScripts.first(where: { $0.name == name }) else {
                violations.append(
                    FileViolation(
                        rule: self,
                        message: "Run script with name '\(name)' could not be found for target \(options.targetName).",
                        level: defaultViolationLevel,
                        path: options.projectPath
                    )
                )
                continue
            }

            guard let foundScript = runScript.shellScript else {
                violations.append(
                    FileViolation(
                        rule: self,
                        message: "Run script with name '\(name)' in target \(options.targetName) does not have a shell script.",
                        level: defaultViolationLevel,
                        path: options.projectPath
                    )
                )
                continue
            }

            if foundScript != expectedScript {
                if #available(OSX 10.12, *) {
                    printDiffSummary(fileName: name, found: foundScript, expected: expectedScript, printLevel: defaultViolationLevel.printLevel)
                }

                violations.append(
                    FileViolation(
                        rule: self,
                        message: "Run script with name '\(name)' in target \(options.targetName) did not match expected contents.",
                        level: defaultViolationLevel,
                        path: options.projectPath
                    )
                )
            }
        }

        return violations
    }
}
