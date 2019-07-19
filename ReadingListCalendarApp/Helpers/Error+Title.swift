import Foundation

extension Error {
    var title: String {
        if let error = self as? LocalizedError, let description = error.errorDescription {
            return description
        }
        return "Error occured"
    }
}
