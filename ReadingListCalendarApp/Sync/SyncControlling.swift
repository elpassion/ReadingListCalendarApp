import Foundation
import RxCocoa
import RxSwift

protocol SyncControlling {
    var isSynchronizing: Driver<Bool> { get }
    var syncProgress: Driver<Double?> { get }

    func sync(bookmarksUrl: URL, calendarId: String) -> Completable
}
