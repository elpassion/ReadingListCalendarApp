import EventKit

func presentAlertForCalendarAuth(_ alertFactory: ModalAlertCreating) -> (EKAuthorizationStatus) -> Void {
    return { status in
        guard status != .authorized else { return }
        alertFactory.createCalendarAccessDenied().runModal()
    }
}
