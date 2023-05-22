//
//  LineChartWidgetViewmodel.swift
//  CalqWidgetExtension
//
//  Created by Kiara on 22.05.23.
//

import Foundation

class LineChartWidgetViewmodel: ObservableObject {
    @Published var lineChartEntries: [[LineChartValue]] = []
    
    func updateViews(){
        self.objectWillChange.send()
        lineChartEntries = lineChartData()
    }
        
        func lineChartData() -> [[LineChartValue]] {
            let subjects = Util.getAllSubjects()
            var arr: [[LineChartValue]] = []
            
            for sub in subjects {
                var subArr: [LineChartValue] = []
                let tests = Util.filterTests(sub, checkinactive : false)
                let color = getSubjectColor(sub, subjects: subjects)
                
                for test in tests {
                    let time = (test.date.timeIntervalSince1970 / 1000)
                    subArr.append(.init(value: Double(test.grade) / 15.0, date: time, color: color))
                }
                arr.append(subArr)
            }
            return arr
        }
}
