//
//  GradeTypeTests.swift
//  CalqTests
//
//  Created by Kiara on 13.03.24.
//

import XCTest
@testable import Calq

final class GradeTypeTests: XCTestCase {
    
    override class func setUp() {
        Util.setContext(TestCoreDataStack.sharedContext)
    }
    
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
    
    func testDeleteType() {
        guard let gradeType = Util.getTypes().first else {
            return assertionFailure("No type :c")
        }
        Util.deleteType(type: gradeType)
        XCTAssertTrue(Util.getTypes().filter {$0.name == gradeType.name}.isEmpty)
    }
    
    func testDeleteTypeById() {
        guard let gradeType = Util.getTypes().first else {
            return assertionFailure("No type :c")
        }
        Util.deleteType(type: gradeType.id)
        XCTAssertTrue(Util.getTypes().filter {$0.name == gradeType.name}.isEmpty)
    }
    
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
    
    func testGetTypes_WhenOnly1Exists() {
        Util.deleteSettings()
        JSON.loadDemoData()
        
        let type = Util.getTypes().first!
        Util.deleteType(type: type)
        XCTAssertEqual(Util.getTypes().count, 2)
    }
    
    func testgetTypeGrades() {
        XCTAssertNotNil(Util.getTypeGrades(0))
    }
    
    func testIsPrimaryType() {
        JSON.loadDemoData()
        let type = Util.getTypes().filter { $0.name == "Klausur"}.first!
        XCTAssertTrue(Util.isPrimaryType(type))
    }
}
