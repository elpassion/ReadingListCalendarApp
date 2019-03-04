import AppKit

protocol ModalAlert {
    @discardableResult
    func runModal() -> NSApplication.ModalResponse
}
