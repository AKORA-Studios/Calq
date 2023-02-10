//
//  LineChart.swift
//  TestBarChart
//
//  Created by Kiara on 10.02.23.
//

import SwiftUI

struct LineChart: View {//TODO: First launch screen
    @Binding var subjects: [UserSubject]
    @State var maxDate = 0.0
    @State var minDate =  0.0
    @State var heigth: CGFloat = 150
    
    var body: some View {
        ZStack {
            ForEach(subjects){sub in
                let color = getSubjectColor(sub)
                let values = generateData(subject: sub)
                if(values.count > 0){LineShape(values: values).stroke(color, lineWidth: 2.0)}
            }
        }.frame(height: heigth)
            .onAppear{
                setDates()
            }
    }
    func setDates(){
        let allSubjects = subjects.filter{$0.subjecttests?.count != 0}
        if(allSubjects.count != 0)  {
            minDate = Util.calcMinDate().timeIntervalSince1970 / 1000
            maxDate = Util.calcMaxDate().timeIntervalSince1970 / 1000 - minDate
        } else {            maxDate = 0.0
            minDate = 0.0
        }
    }
    
    func generateData(subject: UserSubject) -> [LineChartValue]{
        var arr: [LineChartValue] = []
        let tests = filterTests(subject, checkinactive : false)
        for test in tests {
            let time = ((test.date.timeIntervalSince1970 / 1000)  - minDate)/maxDate
            arr.append(.init(value: Double(test.grade) / 15.0, date: time))
        }
        return arr
    }
}

struct LineShape: Shape {
    @State var values: [LineChartValue]
    
    func path(in rect: CGRect) -> Path {
        let valuesSorted = values.sorted(by: {$0.date < $1.date})
        var path = Path()
        path.move(to: CGPoint(x: 0.0, y: 150 - valuesSorted[0].value * Double(rect.height)))
        
        for i in 1..<valuesSorted.count {
            let y = 150 - (valuesSorted[i].value * Double(rect.height))
            let x = (valuesSorted[i].date * Double(rect.width))
            let pt = CGPoint(x: x, y: y)
            
            path.addLine(to: pt)
        }
        return path
    }
}

struct LineChartValue {
    var value: Double
    var date: Double
}
