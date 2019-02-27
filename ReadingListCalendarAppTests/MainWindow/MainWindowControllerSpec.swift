import Quick
import Nimble
@testable import ReadingListCalendarApp

class MainWindowControllerSpec: QuickSpec {
    override func spec() {
        context("create") {
            var sut: MainWindowController?

            beforeEach {
                let factory = MainWindowControllerFactory()
                sut = factory.create() as? MainWindowController
            }

            afterEach {
                sut = nil
            }

            it("should not be nil") {
                expect(sut).notTo(beNil())
            }

            it("should have main view controller") {
                expect(sut?.mainViewController).notTo(beNil())
            }
        }
    }
}
