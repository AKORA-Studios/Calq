//
//  ColorExtensionTest.swift
//  CalqTests
//
//  Created by Kiara on 20.11.24.
//

import XCTest
@testable import Calq

final class ColorExtensionTest: XCTestCase {
    
    func testgetPastelColorByIndex() {
        let targetColor = pastelColors.first
        XCTAssertEqual(targetColor, getPastelColorByIndex(0))
    }
    
    func test_toHexString() {
        let expected = "#ffffff"
        XCTAssertEqual(expected, UIColor.white.toHexString())
    }
}

final class DoubleExtensionTest: XCTestCase {
    
    func test_rounded() {
        let expected = 2.878
        XCTAssertEqual(2.9, expected.rounded(toPlaces: 1))
    }
    
    func test_rounded2() {
        let expected = -2.794
        XCTAssertEqual(-2.79, expected.rounded(toPlaces: 2))
    }
}
