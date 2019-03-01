import RxCocoa
import RxSwift

func asDriverOnErrorComplete() -> (Completable) -> Driver<Never> {
    return { completable in completable.asDriver(onErrorDriveWith: .empty()) }
}
