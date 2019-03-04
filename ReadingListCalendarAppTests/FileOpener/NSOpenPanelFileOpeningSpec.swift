import Quick
import Nimble
@testable import ReadingListCalendarApp

class NSOpenPanelFileOpeningSpec: QuickSpec {
    override func spec() {
        describe("panel") {
            var sut: NSOpenPanelDouble!

            beforeEach {
                sut = NSOpenPanelDouble()
            }

            context("open file") {
                var didOpenUrl: URL?

                beforeEach {
                    sut.openFile { didOpenUrl = $0 }
                }

                afterEach {
                    didOpenUrl = nil
                }

                it("should begin") {
                    expect(sut.didBegin) == true
                }

                context("when file is opened with url") {
                    var url: URL!

                    beforeEach {
                        url = URL(fileURLWithPath: "file_url")
                        sut.urlFake = url
                        sut.beginCompletionHandler?(.OK)
                    }

                    it("should open url") {
                        expect(didOpenUrl) == url
                    }
                }

                context("when file is opened without url") {
                    beforeEach {
                        sut.urlFake = nil
                        sut.beginCompletionHandler?(.OK)
                    }

                    it("should not open url") {
                        expect(didOpenUrl).to(beNil())
                    }
                }

                context("when cancelled without url") {
                    beforeEach {
                        sut.urlFake = nil
                        sut.beginCompletionHandler?(.cancel)
                    }

                    it("should not open url") {
                        expect(didOpenUrl).to(beNil())
                    }
                }

                context("when cancelled with url") {
                    beforeEach {
                        sut.urlFake = URL(fileURLWithPath: "cancel_url")
                        sut.beginCompletionHandler?(.cancel)
                    }

                    it("should not open url") {
                        expect(didOpenUrl).to(beNil())
                    }
                }
            }
        }
    }
}

private class NSOpenPanelDouble: NSOpenPanel {
    private(set) var didBegin = false
    private(set) var beginCompletionHandler: ((NSApplication.ModalResponse) -> Void)?
    var urlFake: URL?
    var directoryUrlFake: URL?

    override var directoryURL: URL? {
        get { return directoryUrlFake }
        set { directoryUrlFake = newValue }
    }

    override var url: URL? {
        return urlFake
    }

    override func begin(completionHandler handler: @escaping (NSApplication.ModalResponse) -> Void) {
        didBegin = true
        beginCompletionHandler = handler
    }
}
