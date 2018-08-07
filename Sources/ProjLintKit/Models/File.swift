import Foundation

class File {
    let url: URL

    private var cachedContents: String?

    var contents: String {
        return cachedContents ?? loadContents()
    }

    init(at url: URL) {
        self.url = url
    }

    private func loadContents() -> String {
        guard let contents = try? String(contentsOf: url, encoding: .utf8) else {
            print("Could not load contents of file '\(url)'.", level: .error)
            exit(EXIT_FAILURE)
        }

        self.cachedContents = contents
        return contents
    }
}
