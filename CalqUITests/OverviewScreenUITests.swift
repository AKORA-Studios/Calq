//
//  OverviewScreenUITests.swift
//  CalqUITests
//
//  Created by Kiara on 05.09.23.
//

import XCTest

final class OverviewScreenUITests: XCTestCase {
    let app = XCUIApplication()
    
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testInfoAverageChart() {
        app.launch()
    }
    
    func testInfoExamChart() {
        app.launch()
    }
}
