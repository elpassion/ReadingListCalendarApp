import EventKit

protocol ReadingListItemEventProviding {
    func event(for item: ReadingListItem, in calendar: EKCalendar) -> EKEvent?
}
