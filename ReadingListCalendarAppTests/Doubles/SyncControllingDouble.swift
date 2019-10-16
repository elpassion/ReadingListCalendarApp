import Combine
import Foundation
@testable import ReadingListCalendarApp

class SyncControllingDouble: SyncControlling {
    let isSynchronizingMock = CurrentValueSubject<Bool, Never>(false)
    let syncProgressMock = CurrentValueSubject<Double?, Never>(nil)
    private(set) var didSyncBookmarksUrl: URL?
    private(set) var didSyncCalendarId: String?
    private(set) var syncSubject: PassthroughSubject<Void, Error>?

    func isSynchronizing() -> AnyPublisher<Bool, Never> {
        isSynchronizingMock.eraseToAnyPublisher()
    }

    func syncProgress() -> AnyPublisher<Double?, Never> {
        syncProgressMock.eraseToAnyPublisher()
    }

    func sync(bookmarksUrl: URL, calendarId: String) -> AnyPublisher<Void, Error> {
        didSyncBookmarksUrl = bookmarksUrl
        didSyncCalendarId = calendarId
        syncSubject = PassthroughSubject()
        return syncSubject!.eraseToAnyPublisher()
    }
}
