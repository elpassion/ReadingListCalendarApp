import EventKit

extension EKEventStore: ReadingListItemEventCreating {
    func createEvent(for item: ReadingListItem, in calendar: EKCalendar) -> EKEvent {
        let event = EKEvent(eventStore: self)
        event.startDate = item.dateAdded
        event.endDate = item.dateAdded
        event.calendar = calendar
        event.url = URL(string: item.url)
        event.title = item.title
        event.notes = item.previewText
        return event
    }
}
