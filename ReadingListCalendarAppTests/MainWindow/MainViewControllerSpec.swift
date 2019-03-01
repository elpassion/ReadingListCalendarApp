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

            context("set up with stored bookmarks path") {
                var fileOpener: FileOpeningDouble!
                var fileBookmarks: FileBookmarkingDouble!
                var calendarAuthorizer: CalendarAuthorizingDouble!

                beforeEach {
                    fileOpener = FileOpeningDouble()
                    fileBookmarks = FileBookmarkingDouble()
                    fileBookmarks.urls["bookmarks_file_url"] = URL(fileURLWithPath: "bookmarks_file_url")
                    calendarAuthorizer = CalendarAuthorizingDouble()
                    sut?.setUp(
                        fileOpener: fileOpener,
                        fileBookmarks: fileBookmarks,
                        fileReadability: FileManager.default,
                        calendarAuthorizer: calendarAuthorizer
                    )
                }

                it("should have correct bookmarks path") {
                    expect(sut?.bookmarksPathField.stringValue)
                        == fileBookmarks.urls["bookmarks_file_url"]!.absoluteString
                }

                it("should have correct bookmarks status") {
                    expect(sut?.bookmarksStatusField.stringValue)
                        == "❌ Bookmarks.plist file is not readable"
                }

                context("click bookmarks path button") {
                    beforeEach {
                        sut?.bookmarksPathButton.performClick(nil)
                    }

                    it("should begin opening file") {
                        expect(fileOpener.didBeginOpeningFile) == true
                        expect(fileOpener.didBeginOpeningFileWithTitle) == "Open Bookmarks.plist file"
                        expect(fileOpener.didBeginOpeningFileWithExt) == "plist"
                        let expectedURL = URL(fileURLWithPath: "/Users/\(NSUserName())/Library/Safari/Bookmarks.plist")
                        expect(fileOpener.didBeginOpeningFileWithURL) == expectedURL
                    }

                    context("when file is opened") {
                        var url: URL!

                        beforeEach {
                            url = URL(fileURLWithPath: "/tmp")
                            fileOpener.openFileCompletion?(url)
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
                                    fileOpener.openFileCompletion?(nil)
                                }

                                it("should have correct bookmarks path") {
                                    expect(sut?.bookmarksPathField.stringValue) == url.absoluteString
                                }
                            }
                        }
                    }
                }
            }

            context("set up without stored bookmarks path") {
                beforeEach {
                    sut?.setUp(
                        fileOpener: FileOpeningDouble(),
                        fileBookmarks: FileBookmarkingDouble(),
                        fileReadability: FileManager.default,
                        calendarAuthorizer: CalendarAuthorizingDouble()
                    )
                }

                it("should have correct bookmarks path message") {
                    expect(sut?.bookmarksPathField.stringValue) == "❌ Bookmarks.plist file is not set"
                }

                it("should have empty bookmarks status") {
                    expect(sut?.bookmarksStatusField.stringValue).to(beEmpty())
                }
            }

            context("set up with calendar authorization not determined") {
                var calendarAuthorizer: CalendarAuthorizingDouble!

                beforeEach {
                    calendarAuthorizer = CalendarAuthorizingDouble()
                    CalendarAuthorizingDouble.authorizationStatusMock = .notDetermined
                    sut?.setUp(
                        fileOpener: FileOpeningDouble(),
                        fileBookmarks: FileBookmarkingDouble(),
                        fileReadability: FileManager.default,
                        calendarAuthorizer: calendarAuthorizer
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
                    }

                    context("when authorization is restricted") {
                        beforeEach {
                            type(of: calendarAuthorizer).authorizationStatusMock = .restricted
                            calendarAuthorizer.requestAccessCompletion?(false, nil)
                        }

                        it("should have correct calendar auth message") {
                            expect(sut?.calendarAuthField.stringValue) == "❌ Callendar access restricted"
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
}

private class FileOpeningDouble: FileOpening {
    private(set) var didBeginOpeningFile = false
    private(set) var didBeginOpeningFileWithTitle: String?
    private(set) var didBeginOpeningFileWithExt: String?
    private(set) var didBeginOpeningFileWithURL: URL?
    private(set) var openFileCompletion: ((URL?) -> Void)?

    func openFile(title: String, ext: String, url: URL?, completion: @escaping (URL?) -> Void) {
        didBeginOpeningFile = true
        didBeginOpeningFileWithTitle = title
        didBeginOpeningFileWithExt = ext
        didBeginOpeningFileWithURL = url
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
