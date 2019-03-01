import AppKit
import EventKit
import RxCocoa
import RxSwift

class MainViewController: NSViewController {

    private(set) var fileOpener: FileOpening!
    private(set) var fileBookmarks: FileBookmarking!
    private(set) var fileReadability: FileReadablity!
    private(set) var calendarAuthorizer: CalendarAuthorizing!

    func setUp(fileOpener: FileOpening,
               fileBookmarks: FileBookmarking,
               fileReadability: FileReadablity,
               calendarAuthorizer: CalendarAuthorizing) {
        self.fileOpener = fileOpener
        self.fileBookmarks = fileBookmarks
        self.fileReadability = fileReadability
        self.calendarAuthorizer = calendarAuthorizer
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
        fileBookmarks.bookmarksFileURL()
            .asDriver(onErrorJustReturn: nil)
            .drive(bookmarksUrl)
            .disposed(by: disposeBag)

        bookmarksUrl.asDriver().skip(1)
            .flatMapLatest(fileBookmarks.setBookmarksFileURL >>> asDriverOnErrorComplete())
            .drive()
            .disposed(by: disposeBag)

        bookmarksUrl.asDriver()
            .map { $0?.absoluteString ?? "❌ Bookmarks.plist file is not set" }
            .drive(bookmarksPathField.rx.text)
            .disposed(by: disposeBag)

        bookmarksPathButton.rx.tap.asDriver()
            .flatMapFirst(fileOpener.rx_openBookmarksFile >>> asDriver(onErrorDriveWith: .empty()))
            .drive(bookmarksUrl)
            .disposed(by: disposeBag)

        bookmarksUrl.asDriver()
            .unwrap()
            .map(fileReadability.isReadableFile(atURL:))
            .map { $0 ? "✓ Bookmarks.plist file is set and readable" : "❌ Bookmarks.plist file is not readable" }
            .drive(bookmarksStatusField.rx.text)
            .disposed(by: disposeBag)

        bookmarksUrl.asDriver()
            .filter { $0 == nil }
            .map { _ in "" }
            .drive(bookmarksStatusField.rx.text)
            .disposed(by: disposeBag)

        calendarAuthorizer.eventsAuthorizationStatus()
            .map { $0.text }
            .asDriver(onErrorDriveWith: .empty())
            .drive(calendarAuthField.rx.text)
            .disposed(by: disposeBag)

        calendarAuthButton.rx.tap
            .flatMapFirst(calendarAuthorizer.requestAccessToEvents
                >>> andThen(calendarAuthorizer.eventsAuthorizationStatus()))
            .map { $0.text }
            .asDriver(onErrorDriveWith: .empty())
            .drive(calendarAuthField.rx.text)
            .disposed(by: disposeBag)
    }

}
