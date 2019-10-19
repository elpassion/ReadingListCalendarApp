import Combine
import Foundation

extension UserDefaults: CalendarIdStoring {
    func calendarId() -> AnyPublisher<String?, Never> {
        CustomPublisher(request: { subscriber, _ in
            _ = subscriber.receive(self.string(forKey: "calendar_id"))
            subscriber.receive(completion: .finished)
        }).eraseToAnyPublisher()
    }

    func setCalendarId(_ id: String?) -> AnyPublisher<Void, Never> {
        CustomPublisher(request: { subscriber, _ in
            self.set(id, forKey: "calendar_id")
            _ = subscriber.receive()
            subscriber.receive(completion: .finished)
        }).eraseToAnyPublisher()
    }
}
