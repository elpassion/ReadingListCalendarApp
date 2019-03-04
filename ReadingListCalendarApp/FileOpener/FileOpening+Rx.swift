import Foundation
import RxSwift

extension FileOpening {
    func rx_openFile() -> Maybe<URL> {
        return .create { observer in
            self.openFile { url in
                if let url = url {
                    observer(.success(url))
                } else {
                    observer(.completed)
                }
            }
            return Disposables.create()
        }
    }
}
