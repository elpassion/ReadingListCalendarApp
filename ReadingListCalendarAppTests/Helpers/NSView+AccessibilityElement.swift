import AppKit

extension NSView {
    func accessibilityElement<T>(id: String) -> T? {
        if accessibilityIdentifier() == id, let element = self as? T {
            return element
        }
        for view in subviews {
            if let element: T = view.accessibilityElement(id: id) {
                return element
            }
        }
        return nil
    }
}
