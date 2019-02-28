import AppKit

struct MainWindowControllerFactory: MainWindowControllerCreating {
    var fileOpener: FileOpening = NSOpenPanel()
    var fileBookmarks: FileBookmarking = UserDefaults.standard

    func create() -> NSWindowController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = "MainWindowController"
        // swiftlint:disable:next force_cast
        let controller = storyboard.instantiateController(withIdentifier: identifier) as! MainWindowController
        controller.mainViewController.setUp(
            fileOpener: fileOpener,
            fileBookmarks: fileBookmarks
        )
        return controller
    }
}
