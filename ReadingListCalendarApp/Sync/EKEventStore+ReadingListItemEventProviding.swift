import EventKit

extension EKEventStore: ReadingListItemEventProviding {
    func event(for item: ReadingListItem, in calendar: EKCalendar) -> EKEvent? {
        let predicate = predicateForEvents(
            withStart: Date(timeIntervalSince1970: item.dateAdded.timeIntervalSince1970 - 1),
            end: Date(timeIntervalSince1970: item.dateAdded.timeIntervalSince1970 + 1),
            calendars: [calendar]
        )
        return events(matching: predicate).first { $0.url?.absoluteString == item.url }
    }
}
