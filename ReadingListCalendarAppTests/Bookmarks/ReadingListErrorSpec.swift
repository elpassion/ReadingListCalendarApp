import Quick
import Nimble
@testable import ReadingListCalendarApp

class ReadingListErrorSpec: QuickSpec {
    override func spec() {
        describe("reading list not found") {
            var error: ReadingListError!

            beforeEach {
                error = .readingListNotFound
            }

            it("should be correctly localized") {
                expect(error.errorDescription) == "Reading List Error"
                expect(error.failureReason) == "List not found"
            }
        }

        describe("reading list items not found") {
            var error: ReadingListError!

            beforeEach {
                error = .readingListItemsNotFound
            }

            it("should be correctly localized") {
                expect(error.errorDescription) == "Reading List Error"
                expect(error.failureReason) == "Items not found"
            }
        }

        describe("empty title") {
            var error: ReadingListError!

            beforeEach {
                error = .emptyTitle
            }

            it("should be correctly localized") {
                expect(error.errorDescription) == "Reading List Error"
                expect(error.failureReason) == "Item title not found"
            }
        }

        describe("empty URL") {
            var error: ReadingListError!

            beforeEach {
                error = .emptyURL
            }

            it("should be correctly localized") {
                expect(error.errorDescription) == "Reading List Error"
                expect(error.failureReason) == "Item URL not found"
            }
        }

        describe("empty date") {
            var error: ReadingListError!

            beforeEach {
                error = .emptyDate
            }

            it("should be correctly localized") {
                expect(error.errorDescription) == "Reading List Error"
                expect(error.failureReason) == "Item date not found"
            }
        }
    }
}
