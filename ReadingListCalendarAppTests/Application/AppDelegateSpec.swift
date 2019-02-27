import Quick
import Nimble
@testable import ReadingListCalendarApp

class AppDelegateSpec: QuickSpec {
    override func spec() {
        context("create") {
            var sut: AppDelegate!

            beforeEach {
                sut = AppDelegate()
            }

            it("should have correct main window controller factory") {
                expect(sut.mainWindowControllerFactory).to(beAnInstanceOf(MainWindowControllerFactory.self))
            }

            it("should terminate after last window closed") {
                expect(sut.applicationShouldTerminateAfterLastWindowClosed(NSApplication.shared)) == true
            }

            context("when app did finish launching") {
                var mainWindowControllerFactory: MainWindowControllerCreatingDouble!

                beforeEach {
                    mainWindowControllerFactory = MainWindowControllerCreatingDouble()
                    sut.mainWindowControllerFactory = mainWindowControllerFactory
                    sut.applicationDidFinishLaunching(Notification(name: Notification.Name(rawValue: "")))
                }

                it("should create main window controller") {
                    expect(mainWindowControllerFactory.didCreate) == true
                }

                it("should show main window") {
                    let mainWindowController = mainWindowControllerFactory.mock
                    expect(mainWindowController.didShowWindow) == true
                    expect(mainWindowController.didShowWindowSender) === sut
                }
            }
        }
    }
}

private class MainWindowControllerCreatingDouble: MainWindowControllerCreating {
    private(set) var didCreate = false
    let mock = NSWindowControllerDouble()

    func create() -> NSWindowController {
        didCreate = true
        return mock
    }
}

private class NSWindowControllerDouble: NSWindowController {
    private(set) var didShowWindow = false
    private(set) var didShowWindowSender: Any?

    override func showWindow(_ sender: Any?) {
        didShowWindow = true
        didShowWindowSender = sender
    }
}
