import RxSwift

protocol CalendarIdStoring {
    func calendarId() -> Single<String?>
    func setCalendarId(_ id: String?) -> Completable
}
