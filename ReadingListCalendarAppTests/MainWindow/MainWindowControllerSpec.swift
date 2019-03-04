import Quick
import Nimble
import RxSwift
import EventKit
@testable import ReadingListCalendarApp

class MainWindowControllerSpec: QuickSpec {
    override func spec() {
        describe("factory") {
            var factory: MainWindowControllerFactory!

            beforeEach {
                factory = MainWindowControllerFactory()
            }

            it("should have correct file opener") {
                expect(factory.fileOpenerFactory).to(beAnInstanceOf(FileOpenerFactory.self))
            }

            it("should have correct file bookmarks") {
                expect(factory.fileBookmarks) === UserDefaults.standard
            }

            it("should have correct file readability") {
                expect(factory.fileReadability) === FileManager.default
            }

            it("should have correct calendar authorizer") {
                expect(factory.calendarAuthorizer).to(beAKindOf(EKEventStore.self))
            }

            it("should have correct alert factory") {
                expect(factory.alertFactory).to(beAnInstanceOf(ModalAlertFactory.self))
            }

            it("should have correct calendars provider") {
                expect(factory.calendarsProvider).to(beAKindOf(EKEventStore.self))
            }

            context("create") {
                var sut: MainWindowController?
                var fileOpenerFactory: FileOpenerCreatingDouble!
                var fileBookmarks: FileBookmarkingDouble!
                var fileReadability: FileReadabilityDouble!
                var calendarAuthorizer: CalendarAuthorizingDouble!
                var alertFactory: ModalAlertCreatingDouble!
                var calendarsProvider: CalendarsProvidingDouble!

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

                    it("should have correct file opener") {
                        expect(mainViewController?.fileOpenerFactory) === fileOpenerFactory
                    }

                    it("should have correct file bookmarks") {
                        expect(mainViewController?.fileBookmarks) === fileBookmarks
                    }

                    it("should have correct file readability") {
                        expect(mainViewController?.fileReadability) === fileReadability
                    }

                    it("should have correct calendar authorizer") {
                        expect(mainViewController?.calendarAuthorizer) === calendarAuthorizer
                    }

                    it("should have correct alert factory") {
                        expect(mainViewController?.alertFactory) === alertFactory
                    }

                    it("should have correct calendars provider") {
                        expect(mainViewController?.calendarsProvider) === calendarsProvider
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
