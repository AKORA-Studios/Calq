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
    
    /*func testCheckString_InvalidInput() {
        let strChecked = Util.isStringInputInvalid("33 /\"$%&&/%/%/%(!@-*1")
        XCTAssertEqual(strChecked, true)
    }*/
    
    func testCheckString_ValidInput() {
        let strChecked = Util.isStringInputInvalid("abc")
        let strChecked2 = Util.isStringInputInvalid("ÖÄÜ")
        
        XCTAssertEqual(strChecked, false)
        XCTAssertEqual(strChecked2, false)
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
    
    func testAverageString_WithoutTests() {
        let average = Util.averageString(MockDataProvider.getSubjectWithoutTests())
        XCTAssertEqual(average, "-- -- -- -- ")
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
    
    func testAddType_MoreThen100Percent() {
        Util.addType(name: "someName", weigth: 0)
        XCTAssertNotNil(Util.getTypes().filter {$0.name == "someName"})
    }
    
    func testAddType() {
        Util.addType(name: "someName", weigth: 200)
        XCTAssertNotNil(Util.getTypes().filter {$0.name == "someName"})
    }
    
    // TODO:
   /* func testDeleteType() {
        let gradeType = Util.getTypes().first
        let id = gradeType!.id
        Util.deleteType(type: id)
        XCTAssertNil(Util.getTypes().filter {$0.id == id})
    }*/
    
    func testEditTypes() {
        // add type
        Util.addType(name: "someName", weigth: 0)
        let type = Util.getTypes().filter {$0.name == "someName"}[0]
        // remove random type
        Util.deleteType(type: type.id)
        XCTAssertTrue(Util.getTypes().filter {$0.name == "someName"}.isEmpty)
    }
    
    func testGetTypes() {
        XCTAssertGreaterThan(Util.getTypes().count, 1)
    }
    
   /* func testGetTypes_WhenOnly1Exists() {
        // TODO:
      /*
        Util.deleteSettings()
        JSON.loadDemoData()
       */
        let type = Util.getTypes().first!
        Util.deleteType(type: type)
        XCTAssertEqual(Util.getTypes().count, 2)
    }*/
    
    func testgetTypeGrades() {
        XCTAssertNotNil(Util.getTypeGrades(0))
    }
    
    func testIsPrimaryType() {
        JSON.loadDemoData()
        let type = Util.getTypes().filter { $0.name == "Klausur"}.first!
        XCTAssertTrue(Util.isPrimaryType(type))
    }
    
    /*func testIsPrimaryType_GradeType() {
        // TODO:
    }*/
    
    // MARK: idk random
    func testGetSubjectAverage() {
        JSON.loadDemoData()
        if let sub = Util.getAllSubjects().filter({ $0.name == "Kunst"}).first {
            let subAverage = Util.getSubjectAverage(sub)
            XCTAssertEqual(subAverage, 14.7)
        }
    }
    
    func testGetSubjectAverage_WithoutTests() {
        JSON.loadDemoData()
        if let sub = Util.getAllSubjects().filter({ $0.name == "Kunst"}).first {
            sub.subjecttests = nil
            saveCoreData()
            let subAverage = Util.getSubjectAverage(sub)
            XCTAssertEqual(subAverage, 0.0)
        }
    }
    
    func testGetSubjectAverage_WithYear() {
        JSON.loadDemoData()
        guard let sub = Util.getAllSubjects().filter({ $0.name == "Kunst"}).first else {
            return XCTAssertTrue(false, "No subejct")
        }
        
        XCTAssertEqual(Util.getSubjectAverage(sub, year: 1), 15.0)
    }
    
    func testGetSubjectAverage_WithYear_WithoutTests() {
        JSON.loadDemoData()
        guard let sub = Util.getAllSubjects().filter({ $0.name == "Kunst"}).first else {
            return XCTAssertTrue(false, "No subejct")
        }
        sub.subjecttests = nil
        saveCoreData()
        XCTAssertEqual(Util.getSubjectAverage(sub, year: 1), 0.0)
    }
    
    func testGetSubjectAverage_WithInvalidYear() {
        JSON.loadDemoData()
        guard let sub = Util.getAllSubjects().filter({ $0.name == "Kunst"}).first else {
            return XCTAssertTrue(false, "No subejct")
        }
        
        XCTAssertEqual(Util.getSubjectAverage(sub, year: 5), 0.0)
    }
    
    func testGeneralAverage() {
        JSON.loadDemoData()
        XCTAssertEqual(Util.generalAverage().rounded(), 12.0)
    }
    
    func testGeneralAverage_WithoutSubejects() {
        let settings = Util.getSettings()
        settings.usersubjects = nil
        saveCoreData()
        
        XCTAssertEqual(Util.generalAverage(), 0.0)
    }
    
    func testGeneralAverage_WithoutTests() {
        let subjects = Util.getAllSubjects()
        subjects.forEach { sub in
            sub.subjecttests = nil
        }
        saveCoreData()
        
        XCTAssertEqual(Util.generalAverage(), 0.0)
    }
    
    func testDeleteTest() {
        let sub = MockDataProvider.getSubjectWithTests()
        XCTAssertEqual(sub.subjecttests?.count, 1)
        
        Util.deleteTest((sub.subjecttests?.allObjects.first!)! as! UserTest)
        XCTAssertEqual(sub.subjecttests?.count, 0)
    }
}
