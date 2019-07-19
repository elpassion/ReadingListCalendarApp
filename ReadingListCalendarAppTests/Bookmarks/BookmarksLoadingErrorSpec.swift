import Quick
import Nimble
@testable import ReadingListCalendarApp

class BookmarksLoadingErrorSpec: QuickSpec {
    override func spec() {
        describe("unable to load error") {
            var error: BookmarksLoadingError!
            var url: URL!

            beforeEach {
                url = URL(fileURLWithPath: "/test/path")
                error = .unableToLoad(url)
            }

            it("should be correctly localized") {
                expect(error.errorDescription) == "Bookmarks Loading Error"
                expect(error.failureReason) == "Could not load reading list from \(url.absoluteString)"
            }
        }

        describe("decoding error") {
            var error: BookmarksLoadingError!
            var internalError: Error!

            beforeEach {
                internalError = NSError(domain: "domain", code: 1, userInfo: nil)
                error = .decodingError(internalError)
            }

            it("should be correctly localized") {
                expect(error.errorDescription) == "Bookmarks Loading Error"
                expect(error.failureReason) == "Could not decode bookmarks: \(internalError.localizedDescription)"
            }
        }
    }
}
