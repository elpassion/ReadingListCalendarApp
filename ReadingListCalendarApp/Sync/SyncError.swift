import Foundation

enum SyncError: Error {
    case calendarNotFound
}

extension SyncError: LocalizedError {
    var errorDescription: String? {
        return "Sync Error"
    }

    var failureReason: String? {
        switch self {
        case .calendarNotFound:
            return "Calendar not found"
        }
    }
}
