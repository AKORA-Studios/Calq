//
//  LineChart.swift
//  Calq
//
//  Created by Kiara on 10.02.23.
//

import SwiftUI

let grayColor = Color.gray.opacity(0.3)

struct LineChartEntry: Hashable {
    var value: Double
    var date: Double
    var color: Color = .accentColor
    
    static let example = [[
        LineChartEntry(value: 1.0, date: 1685614799, color: Color.orange),
        LineChartEntry(value: 0.4, date: 1686046799, color: Color.orange),
        LineChartEntry(value: 0.9, date: 1686565199, color: Color.orange),
        LineChartEntry(value: 0.5, date: 1687256399, color: Color.orange)
    ],
                          [
                            LineChartEntry(value: 0.4, date: 1685614799, color: Color.blue),
                            LineChartEntry(value: 0.8, date: 1686565199, color: Color.blue),
                            LineChartEntry(value: 0.5, date: 1687256399, color: Color.blue)
                          ]]
    
    static func getData() -> [[LineChartEntry]] {
        let subjects = Util.getAllSubjects()
        var arr: [[LineChartEntry]] = []
        for sub in subjects {
            if !sub.showInLineGraph { continue }
            var subArr: [LineChartEntry] = []
            let tests = Util.getAllSubjectTests(sub)
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

struct LineChart: View {
    @Binding var data: [[LineChartEntry]]
    @State var heigth: CGFloat = 150
    
    var body: some View {
        ZStack {
            YAxis()
            YAxisLines()
            ZStack {
                ForEach(values(), id: \.self) {v in
                    if v.count > 0 {LineShape(values: v, frame: $heigth).stroke(v[0].color, lineWidth: 2.0)}
                }
            }
        }
        .frame(height: heigth)
        .padding()
    }
    
    func values() -> [[LineChartEntry]] {
        
        var arrV: [LineChartEntry] = []
        for v in data {
            for e in v {
                arrV.append(e)
            }
        }
        
        // (minDate, maxDate)
        let sorted = arrV.sorted(by: {$0.date > $1.date})
        var dateRange = (sorted.last?.date ?? 1.0, sorted.first?.date ?? 1.0)
        dateRange = (dateRange.0, dateRange.1-dateRange.0)
        
        var arr: [[LineChartEntry]] = []
        
        for x in data {
            var arrD: [LineChartEntry] = []
            for e in x {
                arrD.append(LineChartEntry(value: e.value, date: (e.date - dateRange.0) / dateRange.1, color: e.color))
            }
            arr.append(arrD)
        }
        return arr
    }
}

struct LineChart_Preview: PreviewProvider {
    static var previews: some View {
        LineChart(data: Binding.constant(LineChartEntry.example))
            .padding()
    }
}
