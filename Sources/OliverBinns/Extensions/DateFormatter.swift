import Foundation

extension DateFormatter {
    /// e.g. "24 May 2025". Uses a fixed locale so output is the same on
    /// every platform the site is built on.
    static let dayMonthYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "d MMM yyyy"
        return formatter
    }()
}
