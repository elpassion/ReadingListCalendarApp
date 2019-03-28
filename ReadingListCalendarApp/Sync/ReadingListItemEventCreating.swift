import EventKit

protocol ReadingListItemEventCreating {
    func createEvent(for item: ReadingListItem, in calendar: EKCalendar) -> EKEvent
}
