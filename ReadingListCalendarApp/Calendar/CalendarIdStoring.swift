import Combine

protocol CalendarIdStoring {
    func calendarId() -> AnyPublisher<String?, Never>
    func setCalendarId(_ id: String?) -> AnyPublisher<Void, Never>
}
