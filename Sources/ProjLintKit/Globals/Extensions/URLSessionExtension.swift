import Foundation

extension URLSession {
    typealias Result = (Data?, URLResponse?, Error?)

    func syncDataTask(with url: URL) -> Result {
        var data: Data?
        var response: URLResponse?
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)

        let dataTask = self.dataTask(with: url) {
            data = $0
            response = $1
            error = $2

            semaphore.signal()
        }

        dataTask.resume()
        _ = semaphore.wait(timeout: .distantFuture)

        return (data, response, error)
    }
}
