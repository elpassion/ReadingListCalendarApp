import AppKit

class MainWindowController: NSWindowController {
    var mainViewController: MainViewController! {
        contentViewController as? MainViewController
    }
}
