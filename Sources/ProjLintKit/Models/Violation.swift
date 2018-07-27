import Foundation

/// A violation of a rule with a message and violation level to be logged in a report.
class Violation {
    let rule: Rule
    let message: String
    let level: ViolationLevel

    init(rule: Rule, message: String, level: ViolationLevel) {
        self.rule = rule
        self.message = message
        self.level = level
    }

    func logViolation() {
        print("\(rule.name) Violation – \(message)", level: level.printLevel)
    }
}
