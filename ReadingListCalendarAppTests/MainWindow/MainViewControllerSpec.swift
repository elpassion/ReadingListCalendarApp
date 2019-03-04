import Quick
import Nimble
import RxSwift
import EventKit
@testable import ReadingListCalendarApp

class MainViewControllerSpec: QuickSpec {
    override func spec() {
        context("instantiate") {
            var sut: MainViewController?

            beforeEach {
                let bundle = Bundle(for: MainViewController.self)
                let storyboard = NSStoryboard(name: "Main", bundle: bundle)
                let identifier = "MainViewController"
                sut = storyboard.instantiateController(withIdentifier: identifier) as? MainViewController
                _ = sut?.view
            }

            it("should not be nil") {
                expect(sut).notTo(beNil())
            }

            context("set up with readable bookmarks path") {
                var fileBookmarks: FileBookmarkingDouble!

                beforeEach {
                    fileBookmarks = FileBookmarkingDouble()
                    fileBookmarks.urls["bookmarks_file_url"] = URL(fileURLWithPath: "/tmp")
                    sut?.setUp(
                        fileOpenerFactory: FileOpenerCreatingDouble(),
                        fileBookmarks: fileBookmarks,
                        fileReadability: FileManager.default,
                        calendarAuthorizer: CalendarAuthorizingDouble(),
                        alertFactory: ModalAlertCreatingDouble(),
                        calendarsProvider: CalendarsProvidingDouble(),
                        calendarIdStore: CalendarIdStoringDouble()
                    )
                }

                it("should have correct bookmarks path") {
                    expect(sut?.bookmarksPathField.stringValue)
                        == fileBookmarks.urls["bookmarks_file_url"]!.absoluteString
                }

                it("should have correct bookmarks status") {
                    expect(sut?.bookmarksStatusField.stringValue) == "✓ Bookmarks.plist file is set and readable"
                }
            }

            context("set up with not readable bookmarks path") {
                var fileBookmarks: FileBookmarkingDouble!

                beforeEach {
                    fileBookmarks = FileBookmarkingDouble()
                    fileBookmarks.urls["bookmarks_file_url"] = URL(fileURLWithPath: "bookmarks_file_url")
                    sut?.setUp(
                        fileOpenerFactory: FileOpenerCreatingDouble(),
                        fileBookmarks: fileBookmarks,
                        fileReadability: FileManager.default,
                        calendarAuthorizer: CalendarAuthorizingDouble(),
                        alertFactory: ModalAlertCreatingDouble(),
                        calendarsProvider: CalendarsProvidingDouble(),
                        calendarIdStore: CalendarIdStoringDouble()
                    )
                }

                it("should have correct bookmarks path") {
                    let expected = fileBookmarks.urls["bookmarks_file_url"]!.absoluteString
                    expect(sut?.bookmarksPathField.stringValue) == expected
                }

                it("should have correct bookmarks status") {
                    expect(sut?.bookmarksStatusField.stringValue) == "❌ Bookmarks.plist file is not readable"
                }
            }

            context("set up without bookmarks path") {
                beforeEach {
                    sut?.setUp(
                        fileOpenerFactory: FileOpenerCreatingDouble(),
                        fileBookmarks: FileBookmarkingDouble(),
                        fileReadability: FileManager.default,
                        calendarAuthorizer: CalendarAuthorizingDouble(),
                        alertFactory: ModalAlertCreatingDouble(),
                        calendarsProvider: CalendarsProvidingDouble(),
                        calendarIdStore: CalendarIdStoringDouble()
                    )
                }

                it("should have correct bookmarks path message") {
                    expect(sut?.bookmarksPathField.stringValue) == "❌ Bookmarks.plist file is not set"
                }

                it("should have empty bookmarks status") {
                    expect(sut?.bookmarksStatusField.stringValue).to(beEmpty())
                }
            }

            context("set up for opening bookmarks file") {
                var fileOpenerFactory: FileOpenerCreatingDouble!
                var fileBookmarks: FileBookmarkingDouble!

                beforeEach {
                    fileOpenerFactory = FileOpenerCreatingDouble()
                    fileBookmarks = FileBookmarkingDouble()
                    sut?.setUp(
                        fileOpenerFactory: fileOpenerFactory,
                        fileBookmarks: fileBookmarks,
                        fileReadability: FileManager.default,
                        calendarAuthorizer: CalendarAuthorizingDouble(),
                        alertFactory: ModalAlertCreatingDouble(),
                        calendarsProvider: CalendarsProvidingDouble(),
                        calendarIdStore: CalendarIdStoringDouble()
                    )
                }

                context("click bookmarks path button") {
                    beforeEach {
                        sut?.bookmarksPathButton.performClick(nil)
                    }

                    it("should create bookmarks file opener") {
                        expect(fileOpenerFactory.didCreateWithTitle) == "Open Bookmarks.plist file"
                        expect(fileOpenerFactory.didCreateWithExt) == "plist"
                        let expectedURL = URL(fileURLWithPath: "/Users/\(NSUserName())/Library/Safari/Bookmarks.plist")
                        expect(fileOpenerFactory.didCreateWithUrl) == expectedURL
                    }

                    it("should begin opening file") {
                        expect(fileOpenerFactory.openerDouble.didBeginOpeningFile) == true
                    }

                    context("when file is opened") {
                        var url: URL!

                        beforeEach {
                            url = URL(fileURLWithPath: "/tmp")
                            fileOpenerFactory.openerDouble.openFileCompletion?(url)
                        }

                        it("should have correct bookmarks path") {
                            expect(sut?.bookmarksPathField.stringValue) == url.absoluteString
                        }

                        it("should have correct bookmarks status") {
                            expect(sut?.bookmarksStatusField.stringValue) == "✓ Bookmarks.plist file is set and readable"
                        }

                        it("should save bookmarks file url") {
                            expect(fileBookmarks.urls["bookmarks_file_url"]) == url
                        }

                        context("click bookmarks path button") {
                            beforeEach {
                                sut?.bookmarksPathButton.performClick(nil)
                            }

                            context("when file is not opened") {
                                beforeEach {
                                    fileOpenerFactory.openerDouble.openFileCompletion?(nil)
                                }

                                it("should have correct bookmarks path") {
                                    expect(sut?.bookmarksPathField.stringValue) == url.absoluteString
                                }
                            }
                        }
                    }
                }
            }

            context("set up with calendar authorization not determined") {
                var calendarAuthorizer: CalendarAuthorizingDouble!
                var alertFactory: ModalAlertCreatingDouble!

                beforeEach {
                    calendarAuthorizer = CalendarAuthorizingDouble()
                    CalendarAuthorizingDouble.authorizationStatusMock = .notDetermined
                    alertFactory = ModalAlertCreatingDouble()
                    sut?.setUp(
                        fileOpenerFactory: FileOpenerCreatingDouble(),
                        fileBookmarks: FileBookmarkingDouble(),
                        fileReadability: FileManager.default,
                        calendarAuthorizer: calendarAuthorizer,
                        alertFactory: alertFactory,
                        calendarsProvider: CalendarsProvidingDouble(),
                        calendarIdStore: CalendarIdStoringDouble()
                    )
                }

                it("should have correct calendar auth message") {
                    expect(sut?.calendarAuthField.stringValue) == "❌ Callendar access not determined"
                }

                context("click authorize button") {
                    beforeEach {
                        sut?.calendarAuthButton.performClick(nil)
                    }

                    it("should request access to calendar events") {
                        expect(calendarAuthorizer.didRequestAccessToEntityType) == .event
                    }

                    context("when request is granted") {
                        beforeEach {
                            type(of: calendarAuthorizer).authorizationStatusMock = .authorized
                            calendarAuthorizer.requestAccessCompletion?(true, nil)
                        }

                        it("should have correct calendar auth message") {
                            expect(sut?.calendarAuthField.stringValue) == "✓ Callendar access authorized"
                        }
                    }

                    context("when request is denied") {
                        beforeEach {
                            type(of: calendarAuthorizer).authorizationStatusMock = .denied
                            calendarAuthorizer.requestAccessCompletion?(false, nil)
                        }

                        it("should have correct calendar auth message") {
                            expect(sut?.calendarAuthField.stringValue) == "❌ Callendar access denied"
                        }

                        it("should present alert") {
                            expect(alertFactory.didCreateWithStyle) == .warning
                            expect(alertFactory.didCreateWithTitle) == "Calendar Access Denied"
                            expect(alertFactory.didCreateWithMessage) == "Open System Preferences, Security & Privacy and allow the app to access Calendar."
                            expect(alertFactory.alertDouble.didRunModal) == true
                        }
                    }

                    context("when authorization is restricted") {
                        beforeEach {
                            type(of: calendarAuthorizer).authorizationStatusMock = .restricted
                            calendarAuthorizer.requestAccessCompletion?(false, nil)
                        }

                        it("should have correct calendar auth message") {
                            expect(sut?.calendarAuthField.stringValue) == "❌ Callendar access restricted"
                        }

                        it("should present alert") {
                            expect(alertFactory.didCreateWithStyle) == .warning
                            expect(alertFactory.didCreateWithTitle) == "Calendar Access Denied"
                            expect(alertFactory.didCreateWithMessage) == "Open System Preferences, Security & Privacy and allow the app to access Calendar."
                            expect(alertFactory.alertDouble.didRunModal) == true
                        }
                    }

                    context("when request fails with error") {
                        beforeEach {
                            type(of: calendarAuthorizer).authorizationStatusMock = .restricted
                            calendarAuthorizer.requestAccessCompletion?(false, NSError(domain: "", code: 1, userInfo: nil))
                        }

                        it("should have correct calendar auth message") {
                            expect(sut?.calendarAuthField.stringValue) == "❌ Callendar access not determined"
                        }

                        it("should not present alert") {
                            expect(alertFactory.didCreateWithStyle).to(beNil())
                        }
                    }
                }
            }

            context("set up without calendar id") {
                var calendarsProvider: CalendarsProvidingDouble!
                var calendarIdStore: CalendarIdStoringDouble!

                beforeEach {
                    calendarsProvider = CalendarsProvidingDouble()
                    calendarsProvider.mockedCalendars = [
                        EKCalendarDouble(id: "calendar-1", title: "First Calendar"),
                        EKCalendarDouble(id: "calendar-2", title: "Second Calendar"),
                        EKCalendarDouble(id: "calendar-3", title: "Third Calendar")
                    ]
                    calendarIdStore = CalendarIdStoringDouble()
                    sut?.setUp(
                        fileOpenerFactory: FileOpenerCreatingDouble(),
                        fileBookmarks: FileBookmarkingDouble(),
                        fileReadability: FileManager.default,
                        calendarAuthorizer: CalendarAuthorizingDouble(),
                        alertFactory: ModalAlertCreatingDouble(),
                        calendarsProvider: calendarsProvider,
                        calendarIdStore: calendarIdStore
                    )
                }

                it("should have correct calendars list") {
                    let expected = calendarsProvider.mockedCalendars.map { $0.title }
                    expect(sut?.calendarSelectionButton.itemTitles) == expected
                }

                it("should have no selected calendar") {
                    expect(sut?.calendarSelectionButton.selectedItem).to(beNil())
                }

                context("select calendar") {
                    beforeEach {
                        sut?.calendarSelectionButton.menu?.performActionForItem(at: 1)
                    }

                    it("should have correct calendar selected") {
                        expect(sut?.calendarSelectionButton.titleOfSelectedItem) == "Second Calendar"
                    }

                    it("should store selected calendar id") {
                        expect(calendarIdStore.mockedCalendarId) == "calendar-2"
                    }
                }
            }

            context("set up with calendar id") {
                var calendarsProvider: CalendarsProvidingDouble!
                var calendarIdStore: CalendarIdStoringDouble!

                beforeEach {
                    calendarsProvider = CalendarsProvidingDouble()
                    calendarsProvider.mockedCalendars = [
                        EKCalendarDouble(id: "calendar-1", title: "First Calendar"),
                        EKCalendarDouble(id: "calendar-2", title: "Second Calendar"),
                        EKCalendarDouble(id: "calendar-3", title: "Third Calendar")
                    ]
                    calendarIdStore = CalendarIdStoringDouble()
                    calendarIdStore.mockedCalendarId = "calendar-3"
                    sut?.setUp(
                        fileOpenerFactory: FileOpenerCreatingDouble(),
                        fileBookmarks: FileBookmarkingDouble(),
                        fileReadability: FileManager.default,
                        calendarAuthorizer: CalendarAuthorizingDouble(),
                        alertFactory: ModalAlertCreatingDouble(),
                        calendarsProvider: calendarsProvider,
                        calendarIdStore: calendarIdStore
                    )
                }

                it("should have correct calendars list") {
                    let expected = calendarsProvider.mockedCalendars.map { $0.title }
                    expect(sut?.calendarSelectionButton.itemTitles) == expected
                }

                it("should have correct calendar selected") {
                    expect(sut?.calendarSelectionButton.titleOfSelectedItem) == "Third Calendar"
                }
            }
        }
    }
}

private extension MainViewController {
    var bookmarksPathField: NSTextField! { return view.accessibilityElement(id: #function) }
    var bookmarksPathButton: NSButton! { return view.accessibilityElement(id: #function) }
    var bookmarksStatusField: NSTextField! { return view.accessibilityElement(id: #function) }
    var calendarAuthField: NSTextField! { return view.accessibilityElement(id: #function) }
    var calendarAuthButton: NSButton! { return view.accessibilityElement(id: #function) }
    var calendarSelectionButton: NSPopUpButton! { return view.accessibilityElement(id: #function) }
}

private class FileOpenerCreatingDouble: FileOpenerCreating {
    var openerDouble = FileOpeningDouble()
    private(set) var didCreateWithTitle: String?
    private(set) var didCreateWithExt: String?
    private(set) var didCreateWithUrl: URL?

    func create(title: String, ext: String, url: URL?) -> FileOpening {
        didCreateWithTitle = title
        didCreateWithExt = ext
        didCreateWithUrl = url
        return openerDouble
    }
}

private class FileOpeningDouble: FileOpening {
    private(set) var didBeginOpeningFile = false
    private(set) var openFileCompletion: ((URL?) -> Void)?

    func openFile(completion: @escaping (URL?) -> Void) {
        didBeginOpeningFile = true
        openFileCompletion = completion
    }
}

private class FileBookmarkingDouble: FileBookmarking {
    var urls = [String: URL]()

    func fileURL(forKey key: String) -> Single<URL?> {
        return .just(urls[key])
    }

    func setFileURL(_ url: URL?, forKey key: String) -> Completable {
        urls[key] = url
        return .empty()
    }
}

private class CalendarAuthorizingDouble: CalendarAuthorizing {
    static var authorizationStatusMock = EKAuthorizationStatus.notDetermined
    private(set) var didRequestAccessToEntityType: EKEntityType?
    private(set) var requestAccessCompletion: EKEventStoreRequestAccessCompletionHandler?

    static func authorizationStatus(for entityType: EKEntityType) -> EKAuthorizationStatus {
        return authorizationStatusMock
    }

    func requestAccess(to entityType: EKEntityType, completion: @escaping EKEventStoreRequestAccessCompletionHandler) {
        didRequestAccessToEntityType = entityType
        requestAccessCompletion = completion
    }
}

private class ModalAlertCreatingDouble: ModalAlertCreating {
    var alertDouble = ModalAlertDouble()
    private(set) var didCreateWithStyle: NSAlert.Style?
    private(set) var didCreateWithTitle: String?
    private(set) var didCreateWithMessage: String?

    func create(style: NSAlert.Style, title: String, message: String) -> ModalAlert {
        didCreateWithStyle = style
        didCreateWithTitle = title
        didCreateWithMessage = message
        return alertDouble
    }
}

private class ModalAlertDouble: ModalAlert {
    private(set) var didRunModal = false

    func runModal() -> NSApplication.ModalResponse {
        didRunModal = true
        return .OK
    }
}

private class CalendarsProvidingDouble: CalendarsProviding {
    var mockedCalendars = [EKCalendarDouble]()

    func calendars(for entityType: EKEntityType) -> [EKCalendar] { return mockedCalendars }
}

private class EKCalendarDouble: EKCalendar {
    init(id: String, title: String) {
        fakeId = id
        fakeTitle = title
        super.init()
    }

    override var calendarIdentifier: String {
        return fakeId
    }

    override var title: String {
        get { return fakeTitle }
        set { fakeTitle = newValue }
    }

    private let fakeId: String
    private var fakeTitle: String
}

private class CalendarIdStoringDouble: CalendarIdStoring {
    var mockedCalendarId: String?

    func calendarId() -> Single<String?> {
        return .just(mockedCalendarId)
    }

    func setCalendarId(_ id: String?) -> Completable {
        return .create { observer in
            self.mockedCalendarId = id
            observer(.completed)
            return Disposables.create()
        }
    }
}
