//
//  SubjectListVM.swift
//  Calq
//
//  Created by Kiara on 20.06.23.
//

import Foundation
import SwiftUI

struct SubjectlistData: Hashable {
    var subject: UserSubject
    var yearString: [String]
    var colors: [Color]
}

class SubjectListVM: ObservableObject {
    @Published var data: [SubjectlistData] =  Util.getAllSubjects().map {SubjectlistData(subject: $0, yearString: setAverages(subject: $0), colors: getcolorArr(subject: $0))}
    @Published var subjects: [UserSubject] =  Util.getAllSubjects()
    @Published var selectedSubejct: UserSubject?
    
    @Published var inactiveCount = 0
    @Published var subjectCount = 0
    
    @Published var gradeTablePresented = false
    @Published var isSubjectDetailPResented = false
    
    init() {
        subjects = Util.getAllSubjects()
        inactiveCount = (subjects.count * 4) - calcInactiveYearsCount()
        subjectCount = subjects.count * 4
    }
    
    func selectSubject(_ subject: UserSubject) {
        selectedSubejct = subject
        isSubjectDetailPResented = true
    }
    
    func updateViews() {
        self.objectWillChange.send()
        subjects = Util.getAllSubjects()
        inactiveCount = (subjects.count * 4) - calcInactiveYearsCount()
        subjectCount = subjects.count * 4
        
        data = []
        subjects.forEach { sub in
            data.append(SubjectlistData(subject: sub, yearString: setAverages(subject: sub), colors: getcolorArr(subject: sub)))
        }
    }
    
    func calcInactiveYearsCount() -> Int {
        if subjects.count == 0 { return 0 }
        var count: Int = 0
        
        for sub in subjects {
            let arr = Util.getinactiveYears(sub)
            for num in arr {
                if num == "" { continue }
                if Int(num) != nil { count += 1}
            }
        }
        return count
    }
}

private func getcolorArr(subject: UserSubject) -> [Color] {
    var arr = [Color.gray, Color.gray, Color.gray, Color.gray, Color.gray]
    let inactiveYears = Util.getinactiveYears(subject)
    
    inactiveYears.forEach { year in
        if year.isEmpty { return }
        if let y = Int(year) {
            arr[y - 1] = Color.red
        }
    }
    return arr
}

private func setAverages(subject: UserSubject) -> [String] {
    var arr = ["-", "-", "-", "-"]
    for i in 0...3 {
        arr[i] = String(format: "%.0f", Util.getSubjectAverage(subject, year: i+1, filterinactve: false))
    }
    return arr
}
