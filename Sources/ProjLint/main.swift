import Foundation
import ProjLintKit
import SwiftCLI

// MARK: - CLI
let cli = CLI(name: "projlint", version: "0.1.0", description: "Project Linter to lint & autocorrect your non-code best practices.")
cli.commands = [CorrectCommand(), LintCommand()] // TODO: not yet implemented
cli.globalOptions.append(contentsOf: GlobalOptions.all)
cli.goAndExit()
