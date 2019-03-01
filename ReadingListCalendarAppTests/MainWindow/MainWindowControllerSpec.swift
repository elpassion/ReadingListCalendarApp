import Quick
import Nimble
import RxSwift
@testable import ReadingListCalendarApp

class MainWindowControllerSpec: QuickSpec {
    override func spec() {
        describe("factory") {
            var factory: MainWindowControllerFactory!

            beforeEach {
                factory = MainWindowControllerFactory()
            }

            it("should have correct file opener") {
                expect(factory.fileOpener).to(beAnInstanceOf(type(of: NSOpenPanel())))
            }

            it("should have correct file bookmarks") {
                expect(factory.fileBookmarks) === UserDefaults.standard
            }

            it("should have correct file readability") {
                expect(factory.fileReadability) === FileManager.default
            }

            context("create") {
                var sut: MainWindowController?
                var fileOpener: FileOpeningDouble!
                var fileBookmarks: FileBookmarkingDouble!
                var fileReadability: FileReadabilityDouble!

                beforeEach {
                    fileOpener = FileOpeningDouble()
                    factory.fileOpener = fileOpener
                    fileBookmarks = FileBookmarkingDouble()
                    factory.fileBookmarks = fileBookmarks
                    fileReadability = FileReadabilityDouble()
                    factory.fileReadability = fileReadability
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
                        expect(mainViewController?.fileOpener) === fileOpener
                    }

                    it("should have correct file bookmarks") {
                        expect(mainViewController?.fileBookmarks) === fileBookmarks
                    }

                    it("should have correct file readability") {
                        expect(mainViewController?.fileReadability) === fileReadability
                    }
                }
            }
        }
    }
}

private class FileOpeningDouble: FileOpening {
    func openFile(title: String, ext: String, url: URL?, completion: @escaping (URL?) -> Void) {}
}

private class FileBookmarkingDouble: FileBookmarking {
    func fileURL(forKey key: String) -> Single<URL?> { return .just(nil) }
    func setFileURL(_ url: URL?, forKey key: String) -> Completable { return .empty() }
}

private class FileReadabilityDouble: FileReadablity {
    func isReadableFile(atPath path: String) -> Bool { return false }
}
