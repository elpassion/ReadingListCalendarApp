import AppKit
import EventKit

struct MainWindowControllerFactory: MainWindowControllerCreating {
    // swiftlint:disable:next function_parameter_count
    func create(
        fileOpenerFactory: FileOpenerCreating,
        fileBookmarks: FileBookmarking,
        fileReadability: FileReadablity,
        calendarAuthorizer: CalendarAuthorizing,
        alertFactory: ModalAlertCreating,
        calendarsProvider: CalendarsProviding,
        calendarIdStore: CalendarIdStoring,
        syncController: SyncControlling
    ) -> NSWindowController {
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
