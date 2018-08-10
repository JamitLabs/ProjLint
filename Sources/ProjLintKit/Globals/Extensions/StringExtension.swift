import Foundation
import HandySwift

extension String {
    func char(at offset: Int) -> Character? {
        let requestedIndex = index(startIndex, offsetBy: offset)
        guard requestedIndex < endIndex else { return nil }
        return self[requestedIndex]
    }

    func line(forIndex index: Int) -> Int {
        var processedCharIndex = 0
        let lines = components(separatedBy: .newlines)

        for (lineIndex, line) in lines.enumerated() {
            processedCharIndex += line.count + 1

            if processedCharIndex > index {
                return lineIndex + 1
            }
        }

        fatalError("Could not find line for character index.")
    }
}
