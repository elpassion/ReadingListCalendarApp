import AppKit

class NSWindowControllerDouble: NSWindowController {
    private(set) var didShowWindow = false
    private(set) var didShowWindowSender: Any?

    override func showWindow(_ sender: Any?) {
        didShowWindow = true
        didShowWindowSender = sender
    }
}
