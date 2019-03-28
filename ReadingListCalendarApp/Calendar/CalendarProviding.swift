import EventKit

protocol CalendarProviding {
    func calendar(withIdentifier: String) -> EKCalendar?
}
