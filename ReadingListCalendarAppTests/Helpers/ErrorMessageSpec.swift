import Quick
import Nimble
import Foundation
@testable import ReadingListCalendarApp

class ErrorMessageSpec: QuickSpec {
    override func spec() {
        describe("localized error with failure reason") {
            var error: Error!
            var failureReason: String!

            beforeEach {
                failureReason = "Failure Reason"
                struct ErrorDouble: LocalizedError {
                    var failureReason: String?
                }
                error = ErrorDouble(failureReason: failureReason)
            }

            it("should have correct message") {
                expect(error.message) == failureReason
            }
        }

        describe("localized error without failure reason") {
            var error: Error!

            beforeEach {
                struct ErrorDouble: LocalizedError {}
                error = ErrorDouble()
            }

            it("should have correct message") {
                expect(error.message) == ""
            }
        }

        describe("non localized error") {
            var error: Error!

            beforeEach {
                struct ErrorDouble: Error {}
                error = ErrorDouble()
            }

            it("should have correct message") {
                expect(error.message) == error.localizedDescription
            }
        }
    }
}
