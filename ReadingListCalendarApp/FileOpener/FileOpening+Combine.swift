import Combine
import Foundation

extension FileOpening {
    func openFile() -> AnyPublisher<URL, Never> {
        Future { complete in
            self.openFile { complete(.success($0)) }
        }.compactMap { $0 }.eraseToAnyPublisher()
    }
}
