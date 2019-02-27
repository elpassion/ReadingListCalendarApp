import AppKit

struct MainWindowControllerFactory: MainWindowControllerCreating {
    func create() -> NSWindowController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = "MainWindowController"
        // swiftlint:disable:next force_cast
        return storyboard.instantiateController(withIdentifier: identifier) as! MainWindowController
    }
}
