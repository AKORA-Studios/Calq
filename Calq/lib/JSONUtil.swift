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
    let context = CoreDataStack.shared.managedObjectContext
    
    let settings: AppSettings = Util.deleteSettings()
    settings.colorfulCharts = true
    settings.firstLaunch = false
    settings.smoothGraphs = false
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
    try! context.save()
    WidgetCenter.shared.reloadAllTimelines()
}

// MARK: Load Default Data
/// Loads the default data (3 subjects without grades)
static func loadDefaultData() {
    let context = CoreDataStack.shared.managedObjectContext
    
    var settings: AppSettings
    do {
        let items = try context.fetch(AppSettings.fetchRequest())
        settings = items[0]
        settings.firstLaunch = true
        
        struct sub{
            var name: String
            var color: String
            var lk: Bool
        }
        let data = [sub(name: "Deutsch", color: "#db1c1c", lk: true),
                    sub(name: "Mathe", color: "#1c6fdb", lk: false),
                    sub(name: "Bio", color: "#78db1c", lk: true)
        ]
        for subject in data {
            let sub = UserSubject(context: context)
            sub.name = subject.name
            sub.color = subject.color
            sub.lk = subject.lk
            
            settings.addToUsersubjects(sub)
        }
    } catch {}
    try! context.save()
    WidgetCenter.shared.reloadAllTimelines()
}

// MARK: Load Json data
private static func loadJSON() ->[SubjectStruct]{
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

/// Check if given data is valid
 static func validateJson(str: String) -> Bool{
     let decoder = JSONDecoder()
     
     do {
         _ = try decoder.decode([SubjectStruct].self, from: str.data(using: .utf8)!)
     }catch {return false}
    
    return true
}

/// Create data from json File
 static func importJson(str: String) -> [SubjectStruct]{
     let decoder = JSONDecoder()
     var values: [SubjectStruct] = [ ]
     
     let products = try! decoder.decode([SubjectStruct].self, from: str.data(using: .utf8)!)
    values = products
     
     return values
}

///Export userdata as json
 static func exportJSON()-> String{
     let data = Util.getSettings()
     var string = "{\"colorfulCharts\": \(data?.colorfulCharts ?? true), \"firstLaunch\": \(data?.firstLaunch ?? false), \"smoothGraphs\": \(data?.smoothGraphs ?? false), \"usersubjects\": ["
     
     let subjects = Util.getAllSubjects()
     var subCount: Int = 0
     
     for sub in subjects {
         string += "{\"name\": \"\(sub.name!)\", \"lk\": \(sub.lk), \"color\": \"\(sub.color!)\", \"inactiveYears\":  \"\(sub.inactiveYears ?? "") \", \"subjecttests\": ["

         if(sub.subjecttests == nil){continue}
         let tests = sub.subjecttests!.allObjects as! [UserTest]
         var testCount: Int = 0
         
         for test in tests{
             testCount += 1
             string += "{\"name\": \"\(test.name!)\", \"year\": \(test.year), \"grade\":\(test.grade), \"date\": \(test.date!.timeIntervalSince1970), \"big\": \(test.big)} \(tests.count == testCount ? "": ",")"
           
         }
         subCount += 1
         string += "]} \(subjects.count == subCount ? "" : ",")"
       
     }
     string += "]}"
     return string
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
            print("A2")
            let importedSettings = try decoder.decode(AppStruct.self, from: json)
            print(importedSettings)
            newSettings = importedSettings
            print("B")
        }catch {
            throw loadErrors.parseJSON
        }
        print("C")
       /* do {
            let data = try Data(contentsOf: URL)
            let json = (try String(contentsOf: URL, encoding: String.Encoding.utf8).data(using: .utf8))!
    
            let decoder = JSONDecoder()
            let products = try decoder.decode([SubjectStruct].self, from: json)
            values = products
            print(products)
            print("a")
        } catch {
            print("h")
            throw loadErrors.failedToloadData
        }
        print("b")
        print(values)*/
        //var nameArr: [String] = []

        /*   if(nameArr.contains(sub.name)){ throw "Duplicate Subejctname at: \(sub.name)"}
           nameArr.append(sub.name)

           if(sub.inactiveYears) {
               let arr: [String] = sub.inactiveYears!.components(separatedBy: " ")
               for num in arr {
                   var num = Int(num)
                   if (num == nil) {throw "Invalid inactiveYears at: \(sub.name)"}
                   if (num > 4 || num < 1)) {throw "Invalid inactiveYears at: \(sub.name)"}
               }
               return arr
           }

           var testArr: [String] = []
           for test in sub.subjecttests{
           if(testArr.contains(test.name)) {throw "Duplicate Testname \(test.name) at: \(sub.name)"}
            testArr.append(test.name)

           if(test.grade > 15 || test.grade < 0) { throw "Invalid grade at:  \(test.name)"}
           if(test.year > 4 || test.year < 1) { throw "Invalid year at:  \(test.name)"}
        }*/
    }
}

// Struct for importing from json
struct AppStruct: Codable {
    var colorfulCharts: Bool;
    var firstLaunch: Bool;
    var smoothGraphs: Bool;
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
