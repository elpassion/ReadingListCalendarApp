import Quick
import Nimble
import Foundation
@testable import ReadingListCalendarApp

class BookmarkReadingListSpec: QuickSpec {
    override func spec() {
        context("Bookmark with reading list items") {
            var sut: Bookmark!

            beforeEach {
                sut = Bookmark.fake()
            }

            it("should have correct reading list items") {
                let expected = [
                    ReadingListItem(
                        uuid: "RL-2",
                        title: "EL Passion | App Development & Design House",
                        url: "https://www.elpassion.com/",
                        dateAdded: Date(timeIntervalSince1970: 1553675065),
                        previewText: "MVP and full digital product development for startups and innovative companies. Custom web app development, mobile app development, and digital product design. Get a Free estimate of your project!"
                    ),
                    ReadingListItem(
                        uuid: "RL-1",
                        title: "Dariusz Rybicki - Software Engineer, Web, iOS and OS X App Developer",
                        url: "http://darrarski.pl/",
                        dateAdded: Date(timeIntervalSince1970: 1553675119),
                        previewText: nil
                    )
                ]
                expect(try? sut.readingListItems()) == expected
            }
        }

        context("Bookmark without reading list") {
            var sut: Bookmark!

            beforeEach {
                sut = Bookmark(
                    uuid: "1",
                    title: nil,
                    children: [],
                    uri: nil,
                    url: nil,
                    readingList: nil
                )
            }

            it("should throw reading list not found error") {
                var thrownError: Error?
                do {
                    _ = try sut.readingListItems()
                } catch {
                    thrownError = error
                }
                expect(thrownError).notTo(beNil())
                if let error = thrownError as? ReadingListError,
                case ReadingListError.readingListNotFound = error {} else {
                    fail("invalid error thrown: \(String(describing: thrownError))")
                }
            }
        }

        context("Bookmark without reading list items") {
            var sut: Bookmark!

            beforeEach {
                sut = Bookmark(
                    uuid: "1",
                    title: nil,
                    children: [
                        Bookmark(
                            uuid: "2",
                            title: "com.apple.ReadingList",
                            children: nil,
                            uri: nil,
                            url: nil,
                            readingList: nil
                        )
                    ],
                    uri: nil,
                    url: nil,
                    readingList: nil
                )
            }

            it("should throw reading list not found error") {
                var thrownError: Error?
                do {
                    _ = try sut.readingListItems()
                } catch {
                    thrownError = error
                }
                expect(thrownError).notTo(beNil())
                if let error = thrownError as? ReadingListError,
                case ReadingListError.readingListItemsNotFound = error {} else {
                    fail("invalid error thrown: \(String(describing: thrownError))")
                }
            }
        }
    }
}
