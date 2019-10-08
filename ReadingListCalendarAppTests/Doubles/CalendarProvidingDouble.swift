import EventKit
@testable import ReadingListCalendarApp

class CalendarProvidingDouble: CalendarProviding {
    var mockedCalendar: EKCalendar? = EKCalendar(for: .event, eventStore: EKEventStore())
    private(set) var didLoadCalendarWithIdentifier: String?

    func calendar(withIdentifier: String) -> EKCalendar? {
        didLoadCalendarWithIdentifier = withIdentifier
        return mockedCalendar
    }
}
