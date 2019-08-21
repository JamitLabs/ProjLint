import Foundation

/// A violation that additionally has a path & optional line property which is logged alongside the message.
class FileViolation: Violation {
    let url: URL
    let line: Int?

    init(rule: Rule, message: String, level: ViolationLevel, url: URL, line: Int? = nil) {
        self.url = url
        self.line = line

        super.init(rule: rule, message: message, level: level)
    }

    override func logViolation() {
        // In order for Xcode to show the error properly, the path to the file should be absolute
        let file = url.path
        print("\(type(of: rule).name) Violation – \(message)", level: level.printLevel, file: file, line: line)
    }
}
