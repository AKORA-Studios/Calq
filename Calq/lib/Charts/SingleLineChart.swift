//
//  SingleLineChart.swift
//  Calq
//
//  Created by Kiara on 11.02.23.
//

import SwiftUI

struct OneEntryLineChart: View {
    @State var subject: UserSubject
    @State var maxDate = 0.0
    @State var minDate =  0.0
    @State var heigth: CGFloat = 150
    @State var values: [LineChartValue] = []
    
    var body: some View {
        ZStack {
            YAxis()
            YAxisLines()
            ZStack {
                let color = getSubjectColor(subject)
                if(values.count > 0){LineShape(values: values, frame: $heigth).stroke(color, lineWidth: 2.0)}
            }
        }.frame(height: heigth)
            .onAppear{
                setDates()
                values = generateData()
            }
            .padding()
    }
    
    func setDates(){
        let allTests = Util.filterTests(subject, checkinactive: false).sorted{$0.date < $1.date}
        if(allTests.count != 0)  {
            minDate = allTests.first!.date.timeIntervalSince1970 / 1000
            maxDate = allTests.last!.date.timeIntervalSince1970 / 1000 - minDate
        } else {            maxDate = 0.0
            minDate = 0.0
        }
    }
    
    func generateData() -> [LineChartValue]{
        //let color = getSubjectColor(subject)
        var arr: [LineChartValue] = []
        let tests = Util.filterTests(subject, checkinactive : false)
        for test in tests {
            let time = ((test.date.timeIntervalSince1970 / 1000)  - minDate)/maxDate
            arr.append(.init(value: Double(test.grade) / 15.0, date: time))
        }
        return arr
    }
}
