import AppKit

protocol AppTerminating {
    func terminate(_ sender: Any?)
}

extension NSApplication: AppTerminating {}
