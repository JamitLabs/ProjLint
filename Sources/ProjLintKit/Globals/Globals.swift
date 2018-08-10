import Foundation
import HandySwift

enum Globals {
    static var outputFormatTarget: OutputFormatTarget = .human
    static var timeout: TimeInterval = .seconds(10)
    static var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeout
        configuration.timeoutIntervalForResource = timeout
        return URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
    }
    static var ignoreTimeouts: Bool = false

    static let requestTimedOut = "#!-REQEUST_TIMED_OUT-!#"
}
