import AppKit
import Combine

extension NSProgressIndicator {
    func update(fractionCompleted: Double?) {
        doubleValue = fractionCompleted.map {
            self.minValue + (self.maxValue - self.minValue) * $0
        } ?? 0
    }
}
