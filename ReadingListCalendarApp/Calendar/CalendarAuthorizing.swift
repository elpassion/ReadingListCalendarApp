import EventKit

protocol CalendarAuthorizing {
    static func authorizationStatus(for entityType: EKEntityType) -> EKAuthorizationStatus
    func requestAccess(to entityType: EKEntityType, completion: @escaping EKEventStoreRequestAccessCompletionHandler)
}
