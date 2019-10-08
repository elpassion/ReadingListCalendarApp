import AppKit
@testable import ReadingListCalendarApp

class ModalAlertDouble: ModalAlert {
    private(set) var didRunModal = false

    func runModal() -> NSApplication.ModalResponse {
        didRunModal = true
        return .OK
    }
}
