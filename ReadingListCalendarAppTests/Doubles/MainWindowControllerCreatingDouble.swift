import AppKit
@testable import ReadingListCalendarApp

class MainWindowControllerCreatingDouble: MainWindowControllerCreating {
    private(set) var didCreate = false
    private(set) var didCreateWithFileOpenerFactory: FileOpenerCreating?
    private(set) var didCreateWithFileBookmarks: FileBookmarking?
    private(set) var didCreateWithFileReadability: FileReadablity?
    private(set) var didCreateWithCalendarAuthorizer: CalendarAuthorizing?
    private(set) var didCreateWithAlertFactory: ModalAlertCreating?
    private(set) var didCreateWithCalendarsProvider: CalendarsProviding?
    private(set) var didCreateWithCalendarIdStore: CalendarIdStoring?
    private(set) var didCreateWithSyncController: SyncControlling?
    let mock = NSWindowControllerDouble()

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
        didCreate = true
        didCreateWithFileOpenerFactory = fileOpenerFactory
        didCreateWithFileBookmarks = fileBookmarks
        didCreateWithFileReadability = fileReadability
        didCreateWithCalendarAuthorizer = calendarAuthorizer
        didCreateWithAlertFactory = alertFactory
        didCreateWithCalendarsProvider = calendarsProvider
        didCreateWithCalendarIdStore = calendarIdStore
        didCreateWithSyncController = syncController

        return mock
    }
}
