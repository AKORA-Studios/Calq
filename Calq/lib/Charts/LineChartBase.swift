//
//  LineChartBase.swift
//  Calq
//
//  Created by Kiara on 22.05.23.
//

import SwiftUI

var ticks: [LineChartEntry] = [LineChartEntry(value: 15, date: 1),
                               LineChartEntry(value: 10, date: 2/3),
                               LineChartEntry(value: 5, date: 1/3),
                               LineChartEntry(value: 0, date: 0)]

/// Draws the polygon line for a given Dataset of points, fitting the given frame
struct LineShape: Shape {
    var values: [LineChartEntry]
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

/// Creates the axis ticks and associated labels
struct YAxis: View {
    @State var averageValue = 0.0
    
    var body: some View {
        GeometryReader {geo in
            let fullHeight = geo.size.height
            
            ZStack {
                // y line
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 1)
                    .offset(x: -15)
                
                // Average line
                if averageValue > 0.0 {
                    HStack(spacing: 2) {
                        // Spacer()
                        Text(String("Ø")).font(.footnote).foregroundColor(grayColor)
                        Rectangle().fill(grayColor).frame(width: 5, height: 1)// .frame(height: 1).offset(x: 15)
                    }.offset(y: fullHeight/2 - (fullHeight * (averageValue)/15)).offset(x: -20)
                }
                
                // ticks
                ForEach(ticks, id: \.self.value) {tick in
                    HStack(spacing: 2) {
                        // Spacer()
                        Text(String(Int(tick.value))).font(.footnote).foregroundColor(Color.gray)
                        Rectangle().fill(Color.gray).frame(width: 5, height: 1)// .frame(height: 1).offset(x: 15)
                    }.offset(y: fullHeight/2 - (fullHeight * tick.date)).offset(x: -20)
                }
            }
        }
    }
}
/// Creates the vertical lines
struct YAxisLines: View {
    @State var averageValue = 0.0
    
    var body: some View {
        GeometryReader { geo in
            let fullHeight = geo.size.height
            let fullWidth = geo.size.width
            
            ZStack {
                // Average line
                if averageValue > 0.0 {
                    HStack(spacing: 2) {
                        Rectangle().fill(grayColor).frame(width: fullWidth, height: 1)
                    }.offset(y: fullHeight - (fullHeight * (( averageValue)/15.0)) - 17).offset(x: -5)
                }
                // ticks
                ForEach(ticks, id: \.self.value) {tick in
                    HStack(spacing: 2) {
                        // Spacer()
                        Text(String(Int(tick.value))).font(.footnote)
                        Rectangle().fill(grayColor).frame(width: fullWidth, height: 1)// .offset(x: 15)
                    }.offset(y: fullHeight - (fullHeight * tick.date) - 17).offset(x: -5)
                }
            }
        }
    }
}

struct LineChartBase_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            ZStack {
                YAxis(averageValue: 7.0)
                YAxisLines(averageValue: 7.0)
            }.padding().frame(width: 350, height: 150)
            ZStack {
                YAxis()
                YAxisLines()
            }.padding().frame(width: 350, height: 150)
        }
    }
}
