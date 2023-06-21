//
//  JSONUtil.swift
//  Calq
//
//  Created by Kiara on 02.12.21.
//

import Foundation
import WidgetKit

struct JSON {
    // MARK: Load Json data
    static func loadJSON() ->[SubjectStruct]{
        var values: [SubjectStruct] = [ ]
        do {
            if let file = Bundle.main.path(forResource: "grades", ofType: "json"){
                let json = try! String(contentsOfFile: file, encoding: String.Encoding.utf8).data(using: .utf8)!
                
                let decoder = JSONDecoder()
                let products = try! decoder.decode([SubjectStruct].self, from: json)
                values = products
            }
        }
        return values
    }
    
    static func writeJSON(_ data: String) -> URL{
        let DocumentDirURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("example").appendingPathExtension("json")
        
        do {
            try data.write(to: DocumentDirURL, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Failed writing to URL: \(DocumentDirURL), Error: " + error.localizedDescription)
        }
        return DocumentDirURL
    }
    
    
    enum loadErrors: Error {
        case failedToloadData
        case failedToLoadDictionary
        case parseJSON
    }
    
    static func createWidgetPreviewData() -> [UserSubject]{
        var exmapleSubjects: [UserSubject] = []
        let data = loadJSON()
        
        for subject in data {
            let sub = UserSubject(context: Util.getContext())
            sub.name = subject.name
            sub.color = subject.color
            sub.lk = subject.lk
            sub.inactiveYears = subject.inactiveYears
            
            for test in subject.subjecttests {
                let t = UserTest(context: Util.getContext())
                t.name = test.name
                t.year = Int16(test.year)
                t.grade = Int16(test.grade)
                t.type = test.big ? 1 : 0
                let timestamp = Int(test.date) ?? 1635417527 / 1000
                t.date = Date(timeIntervalSince1970: Double(timestamp))
                sub.addToSubjecttests(t)
            }
            exmapleSubjects.append(sub)
        }
        return exmapleSubjects
    }
    
    static func checkGrade(_ num: Int) -> Int16 {
        if(num >= 0 && num <= 15){return Int16(num)}
        return Int16(0)
    }
    
    static func checkYear(_ num: Int) -> Int16 {
        if(num >= 1 && num <= 4){return Int16(num)}
        return Int16(0)
    }
    
    static func checkType(_ num: Int) -> Int16 {
        if(num >= 1 && num <= 5){return Int16(num)}
        return Int16(0)
    }
}


// Struct for importing from json
struct AppStructV1: Codable {
    var colorfulCharts: Bool
    var usersubjects: [SubjectStruct]
    var gradeTypes: [JSONTypes]
    var formatVersion: Int
    
    struct JSONTypes: Codable {
        var name: String
        var weigth: Int
        var id: Int
    }
    
    struct SubjectStruct: Codable {
        var name: String
        var lk: Bool
        var color: String
        var inactiveYears: String
        var subjecttests: [JSONTest]
        
        struct JSONTest: Codable{
            var name: String
            var year: Int
            var grade: Int
            var date: String
            var type: Int
        }
    }
}

struct AppStruct: Codable {
    var colorfulCharts: Bool
    var usersubjects: [SubjectStruct]
    
    struct SubjectStruct: Codable {
        var name: String
        var lk: Bool
        var color: String
        var inactiveYears: String
        var subjecttests: [JSONTest]
        
        struct JSONTest: Codable{
            var name: String
            var year: Int
            var grade: Int
            var date: String
            var big: Bool
        }
    }
}
// Struct for loading from json
struct SubjectStruct: Codable {
    var name: String
    var lk: Bool
    var color: String
    var inactiveYears: String
    var subjecttests: [JSONTest]
    
    struct JSONTest: Codable{
        var name: String
        var year: Int
        var grade: Int
        var date: String
        var big: Bool
    }
}
