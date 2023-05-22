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
        LineChartValue(value: 1.0, date: 1685614799, color: Color.orange),
        LineChartValue(value: 0.4, date: 1686046799, color: Color.orange),
        LineChartValue(value: 0.9, date: 1686565199, color: Color.orange),
        LineChartValue(value: 0.5, date: 1687256399, color: Color.orange)
    ]
}

struct LineChart: View {
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
     
        var arrV: [LineChartValue] = []
        for v in data {
            for e in v {
                arrV.append(e)
            }
        }
        
        // (minDate, maxDate)
        let sorted = arrV.sorted(by: {$0.date > $1.date})
        var dateRange = (sorted.last?.date ?? 1.0, sorted.first?.date ?? 1.0)
        dateRange = (dateRange.0, dateRange.1-dateRange.0)
        
        var arr: [[LineChartValue]] = []
        
        for x in data {
            var arrD: [LineChartValue] = []
            for e in x {
                arrD.append(LineChartValue(value: e.value, date: (e.date - dateRange.0) / dateRange.1, color: e.color))
            }
            arr.append(arrD)
        }
        return arr
    }
}


struct LineShape: Shape {
    @State var values: [LineChartValue]
    @Binding var frame: CGFloat
    
    func path(in rect: CGRect) -> Path {
        print(values)
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
