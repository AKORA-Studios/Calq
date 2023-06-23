//
//  SmallCircleChart.swift
//  CalqWidgetExtension
//
//  Created by Kiara on 09.03.23.
//

import SwiftUI

struct CircleChartWidgetView: View {
    var body: some View {
        ProgressView("Loading...", value: Util.generalAverage(), total: 15)
            .progressViewStyle(CustomCircularProgressViewStyle())
    }
}

struct CustomCircularProgressViewStyle: ProgressViewStyle {
    let grade = String(format: "%.2f", Util.grade(number: Util.generalAverage()))
    
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            HStack {
                Image(systemName: "chart.bar.fill").font(.system(size: 16.0)).foregroundColor(.accentColor)
                Text("Durchschnitt").foregroundColor(.accentColor)
            }.padding(.top, 10)
            
            ZStack {
                Circle()
                    .trim(from: 0.0, to: 1.0)
                    .stroke(Color(.systemGray4), style: StrokeStyle(lineWidth: 13.0, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 100)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(configuration.fractionCompleted ?? 0))
                    .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 13.0, lineCap: .round))
                    .foregroundColor(.accentColor)
                    .rotationEffect(.degrees(-90))
                    .frame(width: 100)
                
                VStack {
                    Text(String(format: "%.01f", Util.generalAverage()))
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                        .frame(width: 90)
                    Text(grade)
                        .foregroundColor(.accentColor)
                        .frame(width: 90)
                }
            }
        }.padding(.bottom, 10)
    }
}
