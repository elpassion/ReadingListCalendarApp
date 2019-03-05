import Foundation
import RxCocoa
import RxSwift

class SyncController: SyncControlling {

    var isSynchronizing: Driver<Bool> {
        return progressRelay.asDriver().map { $0 != nil }.distinctUntilChanged()
    }

    var syncProgress: Driver<Double?> {
        return progressRelay.asDriver()
    }

    func sync(bookmarksUrl: URL, calendarId: String) -> Completable {
        return Completable.create { [progressRelay] observer in
            progressRelay.accept(0)
            progressRelay.accept(1)
            observer(.completed)
            progressRelay.accept(nil)
            return Disposables.create()
        }
    }

    private let progressRelay = BehaviorRelay<Double?>(value: nil)

}
