import Combine
import EventKit

extension CalendarsProviding {
    func eventCalendars() -> AnyPublisher<[EKCalendar], Never> {
        Future { complete in
            let calendars = self.calendars(for: .event)
            complete(.success(calendars))
        }.eraseToAnyPublisher()
    }
}
