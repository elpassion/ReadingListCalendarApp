import Combine
import EventKit
import Foundation

class SyncController: SyncControlling {

    init() {
        bookmarksLoader = BookmarksLoader()
        let eventStore = EKEventStore()
        calendarProvider = eventStore
        eventProvider = eventStore
        eventCreator = eventStore
        eventSaver = eventStore
    }

    var bookmarksLoader: BookmarksLoading
    var calendarProvider: CalendarProviding
    var eventProvider: ReadingListItemEventProviding
    var eventCreator: ReadingListItemEventCreating
    var eventSaver: EventSaving

    // MARK: - SyncControlling

    func isSynchronizing() -> AnyPublisher<Bool, Never> {
        progress.map { $0 != nil }.removeDuplicates().eraseToAnyPublisher()
    }

    func syncProgress() -> AnyPublisher<Double?, Never> {
        progress.eraseToAnyPublisher()
    }

    func sync(bookmarksUrl: URL, calendarId: String) -> AnyPublisher<Void, Error> {
        Future { complete in
            DispatchQueue.global(qos: .background).async {
                do {
                    try self.performSync(bookmarksUrl: bookmarksUrl, calendarId: calendarId)
                    complete(.success(()))
                } catch {
                    complete(.failure(error))
                }
                self.progress.send(nil)
            }
        }.eraseToAnyPublisher()
    }

    // MARK: - Private

    private let progress = CurrentValueSubject<Double?, Never>(nil)

    private func performSync(bookmarksUrl: URL, calendarId: String) throws {
        progress.send(0)
        let bookmarks = try bookmarksLoader.load(fromURL: bookmarksUrl)
        let calendar = try (calendarProvider.calendar(withIdentifier: calendarId)).or(SyncError.calendarNotFound)
        let items = try bookmarks.readingListItems()
        try items.enumerated().forEach {
            let (offset, item) = $0
            if eventProvider.event(for: item, in: calendar) == nil {
                let event = eventCreator.createEvent(for: item, in: calendar)
                try eventSaver.save(event, span: .thisEvent, commit: true)
            }
            progress.send(Double(offset + 1) / Double(items.count))
        }
    }

}
