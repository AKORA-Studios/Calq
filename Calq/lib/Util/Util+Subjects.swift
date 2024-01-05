//
//  Util+FetchSubjects.swift
//  Calq
//
//  Created by Kiara on 05.01.24.
//

import Foundation

/*public enum subjectSortCriteria {
    case none
    case name
    case grade
    case type
    case date
    case createdAt
    case lastEditedAt
}*/

extension Util {
    static func deleteSubject(_ subject: UserSubject) {
        getContext().delete(subject)
    }
    
    /// Returns all Subjects as Array
    static func getAllSubjects() -> [UserSubject] {
        let settings = Util.getSettings()
        return settings.getAllSubjects()
    }
    
    // MARK: Years
    static func getinactiveYears(_ sub: UserSubject) -> [String] {
        if sub.inactiveYears.isEmpty { return [] }
        let arr: [String] = sub.inactiveYears.components(separatedBy: " ")
        return arr
    }
    
    /// Check if year is inactive
    static func checkinactiveYears(_ arr: [String], _ num: Int) -> Bool {
        return !arr.contains(String(num))
    }
    
    /// Remove  inactive halfyear
    @discardableResult static func removeYear(_ sub: UserSubject, _ num: Int) -> UserSubject {
        let arr = getinactiveYears(sub)
        sub.inactiveYears = arrToString(arr.filter { $0 != String(num)})
        saveCoreData()
        return sub
    }
    
    /// Add inactive halfyear
    @discardableResult static func addYear(_ sub: UserSubject, _ num: Int) -> UserSubject {
        var arr = getinactiveYears(sub)
        if arr.contains(String(num)) {
            return sub
        }
        arr.append(String(num))
        sub.inactiveYears = arrToString(arr)
        saveCoreData()
        return sub
    }
    
    /// returns last active year of a subject
    static func lastActiveYear(_ sub: UserSubject) -> Int {
        var num = 1
        
        for i in 1...4 {
            let tests = getAllSubjectTests(sub).filter { $0.year == i }
            if tests.count > 0 { num = i }
        }
        return num
    }
    
    private static func arrToString(_ arr: [String]) -> String {
        return arr.joined(separator: " ")
    }
    
    static func isExamSubject(_ sub: UserSubject) -> Bool {
        return sub.examtype != 0
    }
}
