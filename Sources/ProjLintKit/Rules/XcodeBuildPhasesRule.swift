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

        let projectUrl = URL(fileURLWithPath: options.projectPath, relativeTo: directory)
        guard let xcodeProj = try? XcodeProj(pathString: projectUrl.path) else {
            print("Could not read project file at path '\(projectUrl.path)'.", level: .error)
            exit(EXIT_FAILURE)
        }

        guard let target = xcodeProj.pbxproj.targets(named: options.targetName).first else {
            print("Target with name '\(options.targetName)' could not be found in project \(projectUrl.path).", level: .error)
            exit(EXIT_FAILURE)
        }

        let targetRunScripts = target.buildPhases.filter { $0.type() == BuildPhase.runScript } as! [PBXShellScriptBuildPhase]

        for (name, expectedScript) in options.runScripts {
            guard let runScript = targetRunScripts.first(where: { $0.name == name }) else {
                violations.append(
                    FileViolation(
                        rule: self,
                        message: "Run script with name '\(name)' could not be found for target \(options.targetName).",
                        level: defaultViolationLevel,
                        url: projectUrl
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
                        url: projectUrl
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
                        url: projectUrl
                    )
                )
            }
        }

        return violations
    }
}
