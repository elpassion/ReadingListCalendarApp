import Quick
import Nimble
import Combine
import EventKit
import Foundation
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
            }

            context("sync") {
                var bookmarksUrl: URL!
                var calendarId: String!
                var isSynchronizingEvents: [Bool]!
                var syncProgressEvents: [Double?]!
                var result: Result<[Void], Error>!
                var subscriptions: Set<AnyCancellable>!

                beforeEach {
                    bookmarksUrl = URL(fileURLWithPath: "")
                    calendarId = "CALENDAR-1234"
                    subscriptions = Set()

                    isSynchronizingEvents = []
                    sut.isSynchronizing()
                        .sink(receiveValue: { isSynchronizingEvents.append($0) })
                        .store(in: &subscriptions)

                    syncProgressEvents = []
                    sut.syncProgress()
                        .sink(receiveValue: { syncProgressEvents.append($0) })
                        .store(in: &subscriptions)

                    result = sut.sync(bookmarksUrl: bookmarksUrl, calendarId: calendarId)
                        .materialize()
                }

                afterEach {
                    isSynchronizingEvents = nil
                    syncProgressEvents = nil
                    result = nil
                    subscriptions = nil
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
                    expect(try? result.get()).to(haveCount(1))
                }
            }

            context("sync to invalid calendar") {
                var result: Result<[Void], Error>!

                beforeEach {
                    calendarProvider.mockedCalendar = nil
                    result = sut.sync(bookmarksUrl: URL(fileURLWithPath: ""), calendarId: "")
                        .materialize()
                }

                afterEach {
                    result = nil
                }

                it("should emit error") {
                    expect { try result.get() }.to(throwError(closure: { error in
                        if let error = error as? SyncError,
                        case SyncError.calendarNotFound = error {} else {
                            fail("invalid error emitted \(String(describing: error))")
                        }
                    }))
                }
            }
        }
    }
}
