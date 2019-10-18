import Combine
import EventKit

extension CalendarAuthorizing {
    func eventsAuthorizationStatus() -> AnyPublisher<EKAuthorizationStatus, Never> {
        SimplePublisher { subscriber in
            subscriber.receive(type(of: self).authorizationStatus(for: .event))
            subscriber.receive(completion: .finished)
            return .empty()
        }.eraseToAnyPublisher()
    }

    func requestAccessToEvents() -> AnyPublisher<Void, Error> {
        SimplePublisher { subscriber in
            self.requestAccess(to: .event) { _, error in
                if let error = error {
                    subscriber.receive(completion: .failure(error))
                } else {
                    subscriber.receive()
                    subscriber.receive(completion: .finished)
                }
            }
            return .empty()
        }.eraseToAnyPublisher()
    }
}
