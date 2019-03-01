import Foundation
import RxCocoa
import RxSwift

extension FileOpening {
    func rx_openBookmarksFile() -> Maybe<URL> {
        let title = "Open Bookmarks.plist file"
        let ext = "plist"
        let url = URL(fileURLWithPath: "/Users/\(NSUserName())/Library/Safari/Bookmarks.plist")
        return rx_openFile(title: title, ext: ext, url: url)
    }
}
