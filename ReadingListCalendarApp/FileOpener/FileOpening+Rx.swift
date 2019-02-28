import Foundation
import RxSwift

extension FileOpening {
    func rx_openFile(title: String, ext: String, url: URL?) -> Maybe<URL> {
        return Maybe.create { observer in
            self.openFile(title: title, ext: ext, url: url) { url in
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
