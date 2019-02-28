import AppKit
import RxCocoa
import RxSwift

class MainViewController: NSViewController {

    private(set) var fileOpener: FileOpening!

    func setUp(fileOpener: FileOpening) {
        self.fileOpener = fileOpener
        setUpBindings()
    }

    // MARK: View

    @IBOutlet private weak var bookmarksPathField: NSTextField!
    @IBOutlet private weak var bookmarksPathButton: NSButton!
    @IBOutlet private weak var bookmarksStatusField: NSTextField!
    @IBOutlet private weak var calendarAuthField: NSTextField!
    @IBOutlet private weak var calendarAuthButton: NSButton!
    @IBOutlet private weak var calendarSelectionField: NSTextField!
    @IBOutlet private weak var calendarSelectionButton: NSPopUpButton!
    @IBOutlet private weak var statusField: NSTextField!
    @IBOutlet private weak var synchronizeButton: NSButton!
    @IBOutlet private weak var progressIndicator: NSProgressIndicator!

    // MARK: Priavte

    private let bookmarksUrl = BehaviorRelay<URL?>(value: nil)
    private let disposeBag = DisposeBag()

    private func setUpBindings() {
        bookmarksUrl.asDriver()
            .map { $0?.absoluteString }
            .drive(bookmarksPathField.rx.text)
            .disposed(by: disposeBag)

        bookmarksPathButton.rx.tap.asDriver()
            .flatMapFirst { [unowned self] in
                self.openBookmarksFile().asDriver(onErrorDriveWith: .empty())
            }
            .drive(bookmarksUrl)
            .disposed(by: disposeBag)
    }

    private func openBookmarksFile() -> Maybe<URL> {
        let title = "Open Bookmarks.plist file"
        let ext = "plist"
        let url = URL(fileURLWithPath: "/Users/\(NSUserName())/Library/Safari/Bookmarks.plist")
        return fileOpener.rx_openFile(title: title, ext: ext, url: url)
    }

}
