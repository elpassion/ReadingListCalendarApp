import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    var mainWindowControllerFactory: MainWindowControllerCreating = MainWindowControllerFactory()

    // MARK: NSApplicationDelegate

    func applicationDidFinishLaunching(_ notification: Notification) {
        let controller = mainWindowControllerFactory.create()
        controller.showWindow(self)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}
