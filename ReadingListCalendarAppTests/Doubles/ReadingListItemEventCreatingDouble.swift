import EventKit
@testable import ReadingListCalendarApp

class ReadingListItemEventCreatingDouble: ReadingListItemEventCreating {
    private(set) var didCreateEventsForItems = [ReadingListItem]()
    private(set) var didCreateEventsInCalendars = [EKCalendar]()
    private(set) var createdEvents = [EKEvent]()

    func createEvent(for item: ReadingListItem, in calendar: EKCalendar) -> EKEvent {
        didCreateEventsForItems.append(item)
        didCreateEventsInCalendars.append(calendar)
        let event = EKEvent(eventStore: EKEventStore())
        createdEvents.append(event)
        return event
    }
}
