//
//  ExportJSON.swift
//  Calq
//
//  Created by Kiara on 19.05.23.
//

import Foundation

extension JSON {
    /// Export userdata as json
    static func exportJSON() -> String {
        let formatter = DateFormatter.calqFormat
        let data = Util.getSettings()
        
        let primaryType = UserDefaults.standard.integer(forKey: UD_primaryType)
        var string = "{\"formatVersion\": 3, \"colorfulCharts\": \(data.colorfulCharts), \"hasFiveExams\": \(data.hasFiveExams), \"showGradeTypes\": \(data.showGradeTypes), \"highlightedType\": \(primaryType), \"gradeTypes\": \(getTypesJSONData()), \(getExamJSONData()) \"usersubjects\": ["
        
        let subjects = Util.getAllSubjects()
        var subCount: Int = 0
        
        for sub in subjects {
            string += "{\"name\": \"\(sub.name)\", \"lk\": \(sub.lk), \"color\": \"\(sub.color)\", \"inactiveYears\":  \"\(sub.inactiveYears )\", \"lastEditedAt\": \"\(formatter.string(from: sub.lastEditedAt))\", \"createdAt\": \"\(formatter.string(from: sub.createdAt))\", \"subjecttests\": ["
            
            let tests = sub.getAllTests()
            if tests.isEmpty { continue }
            
            var testCount: Int = 0
            
            for test in tests {
                testCount += 1
                string += "{\"name\": \"\(test.name)\", \"year\": \(test.year), \"grade\":\(test.grade), \"isWrittenGrade\":\(test.isWrittenGrade), \"lastEditedAt\": \"\(formatter.string(from: test.lastEditedAt))\", \"createdAt\": \"\(formatter.string(from: test.createdAt))\", \"date\": \"\(formatter.string(from: test.date))\", \"type\": \(test.type)} \(tests.count == testCount ? "": ",")"
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
