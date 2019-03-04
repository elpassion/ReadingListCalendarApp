import AppKit

struct ModalAlertFactory: ModalAlertCreating {
    func create(style: NSAlert.Style, title: String, message: String) -> ModalAlert {
        let alert = NSAlert()
        alert.alertStyle = style
        alert.messageText = title
        alert.informativeText = message
        return alert
    }
}
