import AppKit

struct MainWindowControllerFactory: MainWindowControllerCreating {
    var fileOpener: FileOpening = NSOpenPanel()

    func create() -> NSWindowController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = "MainWindowController"
        // swiftlint:disable:next force_cast
        let controller = storyboard.instantiateController(withIdentifier: identifier) as! MainWindowController
        controller.mainViewController.setUp(fileOpener: fileOpener)
        return controller
    }
}
