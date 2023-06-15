//
//  CalqTests.swift
//  CalqTests
//
//  Created by Kiara on 23.05.23.
//

import XCTest
@testable import Calq

final class CalqTests: XCTestCase {
    
    //TODO:
    /*func testCheckString() {
     let strChecked = Util.checkString("33 $%&&/%/%/%(!@-*1")
     XCTAssertEqual(strChecked, false)
     }*/
    
    
    func testAverage()  {
        let average = Util.average([1,2,3])
        XCTAssertEqual(average, 2.0)
    }
    
    func testGradeString(){
        XCTAssertEqual(Util.grade(number: 11), 2.0)
    }
    
    func testGradeStringNegative(){
        XCTAssertEqual(Util.grade(number: -11), 2.0)
    }
    
    func testCheckinactiveYears() {
        XCTAssertEqual(Util.checkinactiveYears(["1", "2"], 1), false)
    }
    
    func testSetPrimaryType(){
        Util.setPrimaryType(1)
        XCTAssertEqual(  UserDefaults.standard.integer(forKey: UD_primaryType), 1)
    }
    
    // MARK: CoreData
    func testDeleteData() {
        Util.setContext(TestCoreDataStack.sharedContext)
        JSON.loadDemoData() // should be 0
        Util.deleteSettings()
        
        let count = Util.getAllSubjects().count
        XCTAssertEqual(count, 0)
        let types = Util.getTypes().count
        //  XCTAssertEqual(count, 2)
    }
    
    //MARK: JSON Funcs
    func testLoadDemoData() {
        Util.setContext(TestCoreDataStack.sharedContext)
        
        JSON.loadDemoData() // should be 12
        
        let count = Util.getAllSubjects().count
        
        XCTAssertFalse(count == 0)
        XCTAssertEqual(count, 12)
    }
    
    func testAverageString(){
        let average = Util.averageString(MockDataProvider.getSubjectWithTests())
        
        XCTAssertEqual(average, "-- 11 -- -- ")
    }
}
