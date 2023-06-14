import Foundation

final class LogService {

    enum LogLevel: String {
        case info = "=== INFO ==="
        case warning = "=== WARNING ==="
        case error = "===ERROR ==="
    }

    static let shared = LogService()

    func log(_ message: String, level: LogLevel = .info) {
        let logMessage = "[\(level.rawValue)] \(message)"
        print(logMessage)
    }
}
