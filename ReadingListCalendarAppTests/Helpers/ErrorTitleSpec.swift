import Quick
import Nimble
import Foundation
@testable import ReadingListCalendarApp

class ErrorTitleSpec: QuickSpec {
    override func spec() {
        describe("localized error with description") {
            var error: Error!
            var errorDescription: String!

            beforeEach {
                errorDescription = "Error Description"
                struct ErrorDouble: LocalizedError {
                    var errorDescription: String?
                }
                error = ErrorDouble(errorDescription: errorDescription)
            }

            it("should have correct title") {
                expect(error.title) == errorDescription
            }
        }

        describe("non localized error") {
            var error: Error!

            beforeEach {
                struct ErrorDouble: Error {}
                error = ErrorDouble()
            }

            it("should have correct title") {
                expect(error.title) == "Error occured"
            }
        }
    }
}
