//
//  ExamVM.swift
//  Calq
//
//  Created by Kiara on 03.02.23.
//

import Foundation


//MARK: Exam Managment
func getExam(_ type: Int)-> UserSubject? {
    let settings = getSettings()
    if(type < 1 || type > 5){return nil}
    switch type {
    case 1:
        return settings!.exam1
    case 2:
        return settings!.exam2
    case 3:
        return settings!.exam3
    case 4:
        return settings!.exam4
    case 5:
        return settings!.exam5
    default:
        return nil
    }
}


func saveExam(_ type: Int, _ subject: UserSubject){
    let settings = getSettings()
    let context = CoreDataStack.shared.managedObjectContext
    
    if(type < 1 || type > 5){return}
    switch type {
    case 1:
         settings!.exam1 = subject
    case 2:
         settings!.exam2 = subject
    case 3:
         settings!.exam3 = subject
    case 4:
         settings!.exam4 = subject
    case 5:
         settings!.exam5 = subject
    default:
        return
    }
    try! context.save()
}


func setExamPoints(_ points: Int, _ subject: UserSubject){
    let context = CoreDataStack.shared.managedObjectContext
    subject.exampoints = Int16(points)
    try! context.save()
}


func removeExam(_ type: Int){
    let context = CoreDataStack.shared.managedObjectContext
    let settings = getSettings()
    
    switch type {
    case 1:
        settings!.exam1 = nil
    case 2:
        settings!.exam2 = nil
    case 3:
        settings!.exam3 = nil
    case 4:
        settings!.exam4 = nil
    case 5:
        settings!.exam5 = nil
    default:
        return
    }
    try! context.save()
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
        let SubTests = filterTests(sub)
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
    let subjects = getAllExamSubjects()
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
