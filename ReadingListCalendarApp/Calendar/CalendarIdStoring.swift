import Combine
import RxSwift

protocol CalendarIdStoring {
    @available (*, deprecated, message: "Migreted to Combine")
    func calendarId() -> Single<String?>
    @available (*, deprecated, message: "Migreted to Combine")
    func setCalendarId(_ id: String?) -> Completable

    func calendarId() -> AnyPublisher<String?, Never>
    func setCalendarId(_ id: String?) -> AnyPublisher<Void, Never>
}
