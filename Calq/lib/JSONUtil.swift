//
//  JSONUtil.swift
//  Calq
//
//  Created by Kiara on 02.12.21.
//

import Foundation
import WidgetKit

struct JSON {
    ///Loads the demo data from grades.json
    static func loadDemoData(){
        print(">>> load demo data")
        
        let settings: AppSettings = Util.deleteSettings()
        settings.colorfulCharts = true
        
        do {
            let data = loadJSON()
            for subject in data {
                let sub = UserSubject(context: context)
                sub.name = subject.name
                sub.color = subject.color
                sub.lk = subject.lk
                sub.inactiveYears = subject.inactiveYears
                
                for test in subject.subjecttests {
                    let t = UserTest(context: context)
                    t.name = test.name
                    t.year = Int16(test.year)
                    t.grade = Int16(test.grade)
                    t.big = test.big
                    let timestamp = Int(test.date) ?? 1635417527 / 1000
                    t.date = Date(timeIntervalSince1970: Double(timestamp))
                    sub.addToSubjecttests(t)
                }
                settings.addToUsersubjects(sub)
            }
        }
    }
    
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
    
    ///Export userdata as json
    static func exportJSON()-> String{
        let data = Util.getSettings()
        var string = "{\"colorfulCharts\": \(data?.colorfulCharts ?? true), \(getExamJSONData()) \"usersubjects\": ["
        
        let subjects = Util.getAllSubjects()
        var subCount: Int = 0
        
        for sub in subjects {
            string += "{\"name\": \"\(sub.name)\", \"lk\": \(sub.lk), \"color\": \"\(sub.color)\", \"inactiveYears\":  \"\(sub.inactiveYears )\", \"subjecttests\": ["
            
            if(sub.subjecttests == nil){continue}
            let tests = sub.subjecttests!.allObjects as! [UserTest]
            var testCount: Int = 0
            
            for test in tests{
                testCount += 1
                string += "{\"name\": \"\(test.name)\", \"year\": \(test.year), \"grade\":\(test.grade), \"date\": \"\(test.date.timeIntervalSince1970)\", \"big\": \(test.big)} \(tests.count == testCount ? "": ",")"
                
            }
            subCount += 1
            string += "]} \(subjects.count == subCount ? "" : ",")"
            
        }
        string += "]}"
        return string
    }
    
    static func getExamJSONData() -> String {
        var str = ""
        let subjects = Util.getAllSubjects()
        
        for index in 1...5 {
            if let exam = subjects.filter({$0.examtype == Int16(index)}).first {
                str += "\"exam\(index)\(exam.name)\": \(exam.exampoints),"
            }
        }
        return str == "" ? "," : str
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
        case parseJSON
    }
    
    //MARK: Import JSON
    static func importJSONfromDevice(_ URL: URL)throws {
        var json: Data
        
        do {
            
            json = (try String(contentsOf: URL, encoding: String.Encoding.utf8).data(using: .utf8))!
        } catch {
            throw loadErrors.failedToloadData
        }
        
        var newSettings: AppStruct
        let decoder = JSONDecoder()
        
        do {
            let importedSettings = try decoder.decode(AppStruct.self, from: json)
            newSettings = importedSettings
        }catch {
            throw loadErrors.parseJSON
        }
        
        let set: AppSettings = Util.deleteSettings()
        set.colorfulCharts = newSettings.colorfulCharts
        
        // if(set.usersubjects.count != 0){
        for subject in newSettings.usersubjects {
            let sub = UserSubject(context: context)
            sub.name = subject.name
            sub.color = subject.color
            sub.lk = subject.lk
            sub.inactiveYears = subject.inactiveYears
            
            //    if(sub.subjecttests.count != 0){
            for newTest in subject.subjecttests {
                let test = UserTest(context: context)
                test.name = newTest.name
                test.year = checkYear(newTest.year)
                test.grade = checkGrade(newTest.grade)
                let timestamp = Double(newTest.date) ?? 1635417527 / 1000
                test.date = Date(timeIntervalSince1970: Double(timestamp))
                test.big = newTest.big
                
                sub.addToSubjecttests(test)
            }//}
            set.addToUsersubjects(sub)
            //  }
        }
        //   }
    }
    
    static func createWidgetPreviewData() -> [UserSubject]{
        var exmapleSubjects: [UserSubject] = []
        let data = loadJSON()
        
        for subject in data {
            let sub = UserSubject(context: context)
            sub.name = subject.name
            sub.color = subject.color
            sub.lk = subject.lk
            sub.inactiveYears = subject.inactiveYears
            
            for test in subject.subjecttests {
                let t = UserTest(context: context)
                t.name = test.name
                t.year = Int16(test.year)
                t.grade = Int16(test.grade)
                t.big = test.big
                let timestamp = Int(test.date) ?? 1635417527 / 1000
                t.date = Date(timeIntervalSince1970: Double(timestamp))
                sub.addToSubjecttests(t)
            }
            exmapleSubjects.append(sub)
        }
        return exmapleSubjects
    }
    
}

private func checkGrade(_ num: Int) -> Int16 {
    if(num >= 0 && num <= 15){return Int16(num)}
    return Int16(0)
}

private func checkYear(_ num: Int) -> Int16 {
    if(num >= 1 && num <= 4){return Int16(num)}
    return Int16(0)
}

private func checkType(_ num: Int) -> Int16 {
    if(num >= 1 && num <= 5){return Int16(num)}
    return Int16(0)
}

// Struct for importing from json
struct AppStruct: Codable {
    var colorfulCharts: Bool;
    var usersubjects: [SubjectStruct];
    
    struct SubjectStruct: Codable {
        var name: String;
        var lk: Bool;
        var color: String;
        var inactiveYears: String;
        var subjecttests: [JSONTest];
        
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
    var name: String;
    var lk: Bool;
    var color: String;
    var inactiveYears: String;
    var subjecttests: [JSONTest];
    
    struct JSONTest: Codable{
        var name: String
        var year: Int
        var grade: Int
        var date: String
        var big: Bool
    }
}
