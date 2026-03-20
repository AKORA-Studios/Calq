//
//  MediumBarChart.swift
//  CalqWidgetExtension
//
//  Created by Kiara on 09.03.23.
//

import SwiftUI

struct BarChartWidgetView: View {
    var values: [BarChartEntry]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geo in
            let fullHeigth = geo.size.height - 10
            if #available(iOS 17.0, *) {
                bodyView(fullHeigth)
                    .containerBackground(for: .widget, content: {})
            } else {
                bodyView(fullHeigth)
                    .background(widgteBackground(colorScheme))
            }
        }
    }
    
    func bodyView(_ fullHeigth: CGFloat) -> some View {
        VStack(alignment: .center) {
            if values.isEmpty {
                EmptyMediumView()
            } else {
                BarChart(values: Binding.constant(values), heigth: fullHeigth)
            }
        }.padding(10)
    }
}

struct HalfyearBarChartWidgetView: View {
    var values: [BarChartEntry]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geo in
            let fullHeigth = geo.size.height - 10
            if #available(iOS 17.0, *) {
                bodyView(fullHeigth)
                    .containerBackground(for: .widget, content: {})
            } else {
                bodyView(fullHeigth)
                    .background(widgteBackground(colorScheme))
            } // ios 26
        }
    }
    
    func bodyView(_ fullHeigth: CGFloat) -> some View {
        VStack(alignment: .center) {
            if values.isEmpty {
                EmptyMediumView()
            } else {
                BarChart(values: Binding.constant(values), heigth: fullHeigth)
            }
        }.padding(10)
    }
}

struct EmptyMediumView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
                Text("widgetBarChartNoData").multilineTextAlignment(.center)
                Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
            }
            Spacer()
        }
        .padding()
    }
}
