import XCTest
@testable import AppFit

final class AppFitTests: XCTestCase {
    let apiKey = "cHJvamVjdElkOmFwaUtleQ=="
    var appFit: AppFit {
        AppFit(configuration: AppFitConfiguration(apiKey: apiKey))
    }

    func testInitialization() throws {
        XCTAssertEqual(appFit.configuration.apiKey, apiKey)
    }
}
