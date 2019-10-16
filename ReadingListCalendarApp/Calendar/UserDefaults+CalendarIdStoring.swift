import Combine
import Foundation

extension UserDefaults: CalendarIdStoring {
    func calendarId() -> AnyPublisher<String?, Never> {
        Future { complete in
            let id = self.string(forKey: "calendar_id")
            complete(.success(id))
        }.eraseToAnyPublisher()
    }

    func setCalendarId(_ id: String?) -> AnyPublisher<Void, Never> {
        Future { complete in
            self.set(id, forKey: "calendar_id")
            complete(.success(()))
        }.eraseToAnyPublisher()
    }
}
