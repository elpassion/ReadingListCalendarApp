import AppKit

class NSOpenPanelDouble: NSOpenPanel {
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
