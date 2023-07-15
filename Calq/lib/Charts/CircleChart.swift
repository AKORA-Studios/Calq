//
//  CircleChart.swift
//  Calq
//
//  Created by Kiara on 05.02.23.
//

import SwiftUI

struct CircleChart: View {
    @Binding var percent: Double
    var maxValue: Int = 15
    var color: Color = .accentColor
    var textDescription: String = ""
    
    @Binding var upperText: String
    @Binding var lowerText: String
    
    @State var showText = false
    @State var degrees: Double = 0.0
    
    private let gradient = AngularGradient(
        gradient: Gradient(colors: [Color.red, .white]),
        center: .center,
        startAngle: .degrees(270),
        endAngle: .degrees(0))
    
    private let secondTry = LinearGradient(colors: [Color.red, .white], startPoint: .leading, endPoint: .trailing)
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                if showText && !textDescription.isEmpty {
                    ZStack {
                        Text(LocalizedStringKey(textDescription))
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: geo.size.width - 50, height: geo.size.width - 50)
                } else {
                    ZStack {
                        Circle()
                            .trim(from: 0.0, to: 1.0)
                            .stroke(Color(.systemGray4), style: StrokeStyle(lineWidth: 16.0, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                        
                        Circle() // shadow
                            .trim(from: CGFloat(abs((min(percent, 1.0))-0.001)), to: CGFloat(abs((min(percent, 1.0))-0.0005)))
                            .stroke(color, style: StrokeStyle(lineWidth: 16, lineCap: .round))
                            .rotationEffect(Angle(degrees: -90))
                            .shadow(color: .black, radius: 15, x: 0, y: 0)
                            .clipShape(
                                Circle().stroke(lineWidth: 16)
                            )
                        
                        Circle()
                            .trim(from: 0.0, to: CGFloat(percent))
                            .stroke(color, style: StrokeStyle(lineWidth: 16.0, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                        
                    } .frame(width: geo.size.width - 50)
                    
                    VStack {
                        Text(LocalizedStringKey(upperText))
                            .fontWeight(.bold)
                            .foregroundColor(color)
                        if !lowerText.isEmpty {
                            Text(LocalizedStringKey(lowerText))
                                .foregroundColor(color)
                        }
                    }
                }
            }
            .padding()
            .onAppear {
                showText = false
            }
            .onTapGesture {
                withAnimation {
                    if !textDescription.isEmpty {
                        showText.toggle()
                    }
                }
            }
        }
    }
}

struct CircleChartPreview: PreviewProvider {
    static var previews: some View {
        CircleChart(percent: Binding.constant(0.1), upperText: Binding.constant("a"), lowerText: Binding.constant("b"))
        CircleChart(percent: Binding.constant(0.6), upperText: Binding.constant("a"), lowerText: Binding.constant("b"))
        CircleChart(percent: Binding.constant(1), upperText: Binding.constant("a"), lowerText: Binding.constant("b"))
    }
}
