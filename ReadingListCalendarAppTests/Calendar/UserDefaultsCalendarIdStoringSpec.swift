import Quick
import Nimble
import Combine
import Foundation
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
                let result = sut.calendarId().materialize()
                expect(try? result.get()) == [nil]
            }

            context("set calendar id") {
                var id: String!
                var result: Result<[Void], Never>!

                beforeEach {
                    id = "calendar-id-1"
                    result = sut.setCalendarId(id).materialize()
                }

                it("should complete") {
                    expect(try? result.get()).to(haveCount(1))
                }

                it("should have correct calendar id") {
                    let result = sut.calendarId().materialize()
                    expect(try? result.get()) == [id]
                }
            }
        }
    }
}
