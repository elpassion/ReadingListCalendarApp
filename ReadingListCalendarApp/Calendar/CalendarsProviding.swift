import EventKit

protocol CalendarsProviding {
    func calendars(for entityType: EKEntityType) -> [EKCalendar]
}
