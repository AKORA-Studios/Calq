//
//  EditGradeViewModel.swift
//  Calq
//
//  Created by Kiara on 14.01.24.
//

import Foundation

class EditGradeViewModel: ObservableObject {
    @Published var test: UserTest
    
    @Published var testType = Util.getTypes()[0].id
    @Published var testName = ""
    @Published var testYear = 1
    @Published var testDate = Date()
    @Published var testPoints: Float = 9
    
    @Published var lastEditedAt: Date = Date()
    @Published var createdAt: Date = Date()
    
    @Published var deleteAlert = false
    @Published var isWrittenGrade = false
    @Published var shouldShowGradeTypeOptions = false
    
    init(_ newTest: UserTest) {
        test = newTest
        update()
    }
    
    func update() {
        if test.isFault { return }
        testName = test.name
        testYear = Int(test.year)
        testDate = test.date
        testPoints = Float(test.grade)
        testType = test.type
        
        isWrittenGrade = test.isWrittenGrade
        shouldShowGradeTypeOptions = Util.getSettings().showGradeTypes
        
      //  lastEditedAt = test.lastEditedAt
      //  createdAt = test.createdAt
    }
    
    func saveGrade() {
        test.name = testName
        test.year = Int16(testYear)
        test.date = testDate
        test.grade = Int16(testPoints)
        test.type = testType
        test.lastEditedAt = Date()
        
        saveCoreData()
    }
    
}
