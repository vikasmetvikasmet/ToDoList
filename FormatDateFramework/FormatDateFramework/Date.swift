import Foundation

public func formatDateShort(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMMM YYYY"
    return formatter.string(from: date)
}
public func formatDateLong(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMMM YYYY"
    return formatter.string(from: date)
}
