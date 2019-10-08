import EventKit
@testable import ReadingListCalendarApp

class EventSavingDouble: EventSaving {
    private(set) var savedEvents = [(event: EKEvent, span: EKSpan, commit: Bool)]()

    func save(_ event: EKEvent, span: EKSpan, commit: Bool) throws {
        savedEvents.append((event, span, commit))
    }
}
