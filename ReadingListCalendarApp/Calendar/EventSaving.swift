import EventKit

protocol EventSaving {
    func save(_ event: EKEvent, span: EKSpan, commit: Bool) throws
}
