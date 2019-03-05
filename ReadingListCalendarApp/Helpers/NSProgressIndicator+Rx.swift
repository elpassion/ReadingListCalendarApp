import AppKit
import RxCocoa
import RxSwift

extension NSProgressIndicator {}

extension Reactive where Base: NSProgressIndicator {
    var fractionCompleted: Binder<Double?> {
        return Binder(base) { base, fractionCompleted in
            base.doubleValue = fractionCompleted.map { base.minValue + (base.maxValue - base.minValue) * $0 } ?? 0
        }
    }
}
