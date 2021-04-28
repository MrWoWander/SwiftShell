import XCTest
@testable import SwiftShell

final class SwiftShellTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let shell = SwiftShell(isDispatch: false)
        XCTAssertEqual(shell.shell("ls"), 0)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
