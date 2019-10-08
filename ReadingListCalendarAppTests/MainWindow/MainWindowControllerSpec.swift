import Quick
import Nimble
import RxSwift
import RxCocoa
import EventKit
@testable import ReadingListCalendarApp

class MainWindowControllerSpec: QuickSpec {
    override func spec() {
        describe("factory") {
            var factory: MainWindowControllerFactory!

            beforeEach {
                factory = MainWindowControllerFactory()
            }

            context("create") {
                var sut: MainWindowController?
                var fileOpenerFactory: FileOpenerCreatingDouble!
                var fileBookmarks: FileBookmarkingDouble!
                var fileReadability: FileReadabilityDouble!
                var calendarAuthorizer: CalendarAuthorizingDouble!
                var alertFactory: ModalAlertCreatingDouble!
                var calendarsProvider: CalendarsProvidingDouble!
                var calendarIdStore: CalendarIdStoringDouble!
                var syncController: SyncControllingDouble!

                beforeEach {
                    fileOpenerFactory = FileOpenerCreatingDouble()
                    fileBookmarks = FileBookmarkingDouble()
                    fileReadability = FileReadabilityDouble()
                    calendarAuthorizer = CalendarAuthorizingDouble()
                    alertFactory = ModalAlertCreatingDouble()
                    calendarsProvider = CalendarsProvidingDouble()
                    calendarIdStore = CalendarIdStoringDouble()
                    syncController = SyncControllingDouble()
                    sut = factory.create(
                        fileOpenerFactory: fileOpenerFactory,
                        fileBookmarks: fileBookmarks,
                        fileReadability: fileReadability,
                        calendarAuthorizer: calendarAuthorizer,
                        alertFactory: alertFactory,
                        calendarsProvider: calendarsProvider,
                        calendarIdStore: calendarIdStore,
                        syncController: syncController
                    ) as? MainWindowController
                }

                afterEach {
                    sut = nil
                }

                it("should not be nil") {
                    expect(sut).notTo(beNil())
                }

                describe("main view controller") {
                    var mainViewController: MainViewController?

                    beforeEach {
                        mainViewController = sut?.mainViewController
                    }

                    it("should not be nil") {
                        expect(mainViewController).notTo(beNil())
                    }

                    it("should have correct dependencies") {
                        expect(mainViewController?.fileOpenerFactory) === fileOpenerFactory
                        expect(mainViewController?.fileBookmarks) === fileBookmarks
                        expect(mainViewController?.fileReadability) === fileReadability
                        expect(mainViewController?.calendarAuthorizer) === calendarAuthorizer
                        expect(mainViewController?.alertFactory) === alertFactory
                        expect(mainViewController?.calendarsProvider) === calendarsProvider
                        expect(mainViewController?.calendarIdStore) === calendarIdStore
                        expect(mainViewController?.syncController) === syncController
                    }
                }
            }
        }
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
