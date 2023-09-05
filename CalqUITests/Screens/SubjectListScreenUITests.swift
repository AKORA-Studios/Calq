//
//  SubjectListScreenUITests.swift
//  CalqUITests
//
//  Created by Kiara on 05.09.23.
//

import XCTest

final class CalqUITests: XCTestCase {
    let app = XCUIApplication()
    
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testShowGradeTable() throws {
        app.launch()

        app.tabBars.buttons[Ident.SubjectListScreen.showGradesTableButton].tap()
        
        XCTAssertTrue(app.tables[Ident.GradeTableOverviewScreen.gradeList].exists)
    }
    
    func testNavigateToSubjectDetail() {
        
    }
}

