//
//  JSONTests.swift
//  CalqTests
//
//  Created by Kiara on 05.09.23.
//

import XCTest
@testable import Calq

final class JSONTests: XCTestCase {
    
    func testLoadDemoData() {
        JSON.loadDemoData()
        let count = Util.getAllSubjects().count
        
        XCTAssertFalse(count == 0)
        XCTAssertEqual(count, 12)
    }
    
    func testExport() {
        let data = "idk"
        let url =  JSON.writeJSON(data)
        
        do {
            let fileContent = try String(contentsOf: url, encoding: .utf8)
            XCTAssertEqual(data, fileContent)
        } catch {
            return  assertionFailure("Exported File is empty")
        }
    }
    
    func testImportV0() {
        loadJSON(ressource: "exampleData_v0")
        
        XCTAssertEqual(Util.getAllSubjects().count, 1)
    }
    
    func testImportV1() {
        loadJSON(ressource: "exampleData_v1")
        
        XCTAssertEqual(Util.getAllSubjects().count, 1)
    }
    
    func testImportV2() {
        loadJSON(ressource: "exampleData_v2")
    
        let settings = Util.getSettings()
        XCTAssertEqual(settings.hasFiveExams, false)
    }
    
    // MARK: load Data
    func loadJSON(ressource: String) {
        Util.deleteSettings()
        
        let testBundle = Bundle(for: type(of: self))
        guard let ressourceURL = testBundle.url(forResource: ressource, withExtension: "json") else {
            return assertionFailure("ExampleFile does not exist")
        }
        
        do { try JSON.importJSONfromDevice(ressourceURL) } catch { return  assertionFailure("Failed to load resource") }
    }
    
    func testCreateWidgetPreviewData() {
        XCTAssertEqual(JSON.createWidgetPreviewData().count, 12)
    }
    
    // MARK: Validation
    func testCheckGrade() {
        XCTAssertEqual(JSON.checkGrade(3), 3)
        XCTAssertEqual(JSON.checkGrade(16), 0)
    }
    
    func testCheckYear() {
        XCTAssertEqual(JSON.checkYear(3), 3)
        XCTAssertEqual(JSON.checkYear(5), 0)
    }
    
    func testCheckType() {
        XCTAssertEqual(JSON.checkType(3), 3)
        XCTAssertEqual(JSON.checkType(7), 0)
    }
}
