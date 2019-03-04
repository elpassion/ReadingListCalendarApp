import Quick
import Nimble
import RxSwift
@testable import ReadingListCalendarApp

class UserDefaultsCalendarIdStoringSpec: QuickSpec {
    override func spec() {
        describe("defaults") {
            var sut: UserDefaults!
            var key: String!

            beforeEach {
                sut = UserDefaults(suiteName: "tests")
                key = "calendar_id"
                sut.removeObject(forKey: key)
            }

            it("should have no calendar id") {
                var actualId: String??
                _ = sut?.calendarId().subscribe(onSuccess: { actualId = $0 })
                expect(actualId) == .some(nil)
            }

            context("set calendar id") {
                var id: String!

                beforeEach {
                    id = "calendar-id-1"
                    _ = sut.setCalendarId(id).subscribe()
                }

                it("should have correct calendar id") {
                    var actualId: String??
                    _ = sut?.calendarId().subscribe(onSuccess: { actualId = $0 })
                    expect(actualId) == id
                }
            }
        }
    }
}
