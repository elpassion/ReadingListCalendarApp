import RxCocoa
import RxSwift

func asDriver<E>(onErrorDriveWith: Driver<E>) -> (Maybe<E>) -> Driver<E> {
    return { maybe in maybe.asDriver(onErrorDriveWith: onErrorDriveWith) }
}
