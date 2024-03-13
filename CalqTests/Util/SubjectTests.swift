//
//  SubjectTests.swift
//  CalqTests
//
//  Created by Kiara on 13.03.24.
//

import XCTest
@testable import Calq

final class SubjectTests: XCTestCase {
    override class func setUp() {
        Util.setContext(TestCoreDataStack.sharedContext)
    }
    
    func getExampleSub() -> UserSubject { // load demoData before!
        return Util.getAllSubjects().first(where: {$0.name == "Kunst"})!
    }
    
    func testDeleteSubject() {
        JSON.loadDemoData()
        
        guard let subject = Util.getAllSubjects().randomElement() else {
            return assertionFailure("No Subject")
        }
        Util.deleteSubject(subject)
        XCTAssertTrue(Util.getAllSubjects().filter { $0.name == subject.name}.isEmpty)
    }
    
    func testDeleteTest() {
        let sub = MockDataProvider.getSubjectWithTests()
        XCTAssertEqual(sub.subjecttests?.count, 1)
        
        Util.deleteTest((sub.subjecttests?.allObjects.first!)! as! UserTest)
        XCTAssertEqual(sub.subjecttests?.count, 0)
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
}
