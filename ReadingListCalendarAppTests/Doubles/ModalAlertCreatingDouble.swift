import AppKit
@testable import ReadingListCalendarApp

class ModalAlertCreatingDouble: ModalAlertCreating {
    var alertDouble = ModalAlertDouble()
    private(set) var didCreateWithStyle: NSAlert.Style?
    private(set) var didCreateWithTitle: String?
    private(set) var didCreateWithMessage: String?

    func create(style: NSAlert.Style, title: String, message: String) -> ModalAlert {
        didCreateWithStyle = style
        didCreateWithTitle = title
        didCreateWithMessage = message
        return alertDouble
    }
}
