import Foundation
import HandySwift

indirect enum FakerType {
    case bool
    case text
    case variable
    case regexString
    case filePath
    case dirPath
    case fileURL
    case array(elementType: FakerType, count: Int)
    case dict(keyType: FakerType, valueType: FakerType, count: Int)
}

struct Faker {
    static let first = Faker(seed: 1)
    static let second = Faker(seed: 2)
    static let third = Faker(seed: 3)

    private let seed: String

    // MARK: - Fake Data Generators
    private var bool: Bool {
        return Int(seed)! % 2 == 0
    }

    private var text: String {
        return "example text \(seed)"
    }

    private var variable: String {
        return "exampleVar\(seed)"
    }

    private var regexString: String {
        return ".*\(seed)\\.swift"
    }

    private var filePath: String {
        return "path/to/some/file\(seed).swift"
    }

    private var fileURL: String {
        return "https://github.com/User/Project/blob/stable/File\(seed).swift"
    }

    private var dirPath: String {
        return "path/to/some/directory\(seed)/"
    }

    // MARK: - Initializers
    private init(seed: Int, superseed: String? = nil) {
        if let superseed = superseed {
            self.seed = "\(superseed).\(seed)"
        } else {
            self.seed = String(seed)
        }
    }

    // MARK: - Instance Methods
    func data(ofType type: FakerType) -> Any {
        switch type {
        case .bool:
            return bool

        case .text:
            return text

        case .variable:
            return variable

        case .regexString:
            return regexString

        case .filePath:
            return filePath

        case .dirPath:
            return dirPath

        case .fileURL:
            return fileURL

        case let .array(elementType, count):
            return array(elementType: elementType, count: count)

        case let .dict(keyType, valueType, count):
            return dict(keyType: keyType, valueType: valueType, count: count)
        }
    }

    private func array(elementType: FakerType, count: Int) -> [Any] {
        return (0 ..< count).map { Faker(seed: $0, superseed: seed).data(ofType: elementType) }
    }

    private func dict(keyType: FakerType, valueType: FakerType, count: Int) -> [String: Any] {
        let keys = (0 ..< count).map { Faker(seed: $0, superseed: seed).data(ofType: keyType) as! String }
        let values = (0 ..< count).map { Faker(seed: $0, superseed: seed).data(ofType: valueType) }
        return Dictionary(keys: keys, values: values)!
    }
}
