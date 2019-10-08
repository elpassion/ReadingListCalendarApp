@testable import ReadingListCalendarApp

class AppTerminatingDouble: AppTerminating {
    private(set) var didTerminate = false
    private(set) var didTerminateWithSender: Any?

    func terminate(_ sender: Any?) {
        didTerminate = true
        didTerminateWithSender = sender
    }
}
