import AppKit

protocol MainWindowControllerCreating {
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
    ) -> NSWindowController
}
