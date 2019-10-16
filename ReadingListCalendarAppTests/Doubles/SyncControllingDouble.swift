import Foundation
import RxSwift
import RxCocoa
@testable import ReadingListCalendarApp

class SyncControllingDouble: SyncControlling {
    let isSynchronizingMock = BehaviorRelay<Bool>(value: false)
    let syncProgressMock = BehaviorRelay<Double?>(value: nil)
    private(set) var didSyncBookmarksUrl: URL?
    private(set) var didSyncCalendarId: String?
    private(set) var syncObserver: Completable.CompletableObserver?

    var isSynchronizing: Driver<Bool> { return isSynchronizingMock.asDriver() }
    var syncProgress: Driver<Double?> { return syncProgressMock.asDriver() }

    func sync(bookmarksUrl: URL, calendarId: String) -> Completable {
        return .create { observer in
            self.didSyncBookmarksUrl = bookmarksUrl
            self.didSyncCalendarId = calendarId
            self.syncObserver = observer
            return Disposables.create()
        }
    }
}
