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
