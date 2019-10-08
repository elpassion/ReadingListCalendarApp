import EventKit
@testable import ReadingListCalendarApp

class ReadingListItemEventProvidingDouble: ReadingListItemEventProviding {
    func event(for item: ReadingListItem, in calendar: EKCalendar) -> EKEvent? {
        return nil
    }
}
