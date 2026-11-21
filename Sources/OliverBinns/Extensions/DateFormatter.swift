import Foundation

extension DateFormatter {
    static var monthDayYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }

    /// e.g. "24 May 2025". Uses a fixed locale so output is the same on
    /// every platform the site is built on.
    static let dayMonthYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "d MMM yyyy"
        return formatter
    }()
}
