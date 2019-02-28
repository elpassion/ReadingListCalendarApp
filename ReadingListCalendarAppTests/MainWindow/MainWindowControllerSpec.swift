import Quick
import Nimble
@testable import ReadingListCalendarApp

class MainWindowControllerSpec: QuickSpec {
    override func spec() {
        describe("factory") {
            var factory: MainWindowControllerFactory!

            beforeEach {
                factory = MainWindowControllerFactory()
            }

            it("should have correct file opener") {
                expect(factory.fileOpener).to(beAnInstanceOf(type(of: NSOpenPanel())))
            }

            context("create") {
                var sut: MainWindowController?
                var fileOpener: FileOpeningDouble!

                beforeEach {
                    fileOpener = FileOpeningDouble()
                    factory.fileOpener = fileOpener
                    sut = factory.create() as? MainWindowController
                }

                afterEach {
                    sut = nil
                }

                it("should not be nil") {
                    expect(sut).notTo(beNil())
                }

                describe("main view controller") {
                    var mainViewController: MainViewController?

                    beforeEach {
                        mainViewController = sut?.mainViewController
                    }

                    it("should not be nil") {
                        expect(mainViewController).notTo(beNil())
                    }

                    it("should have correct file opener") {
                        expect(mainViewController?.fileOpener) === fileOpener
                    }
                }
            }
        }
    }
}

private class FileOpeningDouble: FileOpening {
    func openFile(title: String, ext: String, url: URL?, completion: @escaping (URL?) -> Void) {}
}
