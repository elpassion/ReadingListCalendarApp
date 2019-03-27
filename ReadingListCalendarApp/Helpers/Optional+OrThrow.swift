import Foundation

extension Optional {
    func or(_ error: Error) throws -> Wrapped {
        guard let wrapped = self else {
            throw error
        }
        return wrapped
    }
}
