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
        Util.deleteSettings()
        
        let testBundle = Bundle(for: type(of: self))
        guard let ressourceURL = testBundle.url(forResource: "exampleData_v0", withExtension: "json") else {
            return assertionFailure("ExampleFile does not exist")
        }
        
        do { try JSON.importJSONfromDevice(ressourceURL) } catch { return assertionFailure("Failed to load resource") }
        XCTAssertEqual(Util.getAllSubjects().count, 1)
    }
    
    func testImportV1() {
        Util.deleteSettings()
        
        let testBundle = Bundle(for: type(of: self))
        guard let ressourceURL = testBundle.url(forResource: "exampleData_v1", withExtension: "json") else {
            return assertionFailure("ExampleFile does not exist")
        }
        
        do { try JSON.importJSONfromDevice(ressourceURL) } catch { return  assertionFailure("Failed to load resource") }
        XCTAssertEqual(Util.getAllSubjects().count, 1)
    }
    
    func testImportV2() {
        // TODO:
    }
}
