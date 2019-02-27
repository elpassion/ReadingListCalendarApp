import AppKit

class MainWindowController: NSWindowController {
    var mainViewController: MainViewController {
        // swiftlint:disable:next force_cast
        return contentViewController as! MainViewController
    }
}
