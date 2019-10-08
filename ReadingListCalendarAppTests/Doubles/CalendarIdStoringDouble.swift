import RxSwift
import RxCocoa
@testable import ReadingListCalendarApp

class CalendarIdStoringDouble: CalendarIdStoring {
    var mockedCalendarId: String?

    func calendarId() -> Single<String?> {
        return .just(mockedCalendarId)
    }

    func setCalendarId(_ id: String?) -> Completable {
        return .create { observer in
            self.mockedCalendarId = id
            observer(.completed)
            return Disposables.create()
        }
    }
}
