//
//  CalqTests.swift
//  CalqTests
//
//  Created by Kiara on 23.05.23.
//

import XCTest
@testable import Calq

final class CalqTests: XCTestCase {
    
    override class func setUp() {
        Util.setContext(TestCoreDataStack.sharedContext)
    }
    
    func getExampleSub() -> UserSubject { // load demoData before!
        return Util.getAllSubjects().first(where: {$0.name == "Kunst"})!
    }
    
    func testCheckString_InvalidInput() {
        let strChecked = Util.isStringInputInvalid("33 $%&&/%/%/%(!@-*1")
        XCTAssertEqual(strChecked, true)
    }
    
    func testCheckString_ValidInput() {
        let strChecked = Util.isStringInputInvalid("abc")
        XCTAssertEqual(strChecked, false)
    }
    
    func testCheckString_EmptyString() {
        XCTAssertEqual(Util.isStringInputInvalid(""), true)
    }
    
    func testAverage() {
        let values: [Int] = [1, 2, 3]
        let average = Util.average(values)
        XCTAssertEqual(average, 2.0)
    }
    
    func testAverage_EmptyArr() {
        let values: [Int] = []
        let average = Util.average(values)
        XCTAssertEqual(average, 0.0)
    }
    
    func testAverage_WithoutTests() {
        let average = Util.testAverage([])
        XCTAssertEqual(average, 0)
    }
    
    func testGradeString() {
        XCTAssertEqual(Util.grade(number: 11), 2.0)
    }
    
    func testGradeStringNegative() {
        XCTAssertEqual(Util.grade(number: -11), 2.0)
    }
    
    func testCheckinactiveYears() {
        XCTAssertEqual(Util.checkinactiveYears(["1", "2"], 1), false)
    }
    
    func testSetPrimaryType() {
        Util.setPrimaryType(1)
        XCTAssertEqual(  UserDefaults.standard.integer(forKey: UD_primaryType), 1)
    }
    
    // MARK: CoreData
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
    
    // MARK: Inactive Year funcs
    func testDeactivateHalfyear() {
        JSON.loadDemoData()
        
        let before = Util.getinactiveYears(getExampleSub())
        XCTAssertEqual(before.count, 0)
        
        let subject = Util.addYear(getExampleSub(), 3)
        let after = Util.getinactiveYears(subject)
        
        XCTAssertEqual(after.count, 1)
    }
    
    func testAddInactiveHalfyearTwice() {
        JSON.loadDemoData()
        
        Util.addYear(getExampleSub(), 3)
        let firstResult = Util.getinactiveYears(getExampleSub())
        XCTAssertEqual(firstResult.count, 1)
        
        Util.addYear(getExampleSub(), 3)
        
        let secondResult = Util.getinactiveYears(getExampleSub())
        XCTAssertEqual(secondResult.count, 1)
    }
    
    func testRemoveNotAddedInactiveHalfyear() {
        JSON.loadDemoData()
        
        Util.addYear(getExampleSub(), 3)
        let firstResult = Util.getinactiveYears(getExampleSub())
        XCTAssertEqual(firstResult.count, 1)

        Util.removeYear(getExampleSub(), 4)
        
        let secondResult = Util.getinactiveYears(getExampleSub())
        XCTAssertEqual(secondResult.count, 1)
    }
    
    func testLastActiveYear() {
        JSON.loadDemoData()
        let lastYear =  Util.lastActiveYear(getExampleSub())
        XCTAssertEqual(lastYear, 4)
    }
    
    // MARK: GradeTypes
    func testGetDefaultTypes() {
        let types = Util.getTypes()
        XCTAssertEqual(types.count, 2)
        XCTAssertEqual(types.filter {$0.name == "Test" || $0.name == "Klausur"}.count, 2)
    }
    
    func testEditTypes() {
        // add type
        Util.addType(name: "someName", weigth: 0)
        let type = Util.getTypes().filter {$0.name == "someName"}[0]
        // remove random type
        Util.deleteType(type: type.id)
        XCTAssertTrue(Util.getTypes().filter {$0.name == "someName"}.isEmpty)
    }
}
