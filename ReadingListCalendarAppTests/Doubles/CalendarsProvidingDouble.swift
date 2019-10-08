import EventKit
@testable import ReadingListCalendarApp

class CalendarsProvidingDouble: CalendarsProviding {
    var mockedCalendars = [EKCalendarDouble]()

    func calendars(for entityType: EKEntityType) -> [EKCalendar] { return mockedCalendars }
}
