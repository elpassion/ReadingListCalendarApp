import EventKit
import Foundation
import RxCocoa
import RxSwift

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
    var syncScheduler: ImmediateSchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)

    // MARK: - SyncControlling

    var isSynchronizing: Driver<Bool> {
        return progressRelay.asDriver().map { $0 != nil }.distinctUntilChanged()
    }

    var syncProgress: Driver<Double?> {
        return progressRelay.asDriver()
    }

    func sync(bookmarksUrl: URL, calendarId: String) -> Completable {
        return Completable.create { observer in
            do {
                try self.performSync(bookmarksUrl: bookmarksUrl, calendarId: calendarId)
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            self.progressRelay.accept(nil)
            return Disposables.create()
        }.subscribeOn(syncScheduler)
    }

    // MARK: - Private

    private let progressRelay = BehaviorRelay<Double?>(value: nil)

    private func performSync(bookmarksUrl: URL, calendarId: String) throws {
        progressRelay.accept(0)
        let bookmarks = try bookmarksLoader.load(fromURL: bookmarksUrl)
        let calendar = try (calendarProvider.calendar(withIdentifier: calendarId)).or(SyncError.calendarNotFound)
        let items = try bookmarks.readingListItems()
        try items.enumerated().forEach {
            let (offset, item) = $0
            if eventProvider.event(for: item, in: calendar) == nil {
                let event = eventCreator.createEvent(for: item, in: calendar)
                try eventSaver.save(event, span: .thisEvent, commit: true)
            }
            progressRelay.accept(Double(offset + 1) / Double(items.count))
        }
    }

}
