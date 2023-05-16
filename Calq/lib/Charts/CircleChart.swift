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
    var textDescription: String = ""
    
    @Binding var upperText: String //= ""
    @Binding var lowerText: String //= ""
    
    @State var showText = false
    @State var degrees: Double = 0.0
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                if(showText && !textDescription.isEmpty){
                    ZStack{
                        Text(LocalizedStringKey(textDescription))
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: geo.size.width - 50, height: geo.size.width - 50)
                }else {
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
                        Text(LocalizedStringKey(upperText))
                            .fontWeight(.bold)
                            .foregroundColor(color)
                        if(!lowerText.isEmpty){
                            Text(LocalizedStringKey(lowerText))
                                .foregroundColor(color)
                        }
                    }
                }
            }
            .padding()
            .onTapGesture {
                withAnimation {
                    if(!textDescription.isEmpty){
                        showText.toggle()
                    }
                }
            }
        }
    }
}
