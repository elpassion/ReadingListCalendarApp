import Quick
import Nimble
import Combine
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
                let result = sut.fileURL(forKey: key).materialize()
                expect(try? result.get()) == [nil]
            }

            context("set file url") {
                var url: URL!
                var result: Result<[Void], Error>?

                beforeEach {
                    url = try! NSURL(
                        resolvingAliasFileAt: URL(fileURLWithPath: "/tmp"),
                        options: [.withoutUI]
                    ) as URL
                    result = sut.setFileURL(url, forKey: key).materialize()
                }

                it("should complete") {
                    expect(try? result!.get()).to(haveCount(1))
                }

                it("should have correct file url") {
                    let result = sut.fileURL(forKey: key).materialize()
                    expect(try? result.get()) == [url]
                }
            }

            context("with corrupted data") {
                beforeEach {
                    let data = "TEST".data(using: .utf8)
                    sut.set(data, forKey: key)
                }

                it("should return error") {
                    let result = sut.fileURL(forKey: key).materialize()
                    expect { try result.get() }.to(throwError())
                }
            }

            context("set invalid file url") {
                it("should return error") {
                    let url = URL(string: "http://www.elpassion.com/")!
                    let result = sut.setFileURL(url, forKey: key).materialize()
                    expect { try result.get() }.to(throwError())
                }
            }
        }
    }
}
