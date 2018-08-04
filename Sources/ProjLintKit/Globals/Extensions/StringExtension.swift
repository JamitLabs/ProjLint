import Foundation
import HandySwift

extension String {
    func char(at offset: Int) -> Character {
        return self[index(startIndex, offsetBy: offset)]
    }

    func line(forIndex index: Int) -> Int {
        print("finding line for char '\(char(at: index))' at index \(index) ...", level: .info)
        var processedCharIndex = 0
        let lines = components(separatedBy: .newlines)

        for (lineIndex, line) in lines.enumerated() {
            processedCharIndex += line.count + 1

            if processedCharIndex > index {
                print("found line \(lineIndex + 1) ...", level: .info)
                return lineIndex + 1
            }
        }

        fatalError("Could not find line for character index.")
    }
}
