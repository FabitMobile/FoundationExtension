import Foundation

public extension Date {
    func string(with format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format

        return formatter.string(from: self)
    }
}

public extension Date {
    func convertToTimeZone(_ timeZone: TimeZone) -> Date {
         let localDeviceTimeZone = TimeZone.current
         let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - localDeviceTimeZone.secondsFromGMT(for: self))
         return addingTimeInterval(delta)
    }
}

public extension Date {
    var calendar: Calendar {
        Calendar.current
    }

    func dateComponents(_ components: Set<Calendar.Component>) -> DateComponents {
        calendar.dateComponents(components, from: self)
    }

    func dateComponents(_ components: Set<Calendar.Component>,
                        from: Date) -> DateComponents {
        calendar.dateComponents(components, from: from, to: self)
    }

    // -
    func adding(components: DateComponents) -> Date {
        calendar.date(byAdding: components, to: self)! // swiftlint:disable:this force_unwrapping
    }

    // -
    var isTomorrow: Bool {
        calendar.isDateInTomorrow(self)
    }

    // -
    var tomorrow: Date {
        adding(components: .init(day: 1))
    }

    var yesterday: Date {
        adding(components: .init(day: -1))
    }

    func isAtTheSameDayAs(_ date: Date) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: .day)
    }

    // -
    var startOfDay: Date {
        calendar.startOfDay(for: self)
    }

    var endOfDay: Date {
        startOfDay
            .tomorrow
            .adding(components: .init(second: -1))
    }

    // -
    var startOfMonth: Date {
        let comp = calendar.dateComponents([.year, .month], from: startOfDay)
        return calendar.date(from: comp)! // swiftlint:disable:this force_unwrapping
    }

    var endOfMonth: Date {
        startOfMonth
            .adding(components: .init(month: 1, second: -1))
    }

    // -
    /// 0 = Sunday, 6 = Saturday
    var dayOfWeek: Int {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        let result = calendar.ordinality(of: .weekday, in: .weekOfYear, for: self) ?? 1 // 1..7
        return result - 1
    }
}
