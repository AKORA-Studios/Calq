//
//  ExamVM.swift
//  Calq
//
//  Created by Kiara on 03.02.23.
//

import Foundation

class ExamViewModel: ObservableObject {
    @Published var subjects: [UserSubject] = []
    @Published var options: [UserSubject] = []
    
    func updateViews(){
        self.objectWillChange.send()
        subjects = Util.getAllSubjects()
        options = subjects.filter{$0.examtype == 0}
    }
}

//MARK: Exam Managment
func getExam(_ type: Int)-> UserSubject? {
    let subjects = Util.getAllSubjects()
    return subjects.filter{$0.examtype == Int16(type)}.first
}

func getExamOptions(_ subjects: [UserSubject])-> [UserSubject] {
    return subjects.filter{$0.examtype == 0}
}

func resetExams(){
    let subjects = Util.getAllSubjects()
    subjects.forEach { sub in
        sub.examtype = Int16(0)
    }
    saveCoreData()
}

func saveExam(_ type: Int, _ subject: UserSubject){
    let subjects = Util.getAllSubjects()
    subjects.forEach { sub in
        if(sub.examtype == type){ sub.examtype = 0}
    }
    
    subject.examtype = Int16(type)
    saveCoreData()
}

func setExamPoints(_ points: Int, _ subject: UserSubject){
    subject.exampoints = Int16(points)
    saveCoreData()
}

func removeExam(_ type: Int,  _ subject: UserSubject){
    subject.examtype = Int16(0)
    saveCoreData()
}

//MARK: Bock Calculations
/// Calc points block I
func generateBlockOne() -> Int{
    let subjects = Util.getAllSubjects()
    var sum = 0
    var count = 0
    if(subjects.count == 0) {return 0}
    
    for sub in subjects {
        if(sub.subjecttests == nil) {continue}
        let SubTests = Util.filterTests(sub)
        if(SubTests.count == 0){continue}
        
        let multiplier = sub.lk ? 2 : 1
        
        for e in 1...4 {
            let tests = SubTests.filter{($0.year == e)}
            if(tests.count == 0)  {continue}
            
            sum += multiplier * Int(round(Util.testAverage(tests)))
            count += multiplier * 1
        }
    }
    
    if(sum == 0 ) {return 0}
    return Int((sum / count) * 40)
}

/// Calc points block II
func generateBlockTwo() -> Int{
    let subjects = Util.getAllSubjects().filter{$0.examtype != 0}
    if(subjects.count == 0){return 0}
    var sum: Double = 0
    
    for sub in subjects {
            sum += Double(Int(sub.exampoints) * 4)
    }
    
    return Int(sum)
}
/// Calc Maxpoints block I
func generatePossibleBlockOne() -> Int{
    let subjects = Util.getAllSubjects()
    var sum = 0
    var count = 0
    if(subjects.count == 0) {return 0}
    
    for i in 0..<subjects.count {
        let sub = subjects[i]
        if(sub.subjecttests == nil) {continue}
        let SubTests = sub.subjecttests!.allObjects as! [UserTest]
        
        for e in 1...4 {
            let tests = SubTests.filter{($0.year == e)}
            if(tests.count == 0)  {continue}
            
            if(sub.lk){
                sum += 2 * 15
                count += 2
            } else {
                sum += 15
                count += 1
            }
        }
    }
    
    if(sum == 0 ) {return 0}
    return Int(Double((sum / count) * 40))
}
