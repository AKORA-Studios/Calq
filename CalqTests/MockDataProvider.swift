//
//  MockDataProvider.swift
//  CalqTests
//
//  Created by Kiara on 16.06.23.
//

import CoreData
@testable import Calq

class MockDataProvider {
    @discardableResult
    static func getSubjectWithTests() -> UserSubject {
        let settings: AppSettings = Util.deleteSettings()
        let sub = UserSubject(context: Util.getContext())
        sub.name = "name"
        sub.color = "ffffff"
        sub.lk = true
        sub.inactiveYears = ""
        
        let t = UserTest(context: Util.getContext())
        t.name = "test"
        t.year = Int16(2)
        t.grade = Int16(11)
        t.type = 1
        let timestamp =  1635417527 / 1000
        t.date = Date(timeIntervalSince1970: Double(timestamp))
        sub.addToSubjecttests(t)
        
        settings.addToUsersubjects(sub)
        
        saveCoreData()
        return sub
    }
    
    @discardableResult
    static func getSubjectWithoutTests() -> UserSubject {
        let settings: AppSettings = Util.deleteSettings()
        let sub = UserSubject(context: Util.getContext())
        sub.name = "name"
        sub.color = "ffffff"
        sub.lk = true
        sub.inactiveYears = ""
        
        sub.examtype = 2
        sub.exampoints = 15
        
        settings.addToUsersubjects(sub)
        
        saveCoreData()
        return sub
    }
}
