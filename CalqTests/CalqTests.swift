//
//  CalqTests.swift
//  CalqTests
//
//  Created by Kiara on 07.05.23.
//

import XCTest

@testable import Calq

final class ColorExtension: XCTestCase {
    
    //TODO:
    /*func testCheckString() {
        let strChecked = Util.checkString("33 $%&&/%/%/%(!@-*1")
        XCTAssertEqual(strChecked, false)
    }*/


     func testAverage()  {
         let average = Util.average([1,2,3])
         XCTAssertEqual(average, 2.0)
    }
    
    /*func testAverageRange()  {
        let average = Util.average([1.0,2.0,3.0], from: 1, to: 2)
        XCTAssertEqual(average, 3.0)
   }*/

}
