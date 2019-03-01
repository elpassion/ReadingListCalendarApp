import Quick
import Nimble
import RxSwift
@testable import ReadingListCalendarApp

class UserDefaultsFileBookmarkingSpec: QuickSpec {
    override func spec() {
        describe("defaults") {
            var sut: UserDefaults!
            var key: String!

            beforeEach {
                sut = UserDefaults(suiteName: "tests")
                key = "test_file_bookmark_key"
                sut.removeObject(forKey: key)
            }

            it("should have no file url") {
                var actualURL: URL??
                _ = sut.fileURL(forKey: key).subscribe(onSuccess: { actualURL = $0 })
                expect(actualURL) == .some(nil)
            }

            context("set file url") {
                var url: URL!

                beforeEach {
                    url = try! NSURL(
                        resolvingAliasFileAt: URL(fileURLWithPath: "/tmp"),
                        options: [.withoutUI]
                    ) as URL
                    _ = sut.setFileURL(url, forKey: key).subscribe()
                }

                it("should have correct file url") {
                    var actualURL: URL??
                    _ = sut.fileURL(forKey: key).subscribe(onSuccess: { actualURL = $0 })
                    expect(actualURL) == url
                }
            }

            context("with corrupted data") {
                beforeEach {
                    let data = "TEST".data(using: .utf8)
                    sut.set(data, forKey: key)
                }

                it("should return error") {
                    var error: Error?
                    _ = sut.fileURL(forKey: key).subscribe(onError: { error = $0 })
                    expect(error).notTo(beNil())
                }
            }

            context("set invalid file url") {
                it("should return error") {
                    let url = URL(string: "http://www.elpassion.com/")!
                    var error: Error?
                    _ = sut.setFileURL(url, forKey: key).subscribe(onError: { error = $0 })
                    expect(error).notTo(beNil())
                }
            }
        }
    }
}
