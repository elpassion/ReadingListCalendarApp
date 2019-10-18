import Combine
@testable import ReadingListCalendarApp

class CalendarIdStoringDouble: CalendarIdStoring {
    var mockedCalendarId: String?

    func calendarId() -> AnyPublisher<String?, Never> {
        SimplePublisher { subscriber in
            subscriber.receive(self.mockedCalendarId)
            subscriber.receive(completion: .finished)
            return .empty()
        }.eraseToAnyPublisher()
    }

    func setCalendarId(_ id: String?) -> AnyPublisher<Void, Never> {
        SimplePublisher { subscriber in
            self.mockedCalendarId = id
            subscriber.receive()
            subscriber.receive(completion: .finished)
            return .empty()
        }.eraseToAnyPublisher()
    }
}
