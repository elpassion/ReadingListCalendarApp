import EventKit
import RxSwift

extension CalendarsProviding {
    func eventCalendars() -> Single<[EKCalendar]> {
        return .create { observer in
            let calendars = self.calendars(for: .event)
            observer(.success(calendars))
            return Disposables.create()
        }
    }
}
