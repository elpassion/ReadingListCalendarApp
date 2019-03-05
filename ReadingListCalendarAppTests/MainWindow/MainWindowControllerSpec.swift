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

            it("should have correct dependencies") {
                expect(factory.fileOpenerFactory).to(beAnInstanceOf(FileOpenerFactory.self))
                expect(factory.fileBookmarks) === UserDefaults.standard
                expect(factory.fileReadability) === FileManager.default
                expect(factory.calendarAuthorizer).to(beAKindOf(EKEventStore.self))
                expect(factory.alertFactory).to(beAnInstanceOf(ModalAlertFactory.self))
                expect(factory.calendarsProvider).to(beAKindOf(EKEventStore.self))
                expect(factory.calendarIdStore) === UserDefaults.standard
                expect(factory.syncController).to(beAnInstanceOf(SyncController.self))
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
                    factory.fileOpenerFactory = fileOpenerFactory
                    fileBookmarks = FileBookmarkingDouble()
                    factory.fileBookmarks = fileBookmarks
                    fileReadability = FileReadabilityDouble()
                    factory.fileReadability = fileReadability
                    calendarAuthorizer = CalendarAuthorizingDouble()
                    factory.calendarAuthorizer = calendarAuthorizer
                    alertFactory = ModalAlertCreatingDouble()
                    factory.alertFactory = alertFactory
                    calendarsProvider = CalendarsProvidingDouble()
                    factory.calendarsProvider = calendarsProvider
                    calendarIdStore = CalendarIdStoringDouble()
                    factory.calendarIdStore = calendarIdStore
                    syncController = SyncControllingDouble()
                    factory.syncController = syncController
                    sut = factory.create() as? MainWindowController
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
