import EventKit
import RxSwift

extension CalendarAuthorizing {

    func eventsAuthorizationStatus() -> Single<EKAuthorizationStatus> {
        return .create { observer in
            let status = type(of: self).authorizationStatus(for: .event)
            observer(.success(status))
            return Disposables.create()
        }
    }

    func requestAccessToEvents() -> Completable {
        return .create { observer in
            self.requestAccess(to: .event) { _, error in
                if let error = error {
                    observer(.error(error))
                } else {
                    observer(.completed)
                }
            }
            return Disposables.create()
        }
    }

}
