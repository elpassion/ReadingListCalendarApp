import Cocoa
import EventKit

class AppDelegate: NSObject, NSApplicationDelegate {

    var mainWindowControllerFactory: MainWindowControllerCreating = MainWindowControllerFactory()
    var fileOpenerFactory: FileOpenerCreating = FileOpenerFactory()
    var fileBookmarks: FileBookmarking = UserDefaults.standard
    var fileReadability: FileReadablity = FileManager.default
    var calendarAuthorizer: CalendarAuthorizing = EKEventStore()
    var alertFactory: ModalAlertCreating = ModalAlertFactory()
    var calendarsProvider: CalendarsProviding = EKEventStore()
    var calendarIdStore: CalendarIdStoring = UserDefaults.standard
    var syncController: SyncControlling = SyncController()

    // MARK: NSApplicationDelegate

    func applicationDidFinishLaunching(_ notification: Notification) {
        let controller = mainWindowControllerFactory.create(
            fileOpenerFactory: fileOpenerFactory,
            fileBookmarks: fileBookmarks,
            fileReadability: fileReadability,
            calendarAuthorizer: calendarAuthorizer,
            alertFactory: alertFactory,
            calendarsProvider: calendarsProvider,
            calendarIdStore: calendarIdStore,
            syncController: syncController
        )
        controller.showWindow(self)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}
