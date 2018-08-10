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
        let contents: String = {
            if url.isFileURL {
                guard let contents = try? String(contentsOf: url, encoding: .utf8) else {
                    print("Could not load contents of file '\(url)'.", level: .error)
                    exit(EXIT_FAILURE)
                }
                return contents
            } else {
                let (dataOptional, _, errorOptional) = Globals.session.syncDataTask(with: url)

                if let error = errorOptional as? URLError, error.code == .timedOut {
                    return Globals.requestTimedOut
                }

                guard let data = dataOptional, let contents = String(data: data, encoding: .utf8) else {
                    print("Could not load contents of file '\(url)'. Error: \(String(describing: errorOptional))", level: .error)
                    exit(EXIT_FAILURE)
                }

                return contents
            }
        }()

        self.cachedContents = contents
        return contents
    }
}
