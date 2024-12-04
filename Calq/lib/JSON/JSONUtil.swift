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
    static func loadJSON() -> [AppStruct.SubjectStruct] {
        var values: [AppStruct.SubjectStruct] = [ ]
        if let file = Bundle.main.path(forResource: "grades", ofType: "json") {
            if let json = try? String(contentsOfFile: file, encoding: String.Encoding.utf8).data(using: .utf8) {
                let decoder = JSONDecoder()
                let products = try! decoder.decode([AppStruct.SubjectStruct].self, from: json)
                values = products
            }
        }
        return values
    }
    
    static func writeJSON(_ data: String) -> URL {
        let DocumentDirURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("example").appendingPathExtension("json")
        
        do {
            try data.write(to: DocumentDirURL, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Failed writing to URL: \(DocumentDirURL), Error: " + error.localizedDescription)
        }
        return DocumentDirURL
    }
    
    enum LoadErrors: Error {
        case failedToloadData
        case failedToLoadDictionary
        case parseJSON
    }
    
    static func createWidgetPreviewData() -> [UserSubject] {
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
        if num >= 0 && num <= 15 { return Int16(num) }
        return Int16(0)
    }
    
    static func checkYear(_ num: Int) -> Int16 {
        if num >= 1 && num <= 4 { return Int16(num) }
        return Int16(0)
    }
    
    static func checkType(_ num: Int) -> Int16 {
        if num >= 1 && num <= 5 { return Int16(num) }
        return Int16(0)
    }
    
    static func formatJSON(_ jsonString: String) -> String {
        guard let jsonData = jsonString.data(using: .utf8) else {
            return jsonString // return unformatted
        }
        
        var jsonObject: Any
        do {
            jsonObject =  try JSONSerialization.jsonObject(with: jsonData)
        } catch {
            return jsonString // return unformatted
        }
        
        var prettyJsonData: Data
        do {
            prettyJsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        } catch {
            return jsonString // return unformatted
        }
        
        let prettyPrintedJson = NSString(data: prettyJsonData, encoding: NSUTF8StringEncoding)!
        return prettyPrintedJson as String
    }
}
