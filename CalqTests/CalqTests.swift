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
    
    
    override class func setUp() {
        // This is the setUp() class method.
        // XCTest calls it before calling the first test method.
        // Set up any overall initial state here.
        Util.setContext(TestCoreDataStack.sharedContext)
    }
    
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
        Util.deleteSettings()
        
        let count = Util.getAllSubjects().count
        XCTAssertEqual(count, 0)
        let types = Util.getTypes().count
        //  XCTAssertEqual(count, 2)
    }
    
    //MARK: JSON Funcs
    func testLoadDemoData() {
        JSON.loadDemoData()
        let count = Util.getAllSubjects().count
        
        XCTAssertFalse(count == 0)
        XCTAssertEqual(count, 12)
    }
    
    func testExport(){
        //TODO
    }
    
    func testImportV1(){
        //TODO
    }
    
    func testImportV2(){
        //TODO
    }
    
    func testAverageString(){
        let average = Util.averageString(MockDataProvider.getSubjectWithTests())
        XCTAssertEqual(average, "-- 11 -- -- ")
    }
    
    // MARK: Inactive Year funcs
    func getExampleSub() -> UserSubject { //load demoData before!
        return Util.getAllSubjects().first(where: {$0.name == "Kunst"})!
    }
    
    func testDeactivateHalfyear(){ // TODO
        JSON.loadDemoData()
        
        let before =  Util.getinactiveYears(getExampleSub())
        XCTAssertEqual(before.count, 0)
        
        let e = Util.removeYear(getExampleSub(), 3)
        /*     let after = Util.getinactiveYears(e)
         print(e.inactiveYears)
         XCTAssertEqual(before.count, 1)*/
    }
    
    func testLastActiveYear(){
        JSON.loadDemoData()
        let lastYear =  Util.lastActiveYear(getExampleSub())
        XCTAssertEqual(lastYear, 4)
    }
}
