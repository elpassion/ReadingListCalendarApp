import Combine
import EventKit

extension CalendarsProviding {
    func eventCalendars() -> AnyPublisher<[EKCalendar], Never> {
        SimplePublisher { subscriber in
            subscriber.receive(self.calendars(for: .event))
            subscriber.receive(completion: .finished)
            return .empty()
        }.eraseToAnyPublisher()
    }
}
