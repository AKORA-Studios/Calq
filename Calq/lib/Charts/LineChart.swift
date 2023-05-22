//
//  LineChart.swift
//  Calq
//
//  Created by Kiara on 10.02.23.
//

import SwiftUI

let grayColor = Color.gray.opacity(0.3)

struct LineChartValue: Hashable {
    var value: Double
    var date: Double
    var color: Color = .accentColor
}

extension LineChartValue {
    static let example = [
        LineChartValue(value: 2, date: 0, color: Color.orange),
         LineChartValue(value: 11, date: 2, color: Color.orange),
          LineChartValue(value: 9, date: 4, color: Color.orange),
           LineChartValue(value: 13, date: 5, color: Color.orange)
    ]
}

struct LineChartNew: View {
    @Binding var data: [[LineChartValue]]
    @State var heigth: CGFloat = 150

 var body: some View {
     ZStack {
            YAxis()
            YAxisLines()
            ZStack {
                ForEach(values(), id: \.self){v in
                    if(v.count > 0){LineShape(values: v, frame: $heigth).stroke(v[0].color, lineWidth: 2.0)}
                }
            }
        }
        .frame(height: heigth)
        .padding()
 }

   func values() -> [[LineChartValue]] {
        // (minDate, maxDate)
        let sorted = values.sorted(by: {$0.date > $1.date})
        let dateRange = (sorted.last, sorted.first )
        var arr: [LineChartValue] = []

        for v in value {
            arr.append( LineChartValue(value: v.value, date: v.date - dateRange.1, color: v.color))
        }
        return arr
    }
}

struct LineChart: View {
    @Binding var subjects: [UserSubject]
    @State var heigth: CGFloat = 150
    
    var body: some View {
        ZStack {
            YAxis()
            YAxisLines()
            ZStack {
                ForEach(values(), id: \.self){v in
                    if(v.count > 0){LineShape(values: v, frame: $heigth).stroke(v[0].color, lineWidth: 2.0)}
                }
            }
        }
        .frame(height: heigth)
        .padding()
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
                    .fill(Color.gray)
                    .frame(width: 1)
                    .offset(x: -15)
                //ticks
                ForEach(ticks, id:\.self.value){tick in
                    HStack(spacing: 2){
                        // Spacer()
                        Text(String(Int(tick.value))).font(.footnote).foregroundColor(Color.gray)
                        Rectangle().fill(Color.gray).frame(width: 5, height: 1)//.frame(height: 1).offset(x: 15)
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
                        Rectangle().fill(grayColor).frame(width: fullWidth, height: 1)//.offset(x: 15)
                    }.offset(y: fullHeight - (fullHeight * tick.date) - 17).offset(x: -5)
                }
            }
        }
    }
}
