import Foundation

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Foundation.Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}

public extension Date {
    var iso8601: String {
        Formatter.iso8601.string(from: self)
    }
}

public extension String {
    var dateFromISO8601: Date? {
        Formatter.iso8601.date(from: self)
    }
}
