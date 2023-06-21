//
//  SubjectListVM.swift
//  Calq
//
//  Created by Kiara on 20.06.23.
//

import Foundation
import SwiftUI

class SubjectListVM: ObservableObject {
    @Published var data: [SubjectlistData] = []
    @Published var  subjects: [UserSubject] = []
    @Published var selectedSubejct: UserSubject?
    
    @Published var inactiveCount = 0
    @Published var subjectCount = 0
    
    func updateViews(){
        self.objectWillChange.send()
        subjects = Util.getAllSubjects()
        inactiveCount = (subjects.count * 4) - calcInactiveYearsCount()
        subjectCount = subjects.count * 4
        
        data = []
        subjects.forEach { sub in
            data.append(SubjectlistData(subject: sub, yearString: setAverages(subject: sub), colors: getcolorArr(subject: sub)))
        }
    }
    
    func getcolorArr(subject: UserSubject) -> [Color]{
        var arr = [Color.gray, Color.gray, Color.gray, Color.gray, Color.gray]
        let inactiveYears = Util.getinactiveYears(subject)
        
        inactiveYears.forEach { year in
            if(year.isEmpty){return}
            arr[Int(year)! - 1] = Color.red
        }
        return arr
    }
    
    func setAverages(subject: UserSubject) -> [String]{
        var arr = ["-","-","-","-"]
        for i in 0...3{
            arr[i] = String(format: "%.0f", Util.getSubjectAverage(subject, year: i+1, filterinactve: false))
        }
        return arr
    }
    
    func calcInactiveYearsCount()-> Int{
        if(subjects.count == 0) {return 0}
        var count: Int = 0
        
        for sub in subjects {
            let arr = Util.getinactiveYears(sub)
            for num in arr {
                if(num == "") {continue}
                if Int(num) != nil { count += 1}
            }
        }
        return count
    }
}
