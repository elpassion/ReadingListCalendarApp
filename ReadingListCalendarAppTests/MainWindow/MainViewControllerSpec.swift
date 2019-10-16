import Quick
import Nimble
import Cocoa
import RxSwift
import RxCocoa
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
                        calendarIdStore: CalendarIdStoringDouble(),
                        syncController: SyncControllingDouble()
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
                        calendarIdStore: CalendarIdStoringDouble(),
                        syncController: SyncControllingDouble()
                    )
                }

                it("should have correct bookmarks path") {
                    let expected = fileBookmarks.urls["bookmarks_file_url"]!.absoluteString
                    expect(sut?.bookmarksPathField.stringValue) == expected
                }

                it("should have correct bookmarks status") {
                    expect(sut?.bookmarksStatusField.stringValue) == "❌ Bookmarks.plist file is not readable"
                }

                it("should sync button be disabled") {
                    expect(sut?.synchronizeButton.isEnabled) == false
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
                        calendarIdStore: CalendarIdStoringDouble(),
                        syncController: SyncControllingDouble()
                    )
                }

                it("should have correct bookmarks path message") {
                    expect(sut?.bookmarksPathField.stringValue) == "❌ Bookmarks.plist file is not set"
                }

                it("should have empty bookmarks status") {
                    expect(sut?.bookmarksStatusField.stringValue).to(beEmpty())
                }

                it("should sync button be disabled") {
                    expect(sut?.synchronizeButton.isEnabled) == false
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
                        calendarIdStore: CalendarIdStoringDouble(),
                        syncController: SyncControllingDouble()
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
                        calendarIdStore: CalendarIdStoringDouble(),
                        syncController: SyncControllingDouble()
                    )
                }

                it("should have correct calendar auth message") {
                    expect(sut?.calendarAuthField.stringValue) == "❌ Callendar access not determined"
                }

                it("should sync button be disabled") {
                    expect(sut?.synchronizeButton.isEnabled) == false
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
                        calendarIdStore: calendarIdStore,
                        syncController: SyncControllingDouble()
                    )
                }

                it("should have correct calendars list") {
                    let expected = calendarsProvider.mockedCalendars
                        .enumerated()
                        .map { "\($0.offset + 1). \($0.element.title)" }
                    expect(sut?.calendarSelectionButton.itemTitles) == expected
                }

                it("should have no selected calendar") {
                    expect(sut?.calendarSelectionButton.selectedItem).to(beNil())
                }

                it("should sync button be disabled") {
                    expect(sut?.synchronizeButton.isEnabled) == false
                }

                context("select calendar") {
                    beforeEach {
                        sut?.calendarSelectionButton.menu?.performActionForItem(at: 1)
                    }

                    it("should have correct calendar selected") {
                        expect(sut?.calendarSelectionButton.titleOfSelectedItem) == "2. Second Calendar"
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
                        calendarIdStore: calendarIdStore,
                        syncController: SyncControllingDouble()
                    )
                }

                it("should have correct calendars list") {
                    let expected = calendarsProvider.mockedCalendars
                        .enumerated()
                        .map { "\($0.offset + 1). \($0.element.title)" }
                    expect(sut?.calendarSelectionButton.itemTitles) == expected
                }

                it("should have correct calendar selected") {
                    expect(sut?.calendarSelectionButton.titleOfSelectedItem) == "3. Third Calendar"
                }
            }

            context("set up with readable bookmarks path and calendar set and authorized") {
                var fileBookmarks: FileBookmarkingDouble!
                var alertFactory: ModalAlertCreatingDouble!
                var calendarIdStore: CalendarIdStoringDouble!
                var syncController: SyncControllingDouble!

                beforeEach {
                    fileBookmarks = FileBookmarkingDouble()
                    fileBookmarks.urls["bookmarks_file_url"] = URL(fileURLWithPath: "/tmp")

                    let calendarAuthorizer = CalendarAuthorizingDouble()
                    CalendarAuthorizingDouble.authorizationStatusMock = .authorized

                    alertFactory = ModalAlertCreatingDouble()

                    let calendarsProvider = CalendarsProvidingDouble()
                    calendarsProvider.mockedCalendars = [
                        EKCalendarDouble(id: "calendar-1", title: "First Calendar")
                    ]

                    calendarIdStore = CalendarIdStoringDouble()
                    calendarIdStore.mockedCalendarId = "calendar-1"

                    syncController = SyncControllingDouble()

                    sut?.setUp(
                        fileOpenerFactory: FileOpenerCreatingDouble(),
                        fileBookmarks: fileBookmarks,
                        fileReadability: FileManager.default,
                        calendarAuthorizer: calendarAuthorizer,
                        alertFactory: alertFactory,
                        calendarsProvider: calendarsProvider,
                        calendarIdStore: calendarIdStore,
                        syncController: syncController
                    )
                }

                it("should sync button be enabled") {
                    expect(sut?.synchronizeButton.isEnabled) == true
                }

                context("click sync button") {
                    beforeEach {
                        sut?.synchronizeButton.performClick(nil)
                    }

                    it("should synchronize") {
                        expect(syncController.didSyncBookmarksUrl) == fileBookmarks.urls["bookmarks_file_url"]!
                        expect(syncController.didSyncCalendarId) == calendarIdStore.mockedCalendarId
                    }

                    context("when sync starts") {
                        beforeEach {
                            syncController.syncProgressMock.accept(0)
                            syncController.isSynchronizingMock.accept(true)
                        }

                        it("should disable buttons") {
                            expect(sut?.bookmarksPathButton.isEnabled) == false
                            expect(sut?.calendarAuthButton.isEnabled) == false
                            expect(sut?.calendarSelectionButton.isEnabled) == false
                            expect(sut?.synchronizeButton.isEnabled) == false
                        }

                        it("should show empty progress") {
                            expect(sut?.progressIndicator.doubleValue) == 0
                        }

                        context("when sync progresses") {
                            beforeEach {
                                syncController.syncProgressMock.accept(0.75)
                            }

                            it("should show correct progress") {
                                expect(sut?.progressIndicator.doubleValue) == 75
                            }
                        }

                        context("when sync finishes") {
                            beforeEach {
                                syncController.syncObserver?(.completed)
                                syncController.syncProgressMock.accept(nil)
                                syncController.isSynchronizingMock.accept(false)
                            }

                            it("should enable buttons") {
                                expect(sut?.bookmarksPathButton.isEnabled) == true
                                expect(sut?.calendarAuthButton.isEnabled) == true
                                expect(sut?.calendarSelectionButton.isEnabled) == true
                                expect(sut?.synchronizeButton.isEnabled) == true
                            }

                            it("should show empty progress") {
                                expect(sut?.progressIndicator.doubleValue) == 0
                            }
                        }

                        context("when sync fails with error") {
                            var error: NSError!

                            beforeEach {
                                error = NSError(domain: "test", code: 123, userInfo: nil)
                                syncController.syncObserver?(.error(error))
                            }

                            it("should present error alert") {
                                expect(alertFactory.didCreateWithStyle) == .critical
                                expect(alertFactory.didCreateWithTitle) == error.title
                                expect(alertFactory.didCreateWithMessage) == error.message
                                expect(alertFactory.alertDouble.didRunModal) == true
                            }
                        }
                    }
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
    var synchronizeButton: NSButton! { return view.accessibilityElement(id: #function) }
    var progressIndicator: NSProgressIndicator! { return view.accessibilityElement(id: #function) }
}
