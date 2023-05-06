//
//  BlockView.swift
//  Calq
//
//  Created by Kiara on 03.02.23.
//

import SwiftUI

struct BlockView: View {
    @State var points1 = generateBlockOne()
    @State var points2 = generateBlockTwo()
    @State var maxpoints = generatePossibleBlockOne()
    
    @Binding var updateblock2: Bool
    
    var body: some View {
        VStack{
            bars()
        }
        .frame(height: 50)
        .onChange(of: updateblock2) { _ in
            points2 = generateBlockTwo()
        }
        .onAppear{
            points1 = generateBlockOne()
            points2 = generateBlockTwo()
            maxpoints = generatePossibleBlockOne()
        }
    }
    
    func bars() -> some View {
        GeometryReader { geo in
            HStack(alignment: .center){
                VStack(alignment: .leading){
                    Text("Block 1").fontWeight(.bold)
                    RoundProgressBar(value: $points1, max: $maxpoints)
                    Text("\(points1) von \(maxpoints)").foregroundColor(.accentColor).fontWeight(.light)
                }.frame(width: geo.size.width * 2/3 - 20)
                Spacer()
                VStack(alignment: .leading){
                    Text("Block 2").fontWeight(.bold)
                    RoundProgressBar(value: $points2, max: Binding.constant(300))
                    Text("\(points2) von 300").foregroundColor(.accentColor).fontWeight(.light)
                }.frame(width: geo.size.width * 1/3 - 20)
            }.padding(10)
                .background(CardView())
        }
    }
}



struct RoundProgressBar: View { //TODO: does not update on delte/load =.=
    @Binding var value: Int
    @Binding var max: Int
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading){
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.gray)
                
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: (CGFloat(max != 0 ? (value * 100 / max) : 0) * geo.size.width)/100, height: 8)
                    .foregroundColor(.accentColor)
            }.frame( height: 8)
        }
    }
}
