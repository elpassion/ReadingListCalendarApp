import Combine
import EventKit

extension CalendarAuthorizing {

    func eventsAuthorizationStatus() -> AnyPublisher<EKAuthorizationStatus, Never> {
        // TODO:
//        return .create { observer in
//            let status = type(of: self).authorizationStatus(for: .event)
//            observer(.success(status))
//            return Disposables.create()
//        }
        Future { _ in }.eraseToAnyPublisher()
    }

    func requestAccessToEvents() -> AnyPublisher<Void, Error> {
        // TODO:
//        return .create { observer in
//            self.requestAccess(to: .event) { _, error in
//                if let error = error {
//                    observer(.error(error))
//                } else {
//                    observer(.completed)
//                }
//            }
//            return Disposables.create()
//        }
        Future { _ in }.eraseToAnyPublisher()
    }

}
