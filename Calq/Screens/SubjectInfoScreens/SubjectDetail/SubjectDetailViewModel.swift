//
//  SubjectDetailViewModel.swift
//  Calq
//
//  Created by Kiara on 13.12.23.
//

import Foundation
import SwiftUI

class SubjectDetailViewModel: ObservableObject, SegmentedPickerViewDelegate {
    
    func changedIndex(_ index: Int) {
        selectedYear = index + 1
        update()
    }
    
    @Published var subject: UserSubject
    @Published var selectedYear = 1
    @Published var halfyearActive = false
    @Published var hasTest = false
    @Published var yearAverage = 0.0
    @Published var yearAverageText = "-"
    @Published var isGradeTablePresented = false
    @Published var isLineChartInfoPresented = false
    
    @Published var pickerVM = SegmentedPickerViewModel()
    
    init(subject: UserSubject) {
        self.subject = subject
        pickerVM.delegate = self
        
        selectedYear = Util.lastActiveYear(subject)
        pickerVM.selectedIndex = selectedYear - 1
        update()
    }
    
    func update() {
        withAnimation {
            let average = Util.getSubjectAverage(subject, year: selectedYear, filterinactve: false)
            yearAverage = average / 15.0
            yearAverageText = String(format: "%.2f", average)
            halfyearActive = Util.checkinactiveYears(Util.getinactiveYears(subject), selectedYear)
        }
        hasTest = !Util.getAllSubjectTests(subject).isEmpty
    }
    
    func toggleHalfyear() {
        if halfyearActive { // deactivate
            Util.addYear(subject, selectedYear)
        } else { // activate
            Util.removeYear(subject, selectedYear)
        }
        saveCoreData()
        halfyearActive.toggle()
    }
    
    func lineChartData() -> [[LineChartEntry]] {
        var arr: [[LineChartEntry]] = []
        var subArr: [LineChartEntry] = []
        
        let tests = Util.getAllSubjectTests(subject)
        let color = getSubjectColor(subject)
        
        for test in tests {
            let time = (test.date.timeIntervalSince1970 / 1000)
            subArr.append(.init(value: Double(test.grade) / 15.0, date: time, color: color))
        }
        arr.append(subArr)
        return arr
    }
}
