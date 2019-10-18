import Combine
import Foundation

extension UserDefaults: CalendarIdStoring {
    func calendarId() -> AnyPublisher<String?, Never> {
        SimplePublisher { subscriber in
            subscriber.receive(self.string(forKey: "calendar_id"))
            subscriber.receive(completion: .finished)
            return .empty()
        }.eraseToAnyPublisher()
    }

    func setCalendarId(_ id: String?) -> AnyPublisher<Void, Never> {
        SimplePublisher { subscriber in
            self.set(id, forKey: "calendar_id")
            subscriber.receive()
            subscriber.receive(completion: .finished)
            return .empty()
        }.eraseToAnyPublisher()
    }
}
