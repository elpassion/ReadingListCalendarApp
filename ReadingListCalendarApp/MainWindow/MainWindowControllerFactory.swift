import AppKit
import EventKit

struct MainWindowControllerFactory: MainWindowControllerCreating {
    var fileOpenerFactory: FileOpenerCreating = FileOpenerFactory()
    var fileBookmarks: FileBookmarking = UserDefaults.standard
    var fileReadability: FileReadablity = FileManager.default
    var calendarAuthorizer: CalendarAuthorizing = EKEventStore()
    var alertFactory: ModalAlertCreating = ModalAlertFactory()
    var calendarsProvider: CalendarsProviding = EKEventStore()
    var calendarIdStore: CalendarIdStoring = UserDefaults.standard
    var syncController: SyncControlling = SyncController()

    func create() -> NSWindowController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = "MainWindowController"
        // swiftlint:disable:next force_cast
        let controller = storyboard.instantiateController(withIdentifier: identifier) as! MainWindowController
        controller.mainViewController.setUp(
            fileOpenerFactory: fileOpenerFactory,
            fileBookmarks: fileBookmarks,
            fileReadability: fileReadability,
            calendarAuthorizer: calendarAuthorizer,
            alertFactory: alertFactory,
            calendarsProvider: calendarsProvider,
            calendarIdStore: calendarIdStore,
            syncController: syncController
        )
        return controller
    }
}
