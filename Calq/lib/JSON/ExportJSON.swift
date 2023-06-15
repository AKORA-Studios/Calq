//
//  ExportJSON.swift
//  Calq
//
//  Created by Kiara on 19.05.23.
//

import Foundation


extension JSON {
    ///Export userdata as json
    static func exportJSON()-> String{
        let data = Util.getSettings()
        var string = "{\"formatVersion\": 1, \"colorfulCharts\": \(data.colorfulCharts), \"gradeTypes\": \(getTypesJSONData()), \(getExamJSONData()) \"usersubjects\": ["
        
        let subjects = Util.getAllSubjects()
        var subCount: Int = 0
        
        for sub in subjects {
            string += "{\"name\": \"\(sub.name)\", \"lk\": \(sub.lk), \"color\": \"\(sub.color)\", \"inactiveYears\":  \"\(sub.inactiveYears )\", \"subjecttests\": ["
            
            if(sub.subjecttests == nil){continue}
            let tests = sub.subjecttests!.allObjects as! [UserTest]
            var testCount: Int = 0
            
            for test in tests{
                testCount += 1
                string += "{\"name\": \"\(test.name)\", \"year\": \(test.year), \"grade\":\(test.grade), \"date\": \"\(test.date.timeIntervalSince1970)\", \"type\": \(test.type)} \(tests.count == testCount ? "": ",")"
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
        return str
    }
    
    static func getTypesJSONData() -> String {
        var arr: [String] = []
        let types = Util.getTypes()
        
        for x in types {
            arr.append( "{\"name\": \"\(x.name)\", \"weigth\": \(x.weigth), \"id\": \(x.id)}")
        }
        return "[\(arr.joined(separator: ","))]"
    }
}
