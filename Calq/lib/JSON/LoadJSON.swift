//
//  LoadJSON.swift
//  Calq
//
//  Created by Kiara on 19.05.23.
//

import Foundation


extension JSON {
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
                    t.type = test.big ? 1 : 0
                    let timestamp = Int(test.date) ?? 1635417527 / 1000
                    t.date = Date(timeIntervalSince1970: Double(timestamp))
                    sub.addToSubjecttests(t)
                }
                settings.addToUsersubjects(sub)
            }
        }
    }
    
    //MARK: Import JSON
    static func importJSONfromDevice(_ URL: URL) throws {
        var json: Data
        var jsonDict: [String:Any] = [:]
        
        do {
            json = (try String(contentsOf: URL, encoding: String.Encoding.utf8).data(using: .utf8))!
            jsonDict = try JSONSerialization.jsonObject(with: json, options: []) as! [String : Any]
        } catch {
            throw loadErrors.failedToloadData
        }
        
        var version = 0
        if (jsonDict["formatVersion"] != nil) {
            version = jsonDict["formatVersion"] as? Int ?? 0
        }
        
        if version >= 1 {
            try consctructV1(json,jsonDict)
        } else {
            try consctructV0(json,jsonDict)
        }
    }
    
    
    static func consctructV1(_ json: Data, _ jsonDict: [String:Any]) throws {
        let decoder = JSONDecoder()
        var data: AppStructV1
        do {
            let importedSettings = try decoder.decode(AppStructV1.self, from: json)
            data = importedSettings
        } catch {
            throw loadErrors.parseJSON
        }
        
        let set = Util.getSettings()!
        for t in set.gradetypes!.allObjects as! [GradeType] {
            set.removeFromGradetypes(t)
        }
        set.colorfulCharts = data.colorfulCharts
        
        //add types
        var typecheck = 0 //should stay below 100
        var typeIds: [Int] = []
        for type in data.gradeTypes {
            if typeIds.contains(type.id){ continue } //ids should only occur once
            
            let NewType = GradeType(context: context)
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
        
        //check if two types there, if not  add default ones
        saveCoreData()
        _ = Util.getTypes()
        
        for subject in data.usersubjects {
            let sub = UserSubject(context: context)
            sub.name = subject.name
            sub.color = subject.color
            sub.lk = subject.lk
            sub.inactiveYears = subject.inactiveYears
            
            //check for exams
            for index in 1...5 {
                if let code = jsonDict["exam\(index)\(sub.name)"] as? Int {
                    sub.examtype = Int16(index)
                    sub.exampoints = Int16(code)
                }
            }
            
            //add tests
            for newTest in subject.subjecttests {
                let test = UserTest(context: context)
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
    
    static func consctructV0(_ json: Data, _ jsonDict: [String:Any]) throws{
        let decoder = JSONDecoder()
        var data: AppStruct
        do {
            let importedSettings = try decoder.decode(AppStruct.self, from: json)
            data = importedSettings
        } catch {
            throw loadErrors.parseJSON
        }
        
        let set = Util.getSettings()!
        set.colorfulCharts = data.colorfulCharts
        
        //add default types lol
        saveCoreData()
        _ = Util.getTypes()
      
        for subject in data.usersubjects {
            let sub = UserSubject(context: context)
            sub.name = subject.name
            sub.color = subject.color
            sub.lk = subject.lk
            sub.inactiveYears = subject.inactiveYears
            
            //check for exams
            for index in 1...5 {
                if let code = jsonDict["exam\(index)\(sub.name)"] as? Int {
                    sub.examtype = Int16(index)
                    sub.exampoints = Int16(code)
                }
            }
            
            //add tests
            for newTest in subject.subjecttests {
                let test = UserTest(context: context)
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
