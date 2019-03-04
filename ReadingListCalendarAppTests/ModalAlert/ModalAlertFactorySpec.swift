import Quick
import Nimble
@testable import ReadingListCalendarApp

class ModalAlertFactorySpec: QuickSpec {
    override func spec() {
        describe("factory") {
            var sut: ModalAlertFactory!

            beforeEach {
                sut = ModalAlertFactory()
            }

            context("create") {
                var style: NSAlert.Style!
                var title: String!
                var message: String!
                var alert: ModalAlert!

                beforeEach {
                    style = .warning
                    title = "Alert Title"
                    message = "Alert Message"
                    alert = sut.create(style: .warning, title: title, message: message)
                }

                it("should be NSAlert") {
                    expect(alert).to(beAnInstanceOf(NSAlert.self))
                }

                it("should have correctly configured") {
                    expect((alert as? NSAlert)?.alertStyle) == style
                    expect((alert as? NSAlert)?.messageText) == title
                    expect((alert as? NSAlert)?.informativeText) == message
                }
            }
        }
    }
}
