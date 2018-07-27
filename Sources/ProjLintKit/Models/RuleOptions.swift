import Foundation
import HandySwift

struct RuleOptions {
    /// An array of Regexes to whitelist the directories & files to check.
    let includedPaths: [Regex]

    /// An array of Regexes to blacklist the directories & files to check.
    let excludedPaths: [Regex]

    /// Specifies when the lint command should fail.
    let lintFailLevel: ViolationLevel?
}
