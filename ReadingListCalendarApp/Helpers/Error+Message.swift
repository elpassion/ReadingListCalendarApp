import Foundation

extension Error {
    var message: String {
        guard let error = self as? LocalizedError else {
            return localizedDescription
        }
        guard let reason = error.failureReason else {
            return ""
        }
        return reason
    }
}
