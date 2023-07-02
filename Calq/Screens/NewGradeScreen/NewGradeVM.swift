//
//  NewGradeVM.swift
//  Calq
//
//  Created by Kiara on 21.06.23.
//

import Foundation

class NewGradeVM: ObservableObject {
    @Published var subjects: [UserSubject] = Util.getAllSubjects()
    @Published var isNewGradeSheetPresented = false
    @Published var selectedSubject: UserSubject?
    
    // NewGradeView
    @Published var gradeName = ""
    @Published var gradeType = Util.getTypes()[0].id
    @Published var year = 1
    @Published var points: Float = 9
    @Published var date = Date()
    @Published var isAlertPresented = false
    
    func updateViews() {
        self.objectWillChange.send()
        subjects = Util.getAllSubjects()
    }
    
    func selectSub(_ sub: UserSubject) {
        selectedSubject = sub
        isNewGradeSheetPresented = true
        
        year = Util.lastActiveYear(selectedSubject!)
        points = Float(Util.getSubjectAverage(selectedSubject!))
        gradeName = ""
    }
    
    func saveGrade() {
        if Util.isStringInputInvalid(gradeName) {
            isAlertPresented = true
            return
        }
        
        let newTest = UserTest(context: Util.getContext())
        newTest.name = gradeName
        newTest.grade =  Int16(points)
        newTest.date = date
        newTest.type = gradeType
        newTest.year = Int16(year)
        
        selectedSubject!.addToSubjecttests(newTest)
        saveCoreData()
        
        isNewGradeSheetPresented = false
    }
    
}
