import Combine
import EventKit

extension CalendarsProviding {
    func eventCalendars() -> AnyPublisher<[EKCalendar], Never> {
        CustomPublisher(request: { subscriber, _ in
            _ = subscriber.receive(self.calendars(for: .event))
            subscriber.receive(completion: .finished)
        }).eraseToAnyPublisher()
    }
}
