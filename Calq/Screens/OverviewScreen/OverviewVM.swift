//
//  OverviewVM.swift
//  Calq
//
//  Created by Kiara on 01.03.23.
//

import Foundation

class OverViewViewModel: ObservableObject {
    @Published var subjects: [UserSubject] = []
    
    @Published var blockPoints: Double = 0.0
    @Published var blockPercent = 0.0
    @Published var gradeText = ""
    @Published var blockCircleText = ""
    
    @Published var subjectValues: [BarChartEntry] = BarChartEntry.getData()
    @Published var halfyears: [BarChartEntry] = BarChartEntry.getDataHalfyear()
    @Published var lineChartEntries: [[LineChartEntry]] = LineChartEntry.getData()
    
    @Published var averageText: String = ""
    @Published var averagePercent: Double = 0.0
    @Published var generalAverage = 0.0
    
    @Published var showGraphEdit = false
    
    func updateViews() {
        self.objectWillChange.send()
        subjects = Util.getAllSubjects()
        blockPoints = Double(generateBlockOne()) + Double(generateBlockTwo())
        blockPercent = Double((blockPoints/900.0))
        blockCircleText = getGradeData()
        
        subjectValues = BarChartEntry.getData()
        halfyears = BarChartEntry.getDataHalfyear()
        lineChartEntries = LineChartEntry.getData()
        
        averageText = String(format: "%.2f", Util.generalAverage())
        averagePercent = Util.generalAverage() / 15
        generalAverage = Util.generalAverage()
        gradeText = grade()
        
        if shouldAskForReview() { // show appstore review popup
            askForReview()
        }
    }
    
    func grade() -> String {
        return String(format: "%.2f", Util.grade(number: Util.generalAverage()))
    }
    
    func getGradeData() -> String {
        let blockGrade = Util.grade(number: Double(blockPoints * 15 / 900))
        return  String(format: "%.2f", blockGrade)
    }
}
