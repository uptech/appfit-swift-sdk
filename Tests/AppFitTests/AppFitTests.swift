import XCTest
@testable import AppFit

final class EventDigesterStub: Digestable {
    let digestExpectation: XCTestExpectation?
    let identifyExpectation: XCTestExpectation?

    init(digestExpectation: XCTestExpectation? = nil, identifyExpectation: XCTestExpectation? = nil) {
        self.digestExpectation = digestExpectation
        self.identifyExpectation = identifyExpectation
    }

    func digest(event: AppFitEvent) {
        self.digestExpectation?.fulfill()
    }

    func identify(userId: String?) {
        self.identifyExpectation?.fulfill()
    }
}

final class AppFitTests: XCTestCase {
    let apiKey = "cHJvamVjdElkOmFwaUtleQ=="

    func testInitialization() throws {
        let appFit = AppFit(configuration: AppFitConfiguration(apiKey: self.apiKey), digester: EventDigesterStub())
        XCTAssertEqual(appFit.configuration.apiKey, apiKey)
    }

    func testConvenienceInitialization() throws {
        let appFit = AppFit(apiKey: self.apiKey)
        XCTAssertEqual(appFit.configuration.apiKey, apiKey)
    }

    func testAppFitDigestedEventOnInitialization() async throws {
        let configuration = AppFitConfiguration(apiKey: self.apiKey)

        let expectation = expectation(description: "Event Digested")
        let digester = EventDigesterStub(digestExpectation: expectation)

        let _ = AppFit(configuration: configuration, digester: digester)

        await fulfillment(of: [expectation], timeout: 0.0)
    }

    func testAppFitUserIdentifiedOnInitialization() async throws {
        let configuration = AppFitConfiguration(apiKey: self.apiKey)

        let expectation = expectation(description: "User Identified")
        let digester = EventDigesterStub(identifyExpectation: expectation)

        let _ = AppFit(configuration: configuration, digester: digester)

        await fulfillment(of: [expectation], timeout: 0.0)
    }
}
