import Foundation

extension DateFormatter {
    static var monthDayYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }
}
