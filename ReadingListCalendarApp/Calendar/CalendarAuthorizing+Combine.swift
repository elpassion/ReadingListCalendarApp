import Combine
import EventKit

extension CalendarAuthorizing {
    func eventsAuthorizationStatus() -> AnyPublisher<EKAuthorizationStatus, Never> {
        Future { complete in
            let status = type(of: self).authorizationStatus(for: .event)
            complete(.success(status))
        }.eraseToAnyPublisher()
    }

    func requestAccessToEvents() -> AnyPublisher<Void, Error> {
        Future { complete in
            self.requestAccess(to: .event) { _, error in
                if let error = error {
                    complete(.failure(error))
                } else {
                    complete(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
}
