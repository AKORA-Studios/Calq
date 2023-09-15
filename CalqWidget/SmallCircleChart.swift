//
//  SmallCircleChart.swift
//  CalqWidgetExtension
//
//  Created by Kiara on 09.03.23.
//

import SwiftUI

struct CircleChartWidgetView: View {
    let data: CircleChartData
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chart.bar.fill").font(.system(size: 16.0)).foregroundColor(.accentColor)
                Text("Durchschnitt").foregroundColor(.accentColor)
            }.padding(.top, 10)
            
            CircleChart(percent: Binding.constant(data.percent), upperText: Binding.constant(data.upperText), lowerText: Binding.constant(data.lowerText))
            
        }.padding(.bottom, 10)
    }
}

struct CircleChartData {
    var percent: Double
    var upperText: String
    var lowerText: String
    
    static let example = CircleChartData(percent: 0.5, upperText: "7.5", lowerText: "3.0")
}

func circleChartData() -> CircleChartData {
    let average = Util.generalAverage()
    let percent = Util.generalAverage() / 15
    let grade = String(format: "%.2f", Util.grade(number: average))
    let points = String(format: "%.2f", average)
    return CircleChartData(percent: average / 15, upperText: points, lowerText: grade)
}
