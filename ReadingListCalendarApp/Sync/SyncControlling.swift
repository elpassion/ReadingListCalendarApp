import Foundation
import RxCocoa
import RxSwift

protocol SyncControlling {
    func isSynchronizing() -> Driver<Bool>
    func syncProgress() -> Driver<Double?>
    func sync(bookmarksUrl: URL, calendarId: String) -> Completable
}
