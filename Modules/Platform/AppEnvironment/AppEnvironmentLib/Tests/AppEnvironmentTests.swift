import XCTest

@testable import AppEnvironment

class AppEnvironmentTests: XCTestCase {

    func test_isXCTest() {
        XCTAssertEqual(AppEnvironment().isXCTest, true)
    }

}
