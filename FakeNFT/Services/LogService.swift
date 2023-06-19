import Foundation

final class LogService {

    enum LogLevel: String {
        case info = "=== INFO ==="
        case warning = "=== WARNING ==="
        case error = "=== ERROR ==="
    }

    static let shared = LogService()

    private init() {}

    func log(_ message: String, level: LogLevel = .info) {
        _ = "[\(level.rawValue)] \(message)"
        // print(logMessage)
    }
}
