import XCTest
@testable import AppFit

final class AppFitTests: XCTestCase {
    let apiKey = "cHJvamVjdElkOmFwaUtleQ=="

    func testInitialization() throws {
        let appFit = AppFit(configuration: AppFitConfiguration(apiKey: self.apiKey))
        XCTAssertEqual(appFit.configuration.apiKey, apiKey)
    }

    func testConvenienceInitialization() throws {
        let appFit = AppFit(apiKey: self.apiKey)
        XCTAssertEqual(appFit.configuration.apiKey, apiKey)
    }
}
