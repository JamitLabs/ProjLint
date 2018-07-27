import Foundation

/// A violation that additionally has a path & optional line property which is logged alongside the message.
class FileViolation: Violation {
    let path: String
    let line: Int?

    init(rule: Rule, message: String, level: ViolationLevel, path: String, line: Int? = nil) {
        self.path = path
        self.line = line

        super.init(rule: rule, message: message, level: level)
    }

    override func logViolation() {
        let location = line != nil ? "\(path):\(line!)" : path
        print("\(type(of: rule).name) Violation at path '\(location)' –– \(message)", level: level.printLevel)
    }
}
