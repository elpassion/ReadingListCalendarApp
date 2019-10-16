import Quick
import Nimble
import Cocoa
import EventKit
@testable import ReadingListCalendarApp

class AppDelegateSpec: QuickSpec {
    override func spec() {
        context("create") {
            var sut: AppDelegate!

            beforeEach {
                sut = AppDelegate()
            }

            it("should have correct launch arguments") {
                expect(sut.launchArguments) == CommandLine.arguments
            }

            it("should have correct dependencies") {
                expect(sut.appTerminator) === NSApplication.shared
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

            context("when app did finish launching without arguments") {
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
                    sut.launchArguments = []
                    sut.appTerminator = AppTerminatingDouble()
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

            context("when app did finish launching with sync argument") {
                var appTerminator: AppTerminatingDouble!
                var mainWindowControllerFactory: MainWindowControllerCreatingDouble!
                var fileOpenerFactory: FileOpenerCreatingDouble!
                var fileBookmarks: FileBookmarkingDouble!
                var bookmarksFileURL: URL!
                var fileReadability: FileReadabilityDouble!
                var calendarAuthorizer: CalendarAuthorizingDouble!
                var alertFactory: ModalAlertCreatingDouble!
                var calendarsProvider: CalendarsProvidingDouble!
                var calendarIdStore: CalendarIdStoringDouble!
                var calendarId: String!
                var syncController: SyncControllingDouble!

                beforeEach {
                    appTerminator = AppTerminatingDouble()
                    mainWindowControllerFactory = MainWindowControllerCreatingDouble()
                    fileOpenerFactory = FileOpenerCreatingDouble()
                    fileBookmarks = FileBookmarkingDouble()
                    bookmarksFileURL = URL(fileURLWithPath: "bookmarks-url")
                    fileBookmarks.urls["bookmarks_file_url"] = bookmarksFileURL
                    fileReadability = FileReadabilityDouble()
                    calendarAuthorizer = CalendarAuthorizingDouble()
                    alertFactory = ModalAlertCreatingDouble()
                    calendarsProvider = CalendarsProvidingDouble()
                    calendarIdStore = CalendarIdStoringDouble()
                    calendarId = "calendar-id"
                    calendarIdStore.mockedCalendarId = calendarId
                    syncController = SyncControllingDouble()
                    sut.launchArguments = ["-sync"]
                    sut.appTerminator = appTerminator
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

                it("should sync with stored bookmarks file url and calendar id") {
                    expect(syncController.didSyncBookmarksUrl) == bookmarksFileURL
                    expect(syncController.didSyncCalendarId) == calendarId
                }

                context("when sync completes") {
                    beforeEach {
                        syncController.syncCompletion?(.success(()))
                    }

                    it("should not terminate app") {
                        expect(appTerminator.didTerminate) == false
                    }
                }

                context("when sync fails") {
                    var error: NSError!

                    beforeEach {
                        error = NSError(domain: "test", code: 123, userInfo: nil)
                        syncController.syncCompletion?(.failure(error))
                    }

                    it("should present error alert") {
                        expect(alertFactory.didCreateWithStyle) == .critical
                        expect(alertFactory.didCreateWithTitle) == error.title
                        expect(alertFactory.didCreateWithMessage) == error.message
                        expect(alertFactory.alertDouble.didRunModal) == true
                    }

                    it("should not terminate app") {
                        expect(appTerminator.didTerminate) == false
                    }
                }
            }

            context("when app did finish launching with sync and headless arguments") {
                var appTerminator: AppTerminatingDouble!
                var mainWindowControllerFactory: MainWindowControllerCreatingDouble!
                var fileOpenerFactory: FileOpenerCreatingDouble!
                var fileBookmarks: FileBookmarkingDouble!
                var bookmarksFileURL: URL!
                var fileReadability: FileReadabilityDouble!
                var calendarAuthorizer: CalendarAuthorizingDouble!
                var alertFactory: ModalAlertCreatingDouble!
                var calendarsProvider: CalendarsProvidingDouble!
                var calendarIdStore: CalendarIdStoringDouble!
                var calendarId: String!
                var syncController: SyncControllingDouble!

                beforeEach {
                    appTerminator = AppTerminatingDouble()
                    mainWindowControllerFactory = MainWindowControllerCreatingDouble()
                    fileOpenerFactory = FileOpenerCreatingDouble()
                    fileBookmarks = FileBookmarkingDouble()
                    bookmarksFileURL = URL(fileURLWithPath: "bookmarks-url")
                    fileBookmarks.urls["bookmarks_file_url"] = bookmarksFileURL
                    fileReadability = FileReadabilityDouble()
                    calendarAuthorizer = CalendarAuthorizingDouble()
                    alertFactory = ModalAlertCreatingDouble()
                    calendarsProvider = CalendarsProvidingDouble()
                    calendarIdStore = CalendarIdStoringDouble()
                    calendarId = "calendar-id"
                    calendarIdStore.mockedCalendarId = calendarId
                    syncController = SyncControllingDouble()
                    sut.launchArguments = ["-sync", "-headless"]
                    sut.appTerminator = appTerminator
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

                it("should not create main window controller") {
                    expect(mainWindowControllerFactory.didCreate) == false
                }

                it("should not show main window") {
                    let mainWindowController = mainWindowControllerFactory.mock
                    expect(mainWindowController.didShowWindow) == false
                }

                it("should sync with stored bookmarks file url and calendar id") {
                    expect(syncController.didSyncBookmarksUrl) == bookmarksFileURL
                    expect(syncController.didSyncCalendarId) == calendarId
                }

                context("when sync completes") {
                    beforeEach {
                        syncController.syncCompletion?(.success(()))
                    }

                    it("should terminate app") {
                        expect(appTerminator.didTerminate) == true
                        expect(appTerminator.didTerminateWithSender).to(beNil())
                    }
                }

                context("when sync fails") {
                    var error: NSError!

                    beforeEach {
                        error = NSError(domain: "test", code: 123, userInfo: nil)
                        syncController.syncCompletion?(.failure(error))
                    }

                    it("should not present error alert") {
                        expect(alertFactory.didCreateWithStyle).to(beNil())
                        expect(alertFactory.alertDouble.didRunModal) == false
                    }

                    it("should terminate app") {
                        expect(appTerminator.didTerminate) == true
                        expect(appTerminator.didTerminateWithSender).to(beNil())
                    }
                }
            }
        }
    }
}
