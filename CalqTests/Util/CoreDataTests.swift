//
//  CoreDataTests.swift
//  CalqTests
//
//  Created by Kiara on 13.03.24.
//

import XCTest
@testable import Calq

final class CoreDataTests: XCTestCase {
    override class func setUp() {
        Util.setContext(TestCoreDataStack.sharedContext)
    }
    
    func testDeleteData() {
        Util.deleteSettings()
        
        let count = Util.getAllSubjects().count
        XCTAssertEqual(count, 0)
        let types = Util.getTypes().count
        XCTAssertEqual(types, 2)
    }
    
    func testAverageString() {
        let average = Util.averageString(MockDataProvider.getSubjectWithTests())
        XCTAssertEqual(average, "-- 11 -- -- ")
    }
    
    func testAverageString_WithoutTests() {
        let average = Util.averageString(MockDataProvider.getSubjectWithoutTests())
        XCTAssertEqual(average, "-- -- -- -- ")
    }
}
