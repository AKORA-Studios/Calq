//
//  LineChartTests.swift
//  CalqTests
//
//  Created by Kiara on 05.09.23.
//

import XCTest
@testable import Calq

final class LineChartTests: XCTestCase {

    override class func setUp() {
        Util.setContext(TestCoreDataStack.sharedContext)
    }
    
    func testLineChartData() {
        MockDataProvider.getSubjectWithTests()
        let data = LineChartEntry.getData().first!.first!
        XCTAssertEqual(data.value, 11/15)
    }
}
