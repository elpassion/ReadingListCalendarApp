import Quick
import Nimble
@testable import ReadingListCalendarApp

class OptionalOrThrowSpec: QuickSpec {
    override func spec() {
        describe("Optional with value") {
            var sut: String?

            beforeEach {
                sut = "test"
            }

            context("or throw") {
                var value: String?
                var thrownError: Error?

                beforeEach {
                    do {
                        value = try sut.or(ErrorDouble())
                    } catch {
                        thrownError = error
                    }
                }

                it("should retrun correct value") {
                    expect(value) == sut
                }

                it("should not throw") {
                    expect(thrownError).to(beNil())
                }
            }
        }

        describe("Optional without value") {
            var sut: String?

            beforeEach {
                sut = nil
            }

            context("or throw") {
                var value: String?
                var thrownError: Error?

                beforeEach {
                    do {
                        value = try sut.or(ErrorDouble())
                    } catch {
                        thrownError = error
                    }
                }

                it("should retrun nil value") {
                    expect(value).to(beNil())
                }

                it("should throw correct error") {
                    expect(thrownError).to(beAnInstanceOf(ErrorDouble.self))
                }
            }
        }
    }
}

private struct ErrorDouble: Error {}
