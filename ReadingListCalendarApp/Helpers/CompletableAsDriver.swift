import RxCocoa
import RxSwift

func asDriverOnErrorComplete(onError: ((Error) throws -> Void)? = nil) -> (Completable) -> Driver<Never> {
    return { completable in completable
        .observeOn(MainScheduler.instance)
        .do(onError: onError)
        .asDriver(onErrorDriveWith: .empty())
    }
}
