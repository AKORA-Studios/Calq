//
//  LoadJSON.swift
//  Calq
//
//  Created by Kiara on 19.05.23.
//

import Foundation
import CoreData

extension JSON {
    /// Loads the demo data from grades.json
    static func loadDemoData() {
        let settings: AppSettings = Util.deleteSettings()
        settings.colorfulCharts = true
        settings.hasFiveExams = true
        
        do {
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
                settings.addToUsersubjects(sub)
            }
        }
        saveCoreData()
    }
    
    // MARK: Import JSON
    static func importJSONfromDevice(_ URL: URL) throws {
        var json: Data
        var jsonDict: [String: Any] = [:]
        var version = 0
        
        do {
            json = (try String(contentsOf: URL, encoding: String.Encoding.utf8).data(using: .utf8))!
        } catch {
            throw LoadErrors.failedToloadData
        }
        
        do {
            jsonDict = try JSONSerialization.jsonObject(with: json, options: []) as! [String: Any]
        } catch {
            try consctructV0(json, jsonDict)
            //  throw loadErrors.failedToLoadDictionary
        }
        
        if jsonDict["formatVersion"] != nil {
            version = jsonDict["formatVersion"] as? Int ?? 0
        }
        
        if version >= 3 {
            try consctructV3(json, jsonDict)
        } else if version >= 2 {
            try consctructV2(json, jsonDict)
        } else if version == 1 {
            try consctructV1(json, jsonDict)
        } else {
            try consctructV0(json, jsonDict)
        }
    }
    
    static func consctructV2(_ json: Data, _ jsonDict: [String: Any]) throws {
        try consctructV1(json, jsonDict)
        
        // read primaryType and exam options
        if jsonDict["hasFiveExams"] != nil {
            let hasFiveExams = jsonDict["hasFiveExams"] as? Bool ?? true
            let set = Util.getSettings()
            set.hasFiveExams = hasFiveExams
        }
        
        if jsonDict["highlightedType"] != nil {
            let num = jsonDict["highlightedType"] as? Int16
            
            if let num = num {
                Util.setPrimaryType(num)
            }
        }
    }
    
    static func consctructV1(_ json: Data, _ jsonDict: [String: Any]) throws {
        let decoder = JSONDecoder()
        var data: AppStructV1
        do {
            let importedSettings = try decoder.decode(AppStructV1.self, from: json)
            data = importedSettings
        } catch {
            throw LoadErrors.parseJSON
        }
        
        let set = Util.getSettings()
        for t in set.gradetypes!.allObjects as! [GradeType] {
            set.removeFromGradetypes(t)
        }
        set.colorfulCharts = data.colorfulCharts
        
        // add types
        var typecheck = 0 // should stay below 100
        var typeIds: [Int] = []
        for type in data.gradeTypes {
            if typeIds.contains(type.id) { continue } // ids should only occur once
            
            let NewType = GradeType(context: Util.getContext())
            NewType.name = type.name
            NewType.weigth = Int16(type.weigth)
            NewType.id = Int16(type.id)
            
            if !(typecheck + type.weigth <= 100) {
                NewType.weigth = 0
            }
            
            set.addToGradetypes(NewType)
            typeIds.append(type.id)
            typecheck += type.weigth
        }
        
        // check if two types there, if not  add default ones
        saveCoreData()
        let setTypes = Util.getTypes()
        typeIds = setTypes.map {Int($0.id)}
        
        for subject in data.usersubjects {
            let sub = UserSubject(context: Util.getContext())
            sub.name = subject.name
            sub.color = subject.color
            sub.lk = subject.lk
            sub.inactiveYears = subject.inactiveYears
            
            // check for exams
            for index in 1...5 {
                if let code = jsonDict["exam\(index)\(sub.name)"] as? Int {
                    sub.examtype = Int16(index)
                    sub.exampoints = Int16(code)
                }
            }
            
            // add tests
            for newTest in subject.subjecttests {
                let test = UserTest(context: Util.getContext())
                test.name = newTest.name
                test.year = JSON.checkYear(newTest.year)
                test.grade = JSON.checkGrade(newTest.grade)
                let timestamp = Double(newTest.date) ?? 1635417527 / 1000
                test.date = Date(timeIntervalSince1970: Double(timestamp))
                
                if typeIds.contains(newTest.type) {
                    test.type = Int16(newTest.type)
                } else {
                    test.type = Int16(typeIds[0])
                }
                
                sub.addToSubjecttests(test)
            }
            set.addToUsersubjects(sub)
        }
        
        saveCoreData()
    }
    
    static func consctructV0(_ json: Data, _ jsonDict: [String: Any]) throws {
        let decoder = JSONDecoder()
        var data: AppStruct
        
        do {
            let importedSettings = try decoder.decode(AppStruct.self, from: json)
            data = importedSettings
        } catch {
            throw LoadErrors.parseJSON
        }
        
        let set = Util.getSettings()
        set.colorfulCharts = data.colorfulCharts
        
        // add default types lol
        saveCoreData()
        _ = Util.getTypes()
        
        for subject in data.usersubjects {
            let sub = UserSubject(context: Util.getContext())
            sub.name = subject.name
            sub.color = subject.color
            sub.lk = subject.lk
            sub.inactiveYears = subject.inactiveYears
            
            // check for exams
            for index in 1...5 {
                if let code = jsonDict["exam\(index)\(sub.name)"] as? Int {
                    sub.examtype = Int16(index)
                    sub.exampoints = Int16(code)
                }
            }
            
            // add tests
            for newTest in subject.subjecttests {
                let test = UserTest(context: Util.getContext())
                test.name = newTest.name
                test.year = JSON.checkYear(newTest.year)
                test.grade = JSON.checkGrade(newTest.grade)
                let timestamp = Double(newTest.date) ?? 1635417527 / 1000
                test.date = Date(timeIntervalSince1970: Double(timestamp))
                test.type = newTest.big ? 1 : 0
                
                sub.addToSubjecttests(test)
            }
            set.addToUsersubjects(sub)
        }
        
        saveCoreData()
    }
    
}
