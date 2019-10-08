import EventKit
@testable import ReadingListCalendarApp

class CalendarAuthorizingDouble: CalendarAuthorizing {
    static var authorizationStatusMock = EKAuthorizationStatus.notDetermined
    private(set) var didRequestAccessToEntityType: EKEntityType?
    private(set) var requestAccessCompletion: EKEventStoreRequestAccessCompletionHandler?

    static func authorizationStatus(for entityType: EKEntityType) -> EKAuthorizationStatus {
        return authorizationStatusMock
    }

    func requestAccess(to entityType: EKEntityType, completion: @escaping EKEventStoreRequestAccessCompletionHandler) {
        didRequestAccessToEntityType = entityType
        requestAccessCompletion = completion
    }
}
