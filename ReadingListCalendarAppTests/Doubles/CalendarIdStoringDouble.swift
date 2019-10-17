import Combine
@testable import ReadingListCalendarApp

class CalendarIdStoringDouble: CalendarIdStoring {
    var mockedCalendarId: String?

    func calendarId() -> AnyPublisher<String?, Never> {
        Future { $0(.success(self.mockedCalendarId)) }.eraseToAnyPublisher()
    }

    func setCalendarId(_ id: String?) -> AnyPublisher<Void, Never> {
        Future { complete in
            self.mockedCalendarId = id
            complete(.success(()))
        }.eraseToAnyPublisher()
    }
}
