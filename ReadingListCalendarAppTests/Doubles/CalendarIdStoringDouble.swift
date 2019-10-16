import Combine
import RxSwift
import RxCocoa
@testable import ReadingListCalendarApp

class CalendarIdStoringDouble: CalendarIdStoring {
    var mockedCalendarId: String?

    func calendarId() -> Single<String?> {
        return .just(mockedCalendarId)
    }

    func calendarId() -> AnyPublisher<String?, Never> {
        Future { $0(.success(self.mockedCalendarId)) }.eraseToAnyPublisher()
    }

    func setCalendarId(_ id: String?) -> Completable {
        return .create { observer in
            self.mockedCalendarId = id
            observer(.completed)
            return Disposables.create()
        }
    }

    func setCalendarId(_ id: String?) -> AnyPublisher<Void, Never> {
        Future { complete in
            self.mockedCalendarId = id
            complete(.success(()))
        }.eraseToAnyPublisher()
    }
}
