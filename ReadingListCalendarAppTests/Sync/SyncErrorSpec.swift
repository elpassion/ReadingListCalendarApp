import Quick
import Nimble
@testable import ReadingListCalendarApp

class SyncErrorSpec: QuickSpec {
    override func spec() {
        describe("calendar not found") {
            var error: SyncError!

            beforeEach {
                error = .calendarNotFound
            }

            it("should be correctly localized") {
                expect(error.errorDescription) == "Sync Error"
                expect(error.failureReason) == "Calendar not found"
            }
        }
    }
}
