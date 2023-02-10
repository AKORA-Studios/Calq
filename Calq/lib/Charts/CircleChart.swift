//
//  CircleChart.swift
//  Calq
//
//  Created by Kiara on 05.02.23.
//

import SwiftUI

struct CircleChart: View {
    @Binding var perrcent: Double
    var maxValue: Int = 15
    var color: Color = .accentColor
    
    @Binding var upperText: String //= ""
    @Binding var lowerText: String //= ""
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                Circle()
                    .trim(from: 0.0, to: 1.0)
                    .stroke(Color(.systemGray4), style: StrokeStyle(lineWidth: 16.0, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: geo.size.width - 50)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(perrcent))
                    .stroke(color, style: StrokeStyle(lineWidth: 16.0, lineCap: .round))
                    .foregroundColor(.accentColor)
                    .rotationEffect(.degrees(-90))
                    .frame(width: geo.size.width - 50)
                
                VStack{
                    Text(upperText)
                        .fontWeight(.bold)
                        .foregroundColor(color)
                    if(!lowerText.isEmpty){
                        Text(lowerText )
                            .foregroundColor(color)
                    }
                }
            }.padding()
        }
    }
}
