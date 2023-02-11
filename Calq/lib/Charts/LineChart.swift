//
//  LineChart.swift
//  Calq
//
//  Created by Kiara on 10.02.23.
//

import SwiftUI

struct LineChartValue: Hashable {
    var value: Double
    var date: Double
    var color: Color = .accentColor
}

struct LineChart: View {
    @State var subjects: [UserSubject]
    @State var maxDate = 0.0
    @State var minDate =  0.0
    @State var heigth: CGFloat = 150
    
    @State var values: [[LineChartValue]] = [[]]
    @State var colors: [Color] = []
    
    var body: some View {
        ZStack {
            YAxis()
            YAxisLines()
                ZStack {
                    ForEach(values, id: \.self){v in
                        if(v.count > 0){LineShape(values: v, frame: $heigth).stroke(v[0].color, lineWidth: 2.0)}
                    }
                }
        }.frame(height: heigth)
            .onAppear{
                values = []
                colors = []
                setDates()
                subjects.forEach { sub in
                    values.append(generateData(subject: sub))
                   
                }
            }
            .padding()
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
        let color = getSubjectColor(subject)
        colors.append(color)
        
        var arr: [LineChartValue] = []
        let tests = filterTests(subject, checkinactive : false)
        for test in tests {
            let time = ((test.date.timeIntervalSince1970 / 1000)  - minDate)/maxDate
            arr.append(.init(value: Double(test.grade) / 15.0, date: time, color: color))
        }
        return arr
    }
}

struct LineShape: Shape {
    @State var values: [LineChartValue]
    @Binding var frame: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let valuesSorted = values.sorted(by: {$0.date < $1.date})
        var path = Path()
        path.move(to: CGPoint(x: 0.0, y: frame - valuesSorted[0].value * Double(rect.height)))
        
        for i in 1..<valuesSorted.count {
            let y = frame - (valuesSorted[i].value * Double(rect.height))
            let x = (valuesSorted[i].date * Double(rect.width))
            let pt = CGPoint(x: x, y: y)
            
            path.addLine(to: pt)
        }
        return path
    }
}

var ticks: [LineChartValue] = [LineChartValue(value: 15, date: 1),LineChartValue(value: 10, date: 2/3),LineChartValue(value: 5, date: 1/3),LineChartValue(value: 0, date: 0)]

struct YAxis: View {
 
    var body: some View {
        GeometryReader{geo in
            let fullHeight = geo.size.height
            
            ZStack{
                //y line
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 1)
                    .offset(x: -15)
                //ticks
                ForEach(ticks, id:\.self.value){tick in
                    HStack(spacing: 2){
                      // Spacer()
                        Text(String(Int(tick.value))).font(.footnote)
                        Rectangle().fill(Color.black).frame(width: 5, height: 1)//.frame(height: 1).offset(x: 15)
                    }.offset(y: fullHeight/2 - (fullHeight * tick.date)).offset(x: -20)
                }
            }
        }
    }
}


struct YAxisLines: View {

    var body: some View {
        
        GeometryReader{geo in
            let fullHeight = geo.size.height
            let fullWidth = geo.size.width
            
            ZStack{
                //ticks
                ForEach(ticks, id:\.self.value){tick in
                    HStack(spacing: 2){
                      // Spacer()
                        Text(String(Int(tick.value))).font(.footnote)
                        Rectangle().fill(Color.gray).frame(width: fullWidth, height: 1)//.offset(x: 15)
                    }.offset(y: fullHeight - (fullHeight * tick.date) - 17).offset(x: -5)
                }
            }
        }
    }
}
