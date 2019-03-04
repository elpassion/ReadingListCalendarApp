import AppKit

protocol ModalAlertCreating {
    func create(style: NSAlert.Style, title: String, message: String) -> ModalAlert
}
