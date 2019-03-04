import AppKit
import EventKit
import RxCocoa
import RxSwift

class MainViewController: NSViewController {

    private(set) var fileOpenerFactory: FileOpenerCreating!
    private(set) var fileBookmarks: FileBookmarking!
    private(set) var fileReadability: FileReadablity!
    private(set) var calendarAuthorizer: CalendarAuthorizing!
    private(set) var alertFactory: ModalAlertCreating!

    func setUp(fileOpenerFactory: FileOpenerCreating,
               fileBookmarks: FileBookmarking,
               fileReadability: FileReadablity,
               calendarAuthorizer: CalendarAuthorizing,
               alertFactory: ModalAlertCreating) {
        self.fileOpenerFactory = fileOpenerFactory
        self.fileBookmarks = fileBookmarks
        self.fileReadability = fileReadability
        self.calendarAuthorizer = calendarAuthorizer
        self.alertFactory = alertFactory
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
    private let calendarAuth = BehaviorRelay<EKAuthorizationStatus?>(value: nil)
    private let disposeBag = DisposeBag()

    // swiftlint:disable:next function_body_length
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
            .map(bookmarksPathFromUrl)
            .drive(bookmarksPathField.rx.text)
            .disposed(by: disposeBag)

        bookmarksPathButton.rx.tap.asDriver()
            .flatMapFirst(openBookmarksFile >>> asDriver(onErrorDriveWith: .empty()))
            .drive(bookmarksUrl)
            .disposed(by: disposeBag)

        bookmarksUrl.asDriver()
            .unwrap()
            .map(fileReadability.isReadableFile(atURL:))
            .map(bookmarksStatusForReadability)
            .drive(bookmarksStatusField.rx.text)
            .disposed(by: disposeBag)

        bookmarksUrl.asDriver()
            .filter { $0 == nil }
            .map { _ in "" }
            .drive(bookmarksStatusField.rx.text)
            .disposed(by: disposeBag)

        calendarAuthorizer.eventsAuthorizationStatus()
            .asDriver(onErrorDriveWith: .empty())
            .drive(calendarAuth)
            .disposed(by: disposeBag)

        calendarAuth.asDriver()
            .map { $0?.text }
            .drive(calendarAuthField.rx.text)
            .disposed(by: disposeBag)

        calendarAuthButton.rx.tap
            .flatMapFirst(calendarAuthorizer.requestAccessToEvents
                >>> andThen(calendarAuthorizer.eventsAuthorizationStatus()))
            .observeOn(MainScheduler.instance)
            .do(onNext: presentAlertForCalendarAuth)
            .asDriver(onErrorDriveWith: .empty())
            .drive(calendarAuth)
            .disposed(by: disposeBag)
    }

    private var openBookmarksFile: () -> Maybe<URL> {
        return { [unowned self] in
            let opener = self.fileOpenerFactory.createBookmarksFileOpener()
            return opener.rx_openFile()
        }
    }

    private var bookmarksPathFromUrl: (URL?) -> String {
        return { $0?.absoluteString ?? "❌ Bookmarks.plist file is not set" }
    }

    private var bookmarksStatusForReadability: (Bool) -> String {
        return { $0 ? "✓ Bookmarks.plist file is set and readable" : "❌ Bookmarks.plist file is not readable" }
    }

    private var presentAlertForCalendarAuth: (EKAuthorizationStatus) -> Void {
        return { [unowned self] status in
            guard status != .authorized else { return }
            let alert = self.alertFactory.createCalendarAccessDenied()
            alert.runModal()
        }
    }

}
