import Quick
import Nimble
import RxSwift
@testable import ReadingListCalendarApp

class MainViewControllerSpec: QuickSpec {
    override func spec() {
        context("instantiate") {
            var sut: MainViewController?
            var fileOpener: FileOpeningDouble!
            var fileBookmarks: FileBookmarkingDouble!

            beforeEach {
                let bundle = Bundle(for: MainViewController.self)
                let storyboard = NSStoryboard(name: "Main", bundle: bundle)
                let identifier = "MainViewController"
                sut = storyboard.instantiateController(withIdentifier: identifier) as? MainViewController
                _ = sut?.view
                fileOpener = FileOpeningDouble()
                fileBookmarks = FileBookmarkingDouble()
                fileBookmarks.urls["bookmarks_file_url"] = URL(fileURLWithPath: "bookmarks_file_url")
                sut?.setUp(fileOpener: fileOpener, fileBookmarks: fileBookmarks)
            }

            it("should not be nil") {
                expect(sut).notTo(beNil())
            }

            it("should have correct bookmarks path") {
                expect(sut?.bookmarksPathField.stringValue) == fileBookmarks.urls["bookmarks_file_url"]!.absoluteString
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
                        url = URL(fileURLWithPath: "/tmp/Bookmarks.plist")
                        fileOpener.openFileCompletion?(url)
                    }

                    it("should have correct bookmarks path") {
                        expect(sut?.bookmarksPathField.stringValue) == url.absoluteString
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
    }
}

private extension MainViewController {
    var bookmarksPathField: NSTextField! { return view.accessibilityElement(id: #function) }
    var bookmarksPathButton: NSButton! { return view.accessibilityElement(id: #function) }
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
