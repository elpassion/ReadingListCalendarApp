import Quick
import Nimble
import RxSwift
import RxCocoa
import EventKit
@testable import ReadingListCalendarApp

class AppDelegateSpec: QuickSpec {
    override func spec() {
        context("create") {
            var sut: AppDelegate!

            beforeEach {
                sut = AppDelegate()
            }

            it("should have correct dependencies") {
                expect(sut.mainWindowControllerFactory)
                    .to(beAnInstanceOf(MainWindowControllerFactory.self))
                expect(sut.fileOpenerFactory).to(beAnInstanceOf(FileOpenerFactory.self))
                expect(sut.fileBookmarks) === UserDefaults.standard
                expect(sut.fileReadability) === FileManager.default
                expect(sut.calendarAuthorizer).to(beAKindOf(EKEventStore.self))
                expect(sut.alertFactory).to(beAnInstanceOf(ModalAlertFactory.self))
                expect(sut.calendarsProvider).to(beAKindOf(EKEventStore.self))
                expect(sut.calendarIdStore) === UserDefaults.standard
                expect(sut.syncController).to(beAnInstanceOf(SyncController.self))
            }

            it("should terminate after last window closed") {
                expect(sut.applicationShouldTerminateAfterLastWindowClosed(NSApplication.shared)) == true
            }

            context("when app did finish launching") {
                var mainWindowControllerFactory: MainWindowControllerCreatingDouble!
                var fileOpenerFactory: FileOpenerCreatingDouble!
                var fileBookmarks: FileBookmarkingDouble!
                var fileReadability: FileReadabilityDouble!
                var calendarAuthorizer: CalendarAuthorizingDouble!
                var alertFactory: ModalAlertCreatingDouble!
                var calendarsProvider: CalendarsProvidingDouble!
                var calendarIdStore: CalendarIdStoringDouble!
                var syncController: SyncControllingDouble!

                beforeEach {
                    mainWindowControllerFactory = MainWindowControllerCreatingDouble()
                    fileOpenerFactory = FileOpenerCreatingDouble()
                    fileBookmarks = FileBookmarkingDouble()
                    fileReadability = FileReadabilityDouble()
                    calendarAuthorizer = CalendarAuthorizingDouble()
                    alertFactory = ModalAlertCreatingDouble()
                    calendarsProvider = CalendarsProvidingDouble()
                    calendarIdStore = CalendarIdStoringDouble()
                    syncController = SyncControllingDouble()
                    sut.mainWindowControllerFactory = mainWindowControllerFactory
                    sut.fileOpenerFactory = fileOpenerFactory
                    sut.fileBookmarks = fileBookmarks
                    sut.fileReadability = fileReadability
                    sut.calendarAuthorizer = calendarAuthorizer
                    sut.alertFactory = alertFactory
                    sut.calendarsProvider = calendarsProvider
                    sut.calendarIdStore = calendarIdStore
                    sut.syncController = syncController

                    sut.applicationDidFinishLaunching(Notification(name: Notification.Name(rawValue: "")))
                }

                it("should create main window controller with correct dependencies") {
                    expect(mainWindowControllerFactory.didCreate) == true
                    expect(mainWindowControllerFactory.didCreateWithFileOpenerFactory) === fileOpenerFactory
                    expect(mainWindowControllerFactory.didCreateWithFileBookmarks) === fileBookmarks
                    expect(mainWindowControllerFactory.didCreateWithFileReadability) === fileReadability
                    expect(mainWindowControllerFactory.didCreateWithCalendarAuthorizer) === calendarAuthorizer
                    expect(mainWindowControllerFactory.didCreateWithAlertFactory) === alertFactory
                    expect(mainWindowControllerFactory.didCreateWithCalendarsProvider) === calendarsProvider
                    expect(mainWindowControllerFactory.didCreateWithCalendarIdStore) === calendarIdStore
                    expect(mainWindowControllerFactory.didCreateWithSyncController) === syncController
                }

                it("should show main window") {
                    let mainWindowController = mainWindowControllerFactory.mock
                    expect(mainWindowController.didShowWindow) == true
                    expect(mainWindowController.didShowWindowSender) === sut
                }
            }
        }
    }
}

private class MainWindowControllerCreatingDouble: MainWindowControllerCreating {

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

private class NSWindowControllerDouble: NSWindowController {
    private(set) var didShowWindow = false
    private(set) var didShowWindowSender: Any?

    override func showWindow(_ sender: Any?) {
        didShowWindow = true
        didShowWindowSender = sender
    }
}

private class FileOpenerCreatingDouble: FileOpenerCreating {
    func create(title: String, ext: String, url: URL?) -> FileOpening { return NSOpenPanel() }
}

private class FileBookmarkingDouble: FileBookmarking {
    func fileURL(forKey key: String) -> Single<URL?> { return .just(nil) }
    func setFileURL(_ url: URL?, forKey key: String) -> Completable { return .empty() }
}

private class FileReadabilityDouble: FileReadablity {
    func isReadableFile(atPath path: String) -> Bool { return false }
}

private class CalendarAuthorizingDouble: CalendarAuthorizing {
    static func authorizationStatus(for entityType: EKEntityType) -> EKAuthorizationStatus { return .notDetermined }
    func requestAccess(to entityType: EKEntityType, completion: @escaping EKEventStoreRequestAccessCompletionHandler) {}
}

private class ModalAlertCreatingDouble: ModalAlertCreating {
    func create(style: NSAlert.Style, title: String, message: String) -> ModalAlert { return NSAlert() }
}

private class CalendarsProvidingDouble: CalendarsProviding {
    func calendars(for entityType: EKEntityType) -> [EKCalendar] { return [] }
}

private class CalendarIdStoringDouble: CalendarIdStoring {
    func calendarId() -> Single<String?> { return .just(nil) }
    func setCalendarId(_ id: String?) -> Completable { return .empty() }
}

private class SyncControllingDouble: SyncControlling {
    var isSynchronizing: Driver<Bool> { return .empty() }
    var syncProgress: Driver<Double?> { return .empty() }

    func sync(bookmarksUrl: URL, calendarId: String) -> Completable { return .empty() }
}
