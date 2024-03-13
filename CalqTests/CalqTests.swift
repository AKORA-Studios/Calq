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
    
    // MARK: Averages
    func testAverageString() {
        JSON.loadDemoData()
        let subject = getExampleSub()
        XCTAssertEqual(Util.averageString(subject), "15 15 14 15")
    }
    
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
}
