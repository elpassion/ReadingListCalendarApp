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
    private var openBookmarksFileSubscription: AnyCancellable?

    @IBAction private func bookmarksPathButtonAction(_ sender: Any) {
        openBookmarksFileSubscription?.cancel()
        openBookmarksFileSubscription = openBookmarksFile(fileOpenerFactory)()
            .map { $0 as URL? }
            .assign(to: \.value, on: bookmarksUrl)
    }

    @IBAction func calendarAuthButtonAction(_ sender: Any) {
        // TODO: Migrate to Combine API
//        calendarAuthButton.rx.tap
//            .flatMapFirst(calendarAuthorizer.requestAccessToEvents
//                >>> andThen(calendarAuthorizer.eventsAuthorizationStatus()))
//            .observeOn(MainScheduler.instance)
//            .do(onNext: presentAlertForCalendarAuth(alertFactory))
//            .asDriver(onErrorDriveWith: .empty())
//            .drive(calendarAuth)
//            .disposed(by: disposeBag)
    }

    @IBAction func calendarSelectionButtonAction(_ sender: Any) {
        // TODO: Migrate to Combine API
//        calendarSelectionButton.rx.selectedItemIndex.asDriver()
//            .withLatestFrom(calendars.asDriver()) { selectedIndex, calendars in calendars[selectedIndex].id }
//            .drive(calendarId)
//            .disposed(by: disposeBag)
    }

    @IBAction private func synchronizeButtonAction(_ sender: Any) {
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

    // swiftlint:disable:next function_body_length
    private func setUpBindings() {
        fileBookmarks.bookmarksFileURL()
            .replaceError(with: nil)
            .assign(to: \.value, on: bookmarksUrl)
            .store(in: &subscriptions)

        bookmarksUrl.dropFirst()
            .flatMap { [unowned self] in
                self.fileBookmarks.setBookmarksFileURL($0).replaceError(with: ())
            }.sink { _ in }
            .store(in: &subscriptions)

        bookmarksUrl.map(filePath("Bookmarks.plist"))
            .assign(to: \.stringValue, on: bookmarksPathField)
            .store(in: &subscriptions)

        bookmarksUrl.map(fileReadabilityStatus("Bookmarks.plist", fileReadability))
            .assign(to: \.stringValue, on: bookmarksStatusField)
            .store(in: &subscriptions)

        calendarAuthorizer.eventsAuthorizationStatus()
            .map { $0 as EKAuthorizationStatus? }
            .assign(to: \.value, on: calendarAuth)
            .store(in: &subscriptions)

        calendarAuth.compactMap { $0?.text }
            .assign(to: \.stringValue, on: calendarAuthField)
            .store(in: &subscriptions)

        calendarAuth.map { _ in () }
            .flatMap(calendarsProvider.eventCalendars)
            .map { calendars in calendars.map { (id: $0.calendarIdentifier, title: $0.title) } }
            .assign(to: \.value, on: calendars)
            .store(in: &subscriptions)

        calendarIdStore.calendarId()
            .replaceError(with: nil)
            .assign(to: \.value, on: calendarId)
            .store(in: &subscriptions)

        // TODO: Migrate to Combine API
//        calendarId.asDriver().skip(1)
//            .flatMapLatest(calendarIdStore.setCalendarId >>> asDriverOnErrorComplete())
//            .drive()
//            .disposed(by: disposeBag)

        calendars.flatMap { [unowned self] calendars in
            self.calendarId.map { calendarId in
                (titles: calendars.map { $0.title }, selected: calendars.firstIndex(where: { $0.id == calendarId }))
            }.eraseToAnyPublisher()
        }.sink { [unowned self] in self.calendarSelectionButton.updateItems($0) }
            .store(in: &subscriptions)

        Publishers.CombineLatest4(
            bookmarksUrl.map(isReadableFile(fileReadability)).eraseToAnyPublisher(),
            calendarAuth.map { $0 == .authorized }.eraseToAnyPublisher(),
            calendarId.map { $0 != nil }.eraseToAnyPublisher(),
            syncController.isSynchronizing().map { !$0 }.eraseToAnyPublisher()
        ).map { $0 && $1 && $2 && $3 }
            .assign(to: \.isEnabled, on: synchronizeButton)
            .store(in: &subscriptions)

        syncController.isSynchronizing().map { !$0 }
            .sink { [unowned self] in
                self.bookmarksPathButton.isEnabled = $0
                self.calendarAuthButton.isEnabled = $0
                self.calendarSelectionButton.isEnabled = $0
            }
            .store(in: &subscriptions)

        syncController.syncProgress()
            .sink { [unowned self] in self.progressIndicator.update(fractionCompleted: $0) }
            .store(in: &subscriptions)
    }

}
