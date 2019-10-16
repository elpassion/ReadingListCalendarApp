// swiftlint:disable file_length
import AppKit
import Combine
import EventKit

class MainViewController: NSViewController {

    private(set) var fileOpenerFactory: FileOpenerCreating!
    private(set) var fileBookmarks: FileBookmarking!
    private(set) var fileReadability: FileReadablity!
    private(set) var calendarAuthorizer: CalendarAuthorizing!
    private(set) var alertFactory: ModalAlertCreating!
    private(set) var calendarsProvider: CalendarsProviding!
    private(set) var calendarIdStore: CalendarIdStoring!
    private(set) var syncController: SyncControlling!

    // swiftlint:disable:next function_parameter_count
    func setUp(fileOpenerFactory: FileOpenerCreating,
               fileBookmarks: FileBookmarking,
               fileReadability: FileReadablity,
               calendarAuthorizer: CalendarAuthorizing,
               alertFactory: ModalAlertCreating,
               calendarsProvider: CalendarsProviding,
               calendarIdStore: CalendarIdStoring,
               syncController: SyncControlling) {
        self.fileOpenerFactory = fileOpenerFactory
        self.fileBookmarks = fileBookmarks
        self.fileReadability = fileReadability
        self.calendarAuthorizer = calendarAuthorizer
        self.alertFactory = alertFactory
        self.calendarsProvider = calendarsProvider
        self.calendarIdStore = calendarIdStore
        self.syncController = syncController
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

    private let bookmarksUrl = CurrentValueSubject<URL?, Never>(nil)
    private let calendarAuth = CurrentValueSubject<EKAuthorizationStatus?, Never>(nil)
    private let calendars = CurrentValueSubject<[(id: String, title: String)], Never>([])
    private let calendarId = CurrentValueSubject<String?, Never>(nil)
    private var subscriptions = Set<AnyCancellable>()

    // swiftlint:disable:next function_body_length
    private func setUpBindings() {
        fileBookmarks.bookmarksFileURL()
            .replaceError(with: nil)
            .sink(receiveValue: { [unowned self] in self.bookmarksUrl.send($0) })
            .store(in: &subscriptions)

        bookmarksUrl.dropFirst()
            .flatMap { [unowned self] in
                self.fileBookmarks.setBookmarksFileURL($0).replaceError(with: ())
            }
            .sink(receiveValue: { _ in })
            .store(in: &subscriptions)

        bookmarksUrl.map(filePath("Bookmarks.plist"))
            .sink(receiveValue: { [unowned self] in self.bookmarksPathField.stringValue = $0 })
            .store(in: &subscriptions)

        // TODO: Migrate to Combine API
//        bookmarksPathButton.rx.tap.asDriver()
//            .flatMapFirst(openBookmarksFile(fileOpenerFactory))
//            .drive(bookmarksUrl)
//            .disposed(by: disposeBag)

        bookmarksUrl
            .map(fileReadabilityStatus("Bookmarks.plist", fileReadability))
            .sink(receiveValue: { [unowned self] in self.bookmarksStatusField.stringValue = $0 })
            .store(in: &subscriptions)

        calendarAuthorizer.eventsAuthorizationStatus()
            .sink(receiveValue: { [unowned self] in self.calendarAuth.send($0) })
            .store(in: &subscriptions)

        calendarAuth.map { $0?.text ?? "" }
            .sink(receiveValue: { [unowned self] in self.calendarAuthField.stringValue = $0 })
            .store(in: &subscriptions)

        // TODO: Migrate to Combine API
//        calendarAuthButton.rx.tap
//            .flatMapFirst(calendarAuthorizer.requestAccessToEvents
//                >>> andThen(calendarAuthorizer.eventsAuthorizationStatus()))
//            .observeOn(MainScheduler.instance)
//            .do(onNext: presentAlertForCalendarAuth(alertFactory))
//            .asDriver(onErrorDriveWith: .empty())
//            .drive(calendarAuth)
//            .disposed(by: disposeBag)

        calendarAuth.map { _ in () }
            .flatMap(calendarsProvider.eventCalendars)
            .map { calendars in calendars.map { (id: $0.calendarIdentifier, title: $0.title) } }
            .sink(receiveValue: { [unowned self] in self.calendars.send($0) })
            .store(in: &subscriptions)

        calendarIdStore.calendarId()
            .replaceError(with: nil)
            .sink(receiveValue: { [unowned self] in self.calendarId.send($0) })
            .store(in: &subscriptions)

        // TODO: Migrate to Combine API
//        calendarId.asDriver().skip(1)
//            .flatMapLatest(calendarIdStore.setCalendarId >>> asDriverOnErrorComplete())
//            .drive()
//            .disposed(by: disposeBag)

        // TODO: Migrate to Combine API
//        calendars.asDriver()
//            .withLatestFrom(calendarId.asDriver()) { calendars, calendarId in
//                (titles: calendars.map { $0.title }, selected: calendars.firstIndex(where: { $0.id == calendarId }))
//            }
//            .drive(calendarSelectionButton.rx.updateItems)
//            .disposed(by: disposeBag)

        // TODO: Migrate to Combine API
//        calendarSelectionButton.rx.selectedItemIndex.asDriver()
//            .withLatestFrom(calendars.asDriver()) { selectedIndex, calendars in calendars[selectedIndex].id }
//            .drive(calendarId)
//            .disposed(by: disposeBag)

        // TODO: Migrate to Combine API
//        Driver.combineLatest(
//            bookmarksUrl.asDriver().map(isReadableFile(fileReadability)),
//            calendarAuth.asDriver().map { $0 == .authorized },
//            calendarId.asDriver().map { $0 != nil },
//            syncController.isSynchronizing().map { !$0 },
//            resultSelector: { $0 && $1 && $2 && $3 }
//        ).drive(synchronizeButton.rx.isEnabled).disposed(by: disposeBag)

        syncController.isSynchronizing().map { !$0 }
            .sink(receiveValue: { [unowned self] in
                self.bookmarksPathButton.isEnabled = $0
                self.calendarAuthButton.isEnabled = $0
                self.calendarSelectionButton.isEnabled = $0
            })
            .store(in: &subscriptions)

        syncController.syncProgress()
            .sink(receiveValue: { [unowned self] in self.progressIndicator.update(fractionCompleted: $0) })
            .store(in: &subscriptions)

        // TODO: Migrate to Combine API
//        synchronizeButton.rx.tap
//            .withLatestFrom(bookmarksUrl.asDriver())
//            .withLatestFrom(calendarId.asDriver()) { (bookmarksUrl: $0, calendarId: $1) }
//            .compactMap { $0 as? (bookmarksUrl: URL, calendarId: String) }
//            .flatMapFirst(syncController.sync(bookmarksUrl:calendarId:)
//                >>> asDriverOnErrorComplete(onError: { [alertFactory] in
//                    alertFactory?.createError($0).runModal()
//                }))
//            .subscribe()
//            .disposed(by: disposeBag)
    }

}
