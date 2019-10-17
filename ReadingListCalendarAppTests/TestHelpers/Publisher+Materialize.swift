import Combine
import Foundation

extension Publisher {
    func materialize() -> Result<[Output], Failure> {
        var values = [Output]()
        var result: Result<[Output], Failure>!
        let semaphore = DispatchSemaphore(value: 0)
        let subscription = sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                result = .success(values)
            case .failure(let error):
                result = .failure(error)
            }
            semaphore.signal()
        }, receiveValue: { value in
            values.append(value)
        })
        semaphore.wait()
        subscription.cancel()

        return result
    }
}
