import Quick
import Nimble
import Foundation
@testable import ReadingListCalendarApp

class BookmarksLoaderSpec: QuickSpec {
    override func spec() {
        describe("BookmarksLoader") {
            var sut: BookmarksLoader!
            var fileReader: FileReadingDouble!

            beforeEach {
                fileReader = FileReadingDouble()
                sut = BookmarksLoader()
                sut.fileReader = fileReader
            }

            context("load") {
                var url: URL!
                var bookmarks: Bookmark!

                beforeEach {
                    fileReader.mockedData = Bookmark.fakeData()
                    url = URL(fileURLWithPath: "bookmarks-url")
                    bookmarks = try! sut.load(fromURL: url)
                }

                it("should read data from url") {
                    expect(fileReader.didReadContentsAtPath) == url.path
                }

                it("should return correct booomarks") {
                    expect(bookmarks) == Bookmark.fake()
                }
            }

            context("load from invalid url") {
                var url: URL!
                var thrownError: Error?

                beforeEach {
                    url = URL(fileURLWithPath: "invalid url")
                    fileReader.mockedData = nil
                    do {
                        _ = try sut.load(fromURL: url)
                    } catch {
                        thrownError = error
                    }
                }

                it("should throw error") {
                    expect(thrownError).notTo(beNil())
                    if let thrownError = thrownError as? BookmarksLoadingError,
                        case let .unableToLoad(fromURL) = thrownError {
                        expect(fromURL) == url
                    } else {
                        fail("invalid error thrown")
                    }
                }
            }

            context("load from invalid data") {
                var thrownError: Error?

                beforeEach {
                    fileReader.mockedData = Data()
                    do {
                        _ = try sut.load(fromURL: URL(fileURLWithPath: ""))
                    } catch {
                        thrownError = error
                    }
                }

                it("should throw error") {
                    expect(thrownError).notTo(beNil())
                    if let thrownError = thrownError as? BookmarksLoadingError,
                        case let .decodingError(error) = thrownError {
                        expect(error.localizedDescription).notTo(beEmpty())
                    } else {
                        fail("invalid error thrown")
                    }
                }
            }
        }
    }
}
