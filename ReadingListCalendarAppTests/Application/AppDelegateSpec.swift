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
