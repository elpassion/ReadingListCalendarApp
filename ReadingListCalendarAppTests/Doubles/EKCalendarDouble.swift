import EventKit

class EKCalendarDouble: EKCalendar {
    init(id: String, title: String) {
        fakeId = id
        fakeTitle = title
        super.init()
    }

    override var calendarIdentifier: String {
        return fakeId
    }

    override var title: String {
        get { return fakeTitle }
        set { fakeTitle = newValue }
    }

    private let fakeId: String
    private var fakeTitle: String
}
