import Foundation

class File {
    let path: String

    private var cachedContents: String?

    var contents: String {
        return cachedContents ?? loadContents()
    }

    init(at path: String) {
        self.path = path
    }

    private func loadContents() -> String {
        print("path loading contents from: \(path)")
        guard let contents = try? String(contentsOfFile: path, encoding: .utf8) else {
            print("Could not load contents of file '\(path)'.", level: .error)
            exit(EXIT_FAILURE)
        }

        self.cachedContents = contents
        return contents
    }
}
