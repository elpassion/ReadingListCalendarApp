import Quick
import Nimble
import RxSwift
import RxCocoa
import EventKit
@testable import ReadingListCalendarApp

class SyncControllerSpec: QuickSpec {
    override func spec() {
        describe("instantiate") {
            var sut: SyncController!
            var bookmarksLoader: BookmarskLoadingDouble!
            var calendarProvider: CalendarProvidingDouble!
            var eventProvider: ReadingListItemEventProvidingDouble!
            var eventCreator: ReadingListItemEventCreatingDouble!
            var eventSaver: EventSavingDouble!

            beforeEach {
                sut = SyncController()
                bookmarksLoader = BookmarskLoadingDouble()
                sut.bookmarksLoader = bookmarksLoader
                calendarProvider = CalendarProvidingDouble()
                sut.calendarProvider = calendarProvider
                eventProvider = ReadingListItemEventProvidingDouble()
                sut.eventProvider = eventProvider
                eventCreator = ReadingListItemEventCreatingDouble()
                sut.eventCreator = eventCreator
                eventSaver = EventSavingDouble()
                sut.eventSaver = eventSaver
                sut.syncScheduler = MainScheduler.instance
            }

            context("sync") {
                var bookmarksUrl: URL!
                var calendarId: String!
                var isSynchronizingEvents: [Bool]!
                var syncProgressEvents: [Double?]!
                var didComplete: Bool!

                beforeEach {
                    bookmarksUrl = URL(fileURLWithPath: "")
                    calendarId = "CALENDAR-1234"

                    isSynchronizingEvents = []
                    _ = sut.isSynchronizing().asObservable()
                        .subscribe(onNext: { isSynchronizingEvents.append($0) })

                    syncProgressEvents = []
                    _ = sut.syncProgress().asObservable()
                        .subscribe(onNext: { syncProgressEvents.append($0) })

                    didComplete = false
                    _ = sut.sync(bookmarksUrl: bookmarksUrl, calendarId: calendarId)
                        .subscribe(onCompleted: { didComplete = true })
                }

                afterEach {
                    isSynchronizingEvents = nil
                    syncProgressEvents = nil
                    didComplete = nil
                }

                it("should load bookmarks from url") {
                    expect(bookmarksLoader.didLoadFromURL) == bookmarksUrl
                }

                it("should load calendar with identifier") {
                    expect(calendarProvider.didLoadCalendarWithIdentifier) == calendarId
                }

                it("should create events") {
                    expect(eventCreator.didCreateEventsForItems)
                        == (try! Bookmark.fake().readingListItems())
                    expect(eventCreator.didCreateEventsInCalendars)
                        == Array(repeating: calendarProvider.mockedCalendar, count: 2)
                }

                it("should save events") {
                    expect(eventSaver.savedEvents.map { $0.event })
                        == eventCreator.createdEvents
                    expect(eventSaver.savedEvents.map { $0.span })
                        == Array(repeating: .thisEvent, count: 2)
                    expect(eventSaver.savedEvents.map { $0.commit })
                        == Array(repeating: true, count: 2)
                }

                it("should emit correct isSynchronizing events") {
                    expect(isSynchronizingEvents) == [false, true, false]
                }

                it("should emit correct syncProgress events") {
                    expect(syncProgressEvents) == [nil, 0, 0.5, 1, nil]
                }

                it("should complete") {
                    expect(didComplete) == true
                }
            }

            context("sync to invalid calendar") {
                var error: Error?

                beforeEach {
                    calendarProvider.mockedCalendar = nil
                    _ = sut.sync(bookmarksUrl: URL(fileURLWithPath: ""), calendarId: "")
                        .subscribe(onError: { error = $0 })
                }

                afterEach {
                    error = nil
                }

                it("should emit error") {
                    expect(error).notTo(beNil())
                    if let error = error as? SyncError,
                    case SyncError.calendarNotFound = error {} else {
                        fail("invalid error emitted \(String(describing: error))")
                    }
                }
            }
        }
    }
}
