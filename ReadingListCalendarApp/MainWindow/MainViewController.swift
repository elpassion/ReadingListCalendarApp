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
    private(set) var calendarsProvider: CalendarsProviding!
    private(set) var calendarIdStore: CalendarIdStoring!

    // swiftlint:disable:next function_parameter_count
    func setUp(fileOpenerFactory: FileOpenerCreating,
               fileBookmarks: FileBookmarking,
               fileReadability: FileReadablity,
               calendarAuthorizer: CalendarAuthorizing,
               alertFactory: ModalAlertCreating,
               calendarsProvider: CalendarsProviding,
               calendarIdStore: CalendarIdStoring) {
        self.fileOpenerFactory = fileOpenerFactory
        self.fileBookmarks = fileBookmarks
        self.fileReadability = fileReadability
        self.calendarAuthorizer = calendarAuthorizer
        self.alertFactory = alertFactory
        self.calendarsProvider = calendarsProvider
        self.calendarIdStore = calendarIdStore
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
    private let calendars = BehaviorRelay<[(id: String, title: String)]>(value: [])
    private let calendarId = BehaviorRelay<String?>(value: nil)
    private let disposeBag = DisposeBag()

    // swiftlint:disable:next function_body_length
    private func setUpBindings() {
        fileBookmarks.bookmarksFileURL()
            .asDriver(onErrorJustReturn: nil)
            .drive(bookmarksUrl)
            .disposed(by: disposeBag)

        bookmarksUrl.asObservable().skip(1)
            .flatMapLatest(fileBookmarks.setBookmarksFileURL(_:))
            .subscribe()
            .disposed(by: disposeBag)

        bookmarksUrl.asDriver()
            .map(filePath("Bookmarks.plist"))
            .drive(bookmarksPathField.rx.text)
            .disposed(by: disposeBag)

        bookmarksPathButton.rx.tap.asDriver()
            .flatMapFirst(openBookmarksFile(fileOpenerFactory))
            .drive(bookmarksUrl)
            .disposed(by: disposeBag)

        bookmarksUrl.asDriver()
            .map(fileReadabilityStatus("Bookmarks.plist", fileReadability))
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
            .do(onNext: presentAlertForCalendarAuth(alertFactory))
            .asDriver(onErrorDriveWith: .empty())
            .drive(calendarAuth)
            .disposed(by: disposeBag)

        calendarAuth.map { _ in () }
            .flatMapLatest(calendarsProvider.eventCalendars)
            .map { calendars in calendars.map { (id: $0.calendarIdentifier, title: $0.title) } }
            .asDriver(onErrorJustReturn: [])
            .drive(calendars)
            .disposed(by: disposeBag)

        calendarIdStore.calendarId()
            .asDriver(onErrorJustReturn: nil)
            .drive(calendarId)
            .disposed(by: disposeBag)

        calendarId.asDriver().skip(1)
            .flatMapLatest(calendarIdStore.setCalendarId >>> asDriverOnErrorComplete())
            .drive()
            .disposed(by: disposeBag)

        calendars.asDriver()
            .withLatestFrom(calendarId.asDriver()) { calendars, calendarId in
                (titles: calendars.map { $0.title }, selected: calendars.firstIndex(where: { $0.id == calendarId }))
            }
            .drive(calendarSelectionButton.rx.updateItems)
            .disposed(by: disposeBag)

        calendarSelectionButton.rx.selectedItemIndex.asDriver()
            .withLatestFrom(calendars.asDriver()) { selectedIndex, calendars in calendars[selectedIndex].id }
            .drive(calendarId)
            .disposed(by: disposeBag)

        Driver.combineLatest(
            bookmarksUrl.asDriver().map(isReadableFile(fileReadability)),
            calendarAuth.asDriver().map { $0 == .authorized },
            calendarId.asDriver().map { $0 != nil },
            resultSelector: { $0 && $1 && $2 }
        ).drive(synchronizeButton.rx.isEnabled).disposed(by: disposeBag)
    }

}
