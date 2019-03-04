import AppKit

extension ModalAlertCreating {
    func createCalendarAccessDenied() -> ModalAlert {
        return create(
            style: .warning,
            title: "Calendar Access Denied",
            message: "Open System Preferences, Security & Privacy and allow the app to access Calendar."
        )
    }
}
