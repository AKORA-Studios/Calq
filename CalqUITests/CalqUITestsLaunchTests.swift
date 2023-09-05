//
//  CalqUITestsLaunchTests.swift
//  CalqUITests
//
//  Created by Kiara on 05.09.23.
//

import XCTest

import XCTest
//@testable import Calq

final class CalqUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        //print(Ident.FirstLaunchScreen.loadDemoButton)
   //     app.buttons[Ident.FirstLaunchScreen.loadDemoButton].click()
     //   app.buttons["Ident.Main.tabBar"].click()
        let e: String = Ident.Main.tabBar_Overview
        app.tabBars.buttons[e].tap()
        // if whatsnew
        
        // if first laucnh
        
        // otherwise
    }
}
