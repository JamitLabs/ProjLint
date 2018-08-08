// beak: kareman/SwiftShell @ .upToNextMajor(from: "4.0.1")
// beak: stencilproject/Stencil @ .upToNextMajor(from: "0.11.0")

import Foundation
import SwiftShell
import Stencil

/// Generates the LinuxMain.swift file by automatically searching the Tests path for tests.
public func generateLinuxMain() {
    run(bash: "sourcery --sources Tests --templates .sourcery/LinuxMain.stencil --output .sourcery --force-parse generated")
    run(bash: "mv .sourcery/LinuxMain.generated.swift Tests/LinuxMain.swift")
}

/// Generates the RuleFactory.swift file by automatically searching the Rules path for rules.
public func generateRuleFactory() {
    run(bash: "sourcery --sources Sources/ProjLintKit/Rules --templates .sourcery/RuleFactory.stencil --output .sourcery --force-parse generated")
    run(bash: "mv .sourcery/RuleFactory.generated.swift Sources/ProjLintKit/Globals/RuleFactory.swift")
}

/// Generates stubbed files for a new rule with options and tests for the rule and options and recreates the Xcode project.
public func generateRule(identifier: String) throws {
    let loader = FileSystemLoader(paths: [".templates/"])
    let env = Environment(loader: loader)

    let ruleTemplate = try env.loadTemplate(name: "Rule.stencil")
    let optionsTemplate = try env.loadTemplate(name: "Options.stencil")
    let ruleTestsTemplate = try env.loadTemplate(name: "RuleTests.stencil")
    let optionsTestsTemplate = try env.loadTemplate(name: "OptionsTests.stencil")

    let capitalizedComponents = identifier.components(separatedBy: "_").map { $0.capitalized }
    let name = capitalizedComponents.joined(separator: " ")
    let typePrefix = capitalizedComponents.joined()

    let dictionary = ["identifier": identifier, "name": name, "typePrefix": typePrefix]

    let ruleContents = try ruleTemplate.render(dictionary)
    let optionsContents = try optionsTemplate.render(dictionary)
    let ruleTestsContents = try ruleTestsTemplate.render(dictionary)
    let optionsTestsContents = try optionsTestsTemplate.render(dictionary)

    let pathContentsToWrite = [
        "Sources/ProjLintKit/Rules/\(typePrefix)Rule.swift": ruleContents,
        "Sources/ProjLintKit/Rules/\(typePrefix)Options.swift": optionsContents,
        "Tests/ProjLintKitTests/Rules/\(typePrefix)RuleTests.swift": ruleTestsContents,
        "Tests/ProjLintKitTests/Rules/\(typePrefix)OptionsTests.swift": optionsTestsContents
    ]

    if let existingFilePath = pathContentsToWrite.keys.first(where: { FileManager.default.fileExists(atPath: $0) }) {
        print("Failed: File at path '\(existingFilePath)' already exists.")
        return
    }

    for (path, contents) in pathContentsToWrite {
        guard FileManager.default.createFile(atPath: path, contents: contents.data(using: .utf8), attributes: nil) else {
            print("Failed: Could not create file at path '\(path)'.")
            return
        }
    }

    generateRuleFactory()

    run(bash: "swift package generate-xcodeproj")
}
