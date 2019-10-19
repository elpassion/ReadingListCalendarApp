import Combine
import EventKit

extension CalendarAuthorizing {
    func eventsAuthorizationStatus() -> AnyPublisher<EKAuthorizationStatus, Never> {
        CustomPublisher(request: { subscriber, _ in
            _ = subscriber.receive(type(of: self).authorizationStatus(for: .event))
            subscriber.receive(completion: .finished)
        }).eraseToAnyPublisher()
    }

    func requestAccessToEvents() -> AnyPublisher<Void, Error> {
        CustomPublisher(request: { subscriber, _ in
            self.requestAccess(to: .event) { _, error in
                if let error = error {
                    subscriber.receive(completion: .failure(error))
                } else {
                    _ = subscriber.receive()
                    subscriber.receive(completion: .finished)
                }
            }
        }).eraseToAnyPublisher()
    }
}
