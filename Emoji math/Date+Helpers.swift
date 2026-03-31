// Date+Helpers.swift / Emoji Math

import Foundation

extension Date {
    var yesterday: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }

    var tomorrow: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }

    var noon: Date {
        Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }

    /// Full weekday name in the current locale (e.g. "Monday").
    var dayOfWeekName: String {
        Self.dayOfWeekFormatter.string(from: self)
    }

    /// Calendar date as `dd.MM.yyyy`.
    var formattedDate: String {
        Self.shortDateFormatter.string(from: self)
    }

    private static let dayOfWeekFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()

    private static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
}
