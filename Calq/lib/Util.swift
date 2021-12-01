import UIKit
import Foundation
import CoreData
import SwiftUI
import WidgetKit


public var NoDataText = "Keine Daten für diesen Graph vorhanden"

enum UtilErrors: Error {
    case NoSubjects
}

struct Util {
    
    // MARK: Colors & Gradients
    static func generateColorGradient(
        _ count: Int,
        sat: CGFloat = 1.0,
        bright: CGFloat = 1.0,
        alpha: CGFloat = 1.0
    ) -> [UIColor]  {
        var arr: [UIColor] = [];
        
        for i in 0..<count {
            arr.append(
                UIColor(
                    hue: CGFloat(i)/CGFloat(count),
                    saturation: sat,
                    brightness: bright,
                    alpha: alpha
                )
            )
        }
        return arr;
    }
    
    /// Returns a color between red and green depending on the amount of points.
    static func gradeColor(_ points: Int) -> UIColor  {
        return UIColor(
            hue: CGFloat((Float(points)/15.0) / 3),
            saturation: 0.73,
            brightness: 0.92,
            alpha: 1
        );
    }
    
    static let pastelColors = ["#ed8080",
                               "#edaf80",
                               "#edd980",
                               "#caed80",
                               "#90ed80",
                               "#80edb8",
                               "#80caed",
                               "#809ded",
                               "#9980ed",
                               "#ca80ed",
                               "#ed80e4",
                               "#ed80a4"].map{UIColor.init(hexString: $0)}
    
    
    static func getPastelColorByIndex(_ index: Int) -> UIColor{
        return pastelColors[index%(pastelColors.count-1)]
    }
    
    static func getPastelColorByIndex(_ name: String) -> UIColor{
        let subjects = Util.getAllSubjects()
        let subjectIndex = subjects.firstIndex(where:{$0.name! == name}) ?? 0
        return getPastelColorByIndex(subjectIndex)
    }
    
    // MARK: Average Functions
    static func average (_ values: [Int]) -> Double {
        if (values.count < 1) {return 0}
        
        var avg = 0
        for i in 0..<values.count {
            avg += values[i];
        }
        
        return (Double(avg) / Double(values.count))
    }
    
    static func average (_ values: [Double]) -> Double {
        if (values.count < 1) {return 0}
        
        var avg = Double(0);
        for i in 0..<values.count {
            avg += values[i];
        }
        
        return (Double(avg) / Double(values.count))
    }
    
    static func average (_ values: [Int], from: Int = 0, to: Int = -1) -> Double {
        return self.average(values.map { Double($0)} as [Double], from: from, to: to)
    }
    
    static func average (_ values: [Double], from: Int = 0, to: Int = -1) -> Double {
        if (from > values.count) {return 0;}
        
        var sum = Double(0);
        if (to<0){for i in from..<values.count {
            sum += values[i];
        }} else {for i in from..<to {
            sum += values[i];
        }}
        
        return (Double(sum) / Double(values.count))
    }
    
    /// Returns the average of an array of tests.
    static func testAverage(_ tests: [UserTest]) -> Double {
        let smallArr = tests.filter{!$0.big}.map{Int($0.grade)},
            bigArr = tests.filter{$0.big}.map{Int($0.grade)};
        
        if (smallArr.count > 0 && bigArr.count > 0) {
            let smallAvg = Util.average(smallArr),
                bigAvg = Util.average(bigArr)
            
            return (smallAvg + bigAvg) / 2;
        } else if (smallArr.count == 0) {
            if (bigArr.count == 0) {
                return 0;
            } else {
                return Util.average(bigArr);
            }
        } else if (bigArr.count == 0) {
            return Util.average(smallArr)
        }
        return 0.0;
    }
    
    /// Returns the average of all grades from all subjects.
    static func generalAverage() -> Double{
        let allSubjects = getAllSubjects()
        
        if(allSubjects.count == 0) { return 0.0}
        var a = 0.0
        var subjectCount = Double(allSubjects.count)
        
        for sub in allSubjects{
            if(sub.subjecttests == nil){subjectCount-=1;continue}
            let tests = filterTests(sub)
            if(tests.count == 0){subjectCount-=1;continue}
            a += testAverage(tests)
        }
        
        if((a / Double(subjectCount)).isNaN) {return 0.0}
        return (a / Double(subjectCount))
    }
    
    /// Filtering the tests so you get only the ones which are in active halfyears
    static func filterTests(_ sub: UserSubject)-> [UserTest]{
        if(sub.subjecttests == nil){return []}
        var tests = sub.subjecttests!.allObjects as! [UserTest]
        
        for year in [1,2,3,4]{
            if(!checkinactiveYears(getinactiveYears(sub), year)){
                tests = tests.filter{$0.year != year}
            }
        }
        return tests
    }
    
    /// Returns the average of all grades from all subjects in a specific halfyear
    static func generalAverage(_ year: Int) -> Double{
        let allSubjects = getAllSubjects()
        if(allSubjects.count == 0) { return 0.0}
        var count = 0.0;
        var grades = 0.0;
        
        for sub in allSubjects {
            if(sub.subjecttests == nil){continue}
            let tests = filterTests(sub).filter{Int($0.year) == year}
            if(tests.count == 0){continue}
          
            count += 1
            grades += Util.testAverage(tests)
        }
        if(grades == 0.0){ return 0.0}
        return grades / count
    }
    
    /// Converts the points(0-15) representation of a grade to the more common 1-6 scale.
    static func grade(number: Double) -> Double {
        if(number == 0.0){ return 0.0}
        return ((17 - number) / 3.0)
    }
    
    /// Generates a convient String that shows the grades of the subject.
    static func averageString(_ subject: UserSubject) -> String{
        var str: String = ""
        if(subject.subjecttests == nil) {return str}
        let tests = subject.subjecttests!.allObjects as! [UserTest]
        
        for i in 1...4 {
            let arr = tests.filter({$0.year == i});
            if(arr.count == 0) {str += "-- ";continue}
            str += String(Int(round(Util.testAverage(arr))))
            if(i != 4){ str += " "}
        }
        return str
    }
    
    //MARK: Get Settings
    ///Returns fresh new settings and deletes everything
    static func deleteSettings()-> AppSettings{
        let context = CoreDataStack.shared.managedObjectContext
        
        do {
            let items = try context.fetch(AppSettings.fetchRequest())
            context.delete(items[0])
        }
        catch{
        }
        try! context.save()
        WidgetCenter.shared.reloadAllTimelines()
        return Util.getSettings()!
    }
    
    
    ///Returns the apps settings
    static func getSettings()-> AppSettings?{
        let context = CoreDataStack.shared.managedObjectContext
        
        var items: [AppSettings]
        do {
            items = try context.fetch(AppSettings.fetchRequest())
            
            if(items.count == 0){
                let item =  AppSettings(context: context)
                item.colorfulCharts = false
                item.smoothGraphs = true
                item.firstLaunch = false
                
                try! context.save()
                WidgetCenter.shared.reloadAllTimelines()
                return item
            }
            return items[0]
        }
        catch{        }
        return nil
    }
    
    //MARK: Get Subject
    /// Returns all Subjects as Array
    static func getAllSubjects()-> [UserSubject]{
        let context = CoreDataStack.shared.managedObjectContext
        
        var  allSubjects: [UserSubject] = []
        do {
            let result = try context.fetch(AppSettings.fetchRequest())
            if(result.count == 0) { return []}
            if(result[0].usersubjects != nil){
                allSubjects = result[0].usersubjects!.allObjects as! [UserSubject]
                return sortSubjects(allSubjects)
            }else {return [] }
        }catch {}
        
        return []
    }
    
    /// sort all subjects sorted after type and name
    private static func sortSubjects(_ subs: [UserSubject])-> [UserSubject]{
        let arr1 = subs.filter{$0.lk}.sorted(by: {$0.name! < $1.name! })
        let arr2 = subs.filter{!$0.lk}.sorted(by: {$0.name! < $1.name! })
        return arr1+arr2
    }
    
    /// Returns all Subjects as Array
    static func getAllExamSubjects()-> [UserSubject]{
        let context = CoreDataStack.shared.managedObjectContext
        
        var  allSubjects: [UserSubject] = []
        do {
            let result = try context.fetch(AppSettings.fetchRequest())
            if(result[0].usersubjects != nil){
                allSubjects = result[0].usersubjects!.allObjects as! [UserSubject]
                allSubjects  = allSubjects.filter{$0.examtype != 0}.sorted(by: {$0.name! < $1.name! })
                return allSubjects
            }else {return [] }
        }catch {}
        
        return []
    }
    
    /// Updates the exam points on a subject
    static func updateExampoints(_ type: Int, _ points: Int){
        let subjects = Util.getAllExamSubjects().filter{$0.examtype == Int16(type)}
        if(subjects.count == 0) {return}
        let sub = Util.getSubject(subjects[0].objectID)
        if(sub == nil){return}
        
        if(sub?.exampoints == Int16(points)){return}
        sub!.exampoints = Int16(points)
        
        try! CoreDataStack.shared.managedObjectContext.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    /// Delete exam
    static func deleteExam(_ type: Int){
        let subjects = Util.getAllExamSubjects().filter{$0.examtype == Int16(type)}
        if(subjects.count == 0) {return}
        
        let sub = Util.getSubject(subjects[0].objectID)
        if(sub == nil){return}
        
        sub!.exampoints = 0
        sub!.examtype = 0
        
        try! CoreDataStack.shared.managedObjectContext.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    /// Returns all inactive Years in one array of strings
    static func getinactiveYears(_ sub: UserSubject)-> [String]{
        if(sub.inactiveYears == nil){return []}
        let arr: [String] = sub.inactiveYears!.components(separatedBy: " ")
        return arr
    }
    
    /// Check if year is inactive
    static func checkinactiveYears(_ arr: [String], _ num: Int)-> Bool {
        return !arr.contains(String(num))
    }
    
    /// Remove  inactive halfyear
    static func removeYear(_ sub: UserSubject, _ num: Int) -> UserSubject{
        let arr = getinactiveYears(sub)
        
        sub.inactiveYears = arrToString(arr.filter{$0 != String(num)})
        try! CoreDataStack.shared.managedObjectContext.save()
        WidgetCenter.shared.reloadAllTimelines()
        return sub
    }
    
    /// Add inactive halfyear
    static func addYear(_ sub: UserSubject, _ num: Int) -> UserSubject{
        var arr = getinactiveYears(sub)

        arr.append(String(num))
        sub.inactiveYears = arrToString(arr)
        try! CoreDataStack.shared.managedObjectContext.save()
            WidgetCenter.shared.reloadAllTimelines()
        return sub
    }
                                       
    private static func arrToString(_ arr: [String]) -> String{
        return arr.joined(separator: " ")
        }
    
    /// Returns the last date when a grade was added
    static func calcMaxDate() throws -> Date {
        let allSubjects = self.getAllSubjects().filter{$0.subjecttests?.count != 0}
        if(allSubjects.count == 0) { throw UtilErrors.NoSubjects }
        
        let allDates = allSubjects.map{
            ($0.subjecttests?.allObjects as? [UserTest] ?? [])}
            .map{
                $0.map{
                    $0.date!.timeIntervalSince1970
                }.sorted(by: {$0 > $1})[0]
            }
        if(allDates.count == 0) {return Date(timeIntervalSince1970: 0.0)}
        
        return Date(timeIntervalSince1970: allDates.sorted(by: {$0 > $1})[0])
    }
    
    /// Returns the first date when a grade was added
    static func calcMinDate() throws -> Date {
        let allSubjects = self.getAllSubjects().filter{$0.subjecttests?.count != 0}
        if(allSubjects.count == 0) { throw UtilErrors.NoSubjects }
        
        let allDates = allSubjects.map{
            ($0.subjecttests?.allObjects as? [UserTest] ?? [])}
            .map{
                $0.map{
                    $0.date!.timeIntervalSince1970
                }.sorted(by: {$0 < $1})[0]
            }
        if(allDates.count == 0) { return Date(timeIntervalSince1970: 0.0) }

        return Date(timeIntervalSince1970: allDates.sorted(by: {$0 < $1})[0])
    }
    
    /// Returns one Subject
    static func getSubject(_ subject: UserSubject) -> UserSubject? {
        let all = self.getAllSubjects()
        let filtered = all.filter{$0.objectID == subject.objectID}
        if (filtered.count < 1) {return nil}
        return filtered[0]
    }
    
    /// Returns one Subject after ID
    static func getSubject(_ id: NSManagedObjectID) -> UserSubject? {
        let all = self.getAllSubjects()
        let filtered = all.filter{$0.objectID == id}
        if (filtered.count < 1) {return nil}
        return filtered[0]
    }
    
    ///Returns all Subjectnames
    static func getAllSubjectNames() -> [String] {
        var subjects = Util.getAllSubjects()
        subjects = subjects.sorted(by: {$0.name! < $1.name! })
        return subjects.map{$0.name!}
    }
    
    /// Calc points block I
    static func generateBlockOne() -> Double{
        let subjects = Util.getAllSubjects()
        var sum = 0.0
        var count = 0.0
        if(subjects.count == 0) {return 0.0}
        
        for sub in subjects {
            if(sub.subjecttests == nil) {continue}
            let SubTests = filterTests(sub)
            if(SubTests.count == 0){continue}
            
            for e in 1...4 {
                let tests = SubTests.filter{($0.year == e)}
                if(tests.count == 0)  {continue}
                
                if(sub.lk){
                    sum += 2.0 * Util.testAverage(tests)
                    count += 2.0
                }else {
                    sum += Util.testAverage(tests)
                    count += 1.0
                }
            }
        }
        
        
        
        if(sum == 0 ) {return 0.0}
        return Double((sum / count) * 40.0)
    }
    /// Calc Maxpoints block I
    static func generatePossibleBlockOne() -> Double{
        let subjects = Util.getAllSubjects()
        var sum = 0.0
        var count = 0.0
        if(subjects.count == 0) {return 0.0}
        
        for i in 0..<subjects.count {
            let sub = subjects[i]
            if(sub.subjecttests == nil) {continue}
            let SubTests = sub.subjecttests!.allObjects as! [UserTest]
            
            for e in 1...4 {
                let tests = SubTests.filter{($0.year == e)}
                if(tests.count == 0)  {continue}
                
                if(sub.lk){
                    sum += 2.0 * 15
                    count += 2.0
                } else {
                    sum += 15
                    count += 1.0
                }
            }
        }
        
        if(sum == 0.0 ) {return 0.0}
        return Double((sum / count) * 40.0)
    }
    
    // MARK: Load Demo Data
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
         for sub in subjects {
             string += "{\"name\": \(sub.name!), \"lk\": \(sub.lk), \"color\": \(sub.color!), \"inactiveYears\": \(sub.inactiveYears ?? "") \"subjecttests\": ["

             if(sub.subjecttests == nil){continue}
             let tests = sub.subjecttests!.allObjects as! [UserTest]
             for test in tests{
                 string += "{\"name\": \(test.name!), \"year\": \(test.year), \"grade\":\(test.grade), \"date\": \(test.date!.timeIntervalSince1970), \"big\": \(test.big)},"
             }
             string += "]},"
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
}

// MARK: - UIColor Extension
extension UIColor {
    static var accentColor: UIColor {return UIColor(named: "AccentColor") ??  UIColor.init(hexString: "428FE3")}
}

extension UIColor {
    convenience init(hexString:String) {
        let hexString:String = hexString.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines
        )
        var scanner            = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner = Scanner(string: String(hexString.split(separator: "#")[0]))
        }
        
        var color:UInt64 = 0
        scanner.scanHexInt64(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
}


/// This function returns `true` if there is at least one `test` in at least one `subject`
func checkChartData()-> Bool {
    let arr = Util.getAllSubjects()
    if(arr.count == 0) {return false}
    
    var n = 0
    for sub in arr {
        let tests = Util.filterTests(sub)
        if(sub.subjecttests?.count == 0 || tests.count == 0) {
            n += 1;
        }
    }
    return (n != arr.count)
}


// MARK: - UIStoyboard Extension
extension UIStoryboard {
    func getView(_ identifier: String) -> UIViewController {
        return self.instantiateViewController(withIdentifier: identifier);
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
