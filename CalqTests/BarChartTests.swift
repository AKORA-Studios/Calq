//
//  BarChartTests.swift
//  CalqTests
//
//  Created by Kiara on 05.09.23.
//

import XCTest
@testable import Calq

final class BarChartTests: XCTestCase {
    
    override class func setUp() {
        Util.setContext(TestCoreDataStack.sharedContext)
    }

    func testCreateSubjectBarData() {
        MockDataProvider.getSubjectWithTests()
        let data = BarChartEntry.getData().first!
        XCTAssertEqual(data.value, 11)
    }
    
    func testCreateHalfYearBarChartData() {
        MockDataProvider.getSubjectWithTests()
        let data = BarChartEntry.getDataHalfyear()
        let expected: [Double] = [0, 11, 0, 0]
        XCTAssertEqual(data.map { $0.value}, expected)
    }
}
