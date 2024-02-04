//
//  OverviewVM.swift
//  Calq
//
//  Created by Kiara on 01.03.23.
//

import Foundation

class OverViewViewModel: ObservableObject {
    @Published var subjects: [UserSubject] = []
    
    @Published var blockPoints: Double = getBlockPoints()
    @Published var blockPercent = (getBlockPoints()/900.0)
    @Published var gradeText = grade()
    @Published var blockCircleText = getGradeData()
    
    @Published var subjectValues: [BarChartEntry] = BarChartEntry.getData()
    @Published var halfyears: [BarChartEntry] = BarChartEntry.getDataHalfyear()
    @Published var lineChartEntries: [[LineChartEntry]] = LineChartEntry.getData()
    
    @Published var averageText: String = String(format: "%.2f", Util.generalAverage())
    @Published var averagePercent: Double = Util.generalAverage() / 15
    @Published var generalAverage = Util.generalAverage()
    
    @Published var showGraphEdit = false
    
    func updateViews() {
        print(UserDefaults.standard.object(forKey: "savedArray"))
        self.objectWillChange.send()
        subjects = Util.getAllSubjects()
        blockPoints = Double(generateBlockOne()) + Double(generateBlockTwo())
        blockPercent = Double((blockPoints/900.0))
        blockCircleText = OverViewViewModel.getGradeData()
        
        subjectValues = BarChartEntry.getData()
        halfyears = BarChartEntry.getDataHalfyear()
        lineChartEntries = LineChartEntry.getData()
        
        averageText = String(format: "%.2f", Util.generalAverage())
        averagePercent = Util.generalAverage() / 15
        generalAverage = Util.generalAverage()
        gradeText = OverViewViewModel.grade()
        
        if shouldAskForReview() { // show appstore review popup
            askForReview()
        }
        
        JSON.saveBackup()
    }
    
    static func getBlockPoints() -> Double {
        Double(generateBlockOne()) + Double(generateBlockTwo())
    }
    
    static func grade() -> String {
        return String(format: "%.2f", Util.grade(number: Util.generalAverage()))
    }
    
    static func getGradeData() -> String {
        let blockGrade = Util.grade(number: Double(getBlockPoints() * 15 / 900))
        return  String(format: "%.2f", blockGrade)
    }
}
