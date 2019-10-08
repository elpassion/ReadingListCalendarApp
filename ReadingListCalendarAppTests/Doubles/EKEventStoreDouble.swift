import EventKit

class EKEventStoreDouble: EKEventStore {
    private(set) var didCreatePredicateForEventsWithStartDate: Date?
    private(set) var didCreatePredicateForEventsWithEndDate: Date?
    private(set) var didCreatePredicateForEventsWithCalendars: [EKCalendar]?
    var createdPredicate = NSPredicate(value: true)

    override func predicateForEvents(
        withStart startDate: Date,
        end endDate: Date,
        calendars: [EKCalendar]?
    ) -> NSPredicate {
        didCreatePredicateForEventsWithStartDate = startDate
        didCreatePredicateForEventsWithEndDate = endDate
        didCreatePredicateForEventsWithCalendars = calendars
        return createdPredicate
    }

    private(set) var didFetchEventsMatchingPredicate: NSPredicate?
    var mockedEvents = [EKEvent]()

    override func events(matching predicate: NSPredicate) -> [EKEvent] {
        didFetchEventsMatchingPredicate = predicate
        return mockedEvents
    }
}
