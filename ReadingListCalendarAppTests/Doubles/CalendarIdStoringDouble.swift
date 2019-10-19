import Combine
@testable import ReadingListCalendarApp

class CalendarIdStoringDouble: CalendarIdStoring {
    var mockedCalendarId: String?

    func calendarId() -> AnyPublisher<String?, Never> {
        CustomPublisher(request: { subscriber, _ in
            _ = subscriber.receive(self.mockedCalendarId)
            subscriber.receive(completion: .finished)
        }).eraseToAnyPublisher()
    }

    func setCalendarId(_ id: String?) -> AnyPublisher<Void, Never> {
        CustomPublisher(request: { subscriber, _ in
            self.mockedCalendarId = id
            _ = subscriber.receive()
            subscriber.receive(completion: .finished)
        }).eraseToAnyPublisher()
    }
}
