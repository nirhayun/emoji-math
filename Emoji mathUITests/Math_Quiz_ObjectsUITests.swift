//
//  EmojiMathUITests.swift
//  Emoji mathUITests
//

import XCTest

final class EmojiMathUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testAppLaunches() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.exists)
    }
}
