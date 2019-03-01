import RxCocoa

extension Driver {
    func unwrap<T>() -> Driver<T> where E == T? {
        // swiftlint:disable:next force_unwrapping
        return filter { $0 != nil }.map { $0! }.asDriver(onErrorDriveWith: .empty())
    }
}
