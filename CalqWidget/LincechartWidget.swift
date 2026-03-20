//
//  LincechartWidget.swift
//  CalqWidgetExtension
//
//  Created by Kiara on 20.11.23.
//

import SwiftUI

struct LincechartWidget: View {
    @Environment(\.colorScheme) var colorScheme
    var lineChartData: [[LineChartEntry]]
    
    var body: some View {
        GeometryReader { geo in
            if #available(iOS 17.0, *) {
                LineChart(data: Binding.constant(lineChartData), heigth: geo.size.height - 50)
                    .padding()
                    .containerBackground(for: .widget, content: {})
            } else {
                LineChart(data: Binding.constant(lineChartData), heigth: geo.size.height - 50)
                    .padding()
                    .background(widgteBackground(colorScheme))
            }
        }
    }
}
