import Combine
import Foundation
import RxSwift

extension UserDefaults: CalendarIdStoring {
    func calendarId() -> Single<String?> {
        return .create { observer in
            let id = self.string(forKey: "calendar_id")
            observer(.success(id))
            return Disposables.create()
        }
    }

    func calendarId() -> AnyPublisher<String?, Never> {
        Future { complete in
            let id = self.string(forKey: "calendar_id")
            complete(.success(id))
        }.eraseToAnyPublisher()
    }

    func setCalendarId(_ id: String?) -> Completable {
        return .create { observer in
            self.set(id, forKey: "calendar_id")
            observer(.completed)
            return Disposables.create()
        }
    }

    func setCalendarId(_ id: String?) -> AnyPublisher<Void, Never> {
        Future { complete in
            self.set(id, forKey: "calendar_id")
            complete(.success(()))
        }.eraseToAnyPublisher()
    }
}
