//
//  Util.swift
//  Calq
//
//  Created by Kiara on 10.02.23.
//

import CoreData
import SwiftUI

public enum ModelKit {
    public static let bundle = Bundle.main
}

let UD_firstLaunchKey = "notFirstLaunch"
let UD_primaryType = "primaryGradeType"
let UD_lastVersion = "lastAppVersion"
let UD_lastAskedForeReview = "lastAskedForReview"

let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?.?.?"
let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "?.?.?"

protocol ImplementsCoreDataStack {
    static var sharedContext: NSManagedObjectContext { get }
}

func saveCoreData() {
    let context = Util.getContext()
    if context.hasChanges {
        do {
            try Util.getContext().save()
        } catch {
            print("Failed saving context with \(error)")
        }
    }
}

struct Util {
    private static var context = CoreDataStack.sharedContext
    
    static func setContext(_ newContext: NSManagedObjectContext) {
        context = newContext
    }
    
    static func getContext() -> NSManagedObjectContext {
        return context
    }
    
    static func isStringInputInvalid(_ str: String) -> Bool {
        if str.isEmpty { return true }
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z_ ]*$")
        let range = NSRange(location: 0, length: str.utf16.count)
        return regex.firstMatch(in: str, options: [], range: range) == nil
    }
    
    // MARK: Average Functions
    static func average (_ values: [Int]) -> Double {
        if values.count < 1 { return 0 }
        
        var avg = 0
        for i in 0..<values.count {
            avg += values[i]
        }
        return (Double(avg) / Double(values.count))
    }
    
    static private func average (_ values: [Double]) -> Double {
        if values.count < 1 { return 0 }
        
        var avg = Double(0)
        for i in 0..<values.count {
            avg += values[i]
        }
        return (Double(avg) / Double(values.count))
    }
    
    static private func average (_ values: [Int], from: Int = 0, to: Int = -1) -> Double {
        return self.average(values.map { Double($0)} as [Double], from: from, to: to)
    }
    
    static private func average (_ values: [Double], from: Int = 0, to: Int = -1) -> Double {
        if from > values.count { return 0 }
        
        var sum = Double(0)
        if to<0 {for i in from..<values.count {
            sum += values[i]
        }} else {for i in from..<to {
            sum += values[i]
        }}
        
        return (Double(sum) / Double(values.count))
    }
    
    /// Returns the average of an array of tests.
    static func testAverage(_ tests: [UserTest]) -> Double {
        var gradeWeights = 0.0
        var avgArr: [Double] = []
        
        for type in getTypes() {
            let filteredTests = tests.filter {$0.type == type.id}
            if !filteredTests.isEmpty {
                let weight = Double(Double(type.weigth)/100)
                gradeWeights += weight
                let avg = Util.average(filteredTests.map {Int($0.grade)})
                avgArr.append(Double(avg * weight))
            }
        }
        
        if avgArr.isEmpty { return 0 }
        let num = avgArr.reduce(0, +)/gradeWeights
        
        if num.isNaN { return 0 }
        return num
    }
    
    /// Returns the average of all grades from one subject
    static func getSubjectAverage(_ sub: UserSubject) -> Double {
        let tests = Util.getAllSubjectTests(sub, .onlyActiveHalfyears)
        if tests.isEmpty { return 0.0 }
        
        var count = 0.0
        var subaverage = 0.0
        
        for e in 1...4 {
            let yearTests = tests.filter {$0.year == Int16(e)}
            if yearTests.isEmpty { continue }
            count += 1
            subaverage += Util.testAverage(yearTests)
        }
        let average = (subaverage / count)
        return Double(String(format: "%.2f", average).padding(toLength: 4, withPad: "0", startingAt: 0))!
    }
    
    /// Returns the average of all grades from one subject
    static func getSubjectAverage(_ sub: UserSubject, year: Int, filterinactve: Bool = true) -> Double {
        let allTests = filterinactve ? getAllSubjectTests(sub) : getAllSubjectTests(sub, .onlyActiveHalfyears)
        let tests = allTests.filter {$0.year == year}
        if tests.isEmpty { return 0.0 }
        return testAverage(tests)
    }
    
    /// Returns the average of all grades from all subjects.
    static func generalAverage() -> Double {
        let allSubjects = getAllSubjects()
        
        if allSubjects.count == 0 { return 0.0 }
        var a = 0.0
        var subjectCount = Double(allSubjects.count)
        
        for sub in allSubjects {
            let tests = getAllSubjectTests(sub, .onlyActiveHalfyears)
            if tests.isEmpty { subjectCount-=1; continue }
            a += round(getSubjectAverage(sub))
        }
        
        if (a / subjectCount).isNaN { return 0.0 }
        return a / subjectCount
    }
    
    /// Returns the average of all grades from all subjects in a specific halfyear
    static func generalAverage(_ year: Int) -> Double {
        let allSubjects = getAllSubjects()
        if allSubjects.count == 0 { return 0.0 }
        var count = 0.0
        var grades = 0.0
        
        for sub in allSubjects {
            let tests = getAllSubjectTests(sub, .onlyActiveHalfyears).filter {Int($0.year) == year}
            if tests.isEmpty { continue }
            let multiplier = sub.lk ? 2.0 : 1.0
            
            count += multiplier * 1
            grades += multiplier * round(Util.testAverage(tests))
        }
        if grades == 0.0 { return 0.0 }
        return grades / count
    }
    
    /// Converts the points(0-15) representation of a grade to the more common 1-6 scale.
    static func grade(number: Double) -> Double {
        if number == 0.0 { return 0.0 }
        return ((17 - abs(number)) / 3.0)
    }
    
    /// Generates a convient String that shows the grades of the subject.
    static func averageString(_ subject: UserSubject) -> String {
        var str: String = ""
        let tests = getAllSubjectTests(subject)
        
        for i in 1...4 {
            let arr = tests.filter({$0.year == i})
            if arr.isEmpty { str += "-- "; continue }
            str += String(Int(round(Util.testAverage(arr))))
            if i != 4 { str += " "}
        }
        return str
    }
    
    // MARK: Get Settings
    /// Returns fresh new settings and deletes everything
    @discardableResult static func deleteSettings() -> AppSettings {
        let request: NSFetchRequest<AppSettings> = AppSettings.fetchRequest()
        
        do {
            let items: [NSManagedObject] = try context.fetch(request)
            items.forEach { i in
                context.delete(i)
            }
        } catch { print("Failed to delete Data") }
        saveCoreData()
        return Util.getSettings()
    }
    
    /// Returns the apps settings
    static func getSettings() -> AppSettings {
        do {
            let fetchRequest = NSFetchRequest<AppSettings>(entityName: "AppSettings")
            let requestResult = try context.fetch(fetchRequest)
            
            if requestResult.isEmpty {
                let item =  AppSettings(context: Util.getContext())
                item.colorfulCharts = false
                setTypes(item)
                saveCoreData()
                return item
            } else {
                let settings = requestResult[0]
                if settings.gradetypes?.count == 0 {
                    setTypes(settings)
                    saveCoreData()
                }
                return settings
            }
            
        } catch let err { print("Failed to load settings", err) }
        
        print("THIS SHOULD NOT HAPPEN HELP")
        let item =  AppSettings(context: Util.getContext())
        item.colorfulCharts = false
        setTypes(item)
        saveCoreData()
        return item
    }
    
    static func checkIfNewVersion() -> Bool {
        let oldVersion = UserDefaults.standard.string(forKey: UD_lastVersion) ?? "0.0.0"
        if oldVersion == "0.0.0" { return true }
        let partsOldV = oldVersion.split(separator: ".")
        let partsNewV = appVersion.split(separator: ".")
        
        if partsOldV.isEmpty { return true }
        
        if partsOldV[0] < partsNewV[0] {
            return true
        } else if partsOldV[0] == partsNewV[0] && partsOldV[1] < partsNewV[1] {
            return true
        }
        return false
    }
}
