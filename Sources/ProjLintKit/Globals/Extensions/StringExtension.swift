import Foundation
import HandySwift

extension String {
    func char(at offset: Int) -> Character? {
        let requestedIndex = index(startIndex, offsetBy: offset)
        guard requestedIndex < endIndex else { return nil }
        return self[requestedIndex]
    }

    func lineIndex(for characterIndex: Index) -> Int {
        return self[...characterIndex].components(separatedBy: .newlines).count
    }
}
