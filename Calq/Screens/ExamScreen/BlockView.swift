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
    @State var maxpoints1 = generatePossibleBlockOne()
    
    var body: some View {
        GeometryReader { geo in
        ZStack{
            RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.3))
            HStack(alignment: .center){
                VStack{
                    Text("Block 1").fontWeight(.bold)
                    RoundProgressBar(value: (points1 * 100 / maxpoints1))
                    Text("\(points1) von \(maxpoints1)").foregroundColor(.accentColor).fontWeight(.light)
                }.frame(width: geo.size.width * 2/3 - 20)
                Spacer()
                VStack{
                    Text("Block 2").fontWeight(.bold)
                    RoundProgressBar(value: (points2 * 100 / 300))
                    Text("\(points2) von 300").foregroundColor(.accentColor).fontWeight(.light)
                }.frame(width: geo.size.width * 1/3 - 20)
            }.padding(10)
        }.frame(height: 50)
        }
    }
}



struct RoundProgressBar: View {
    @State var value: Int
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading){
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.gray)
                
                RoundedRectangle(cornerRadius: 8).frame(width: (CGFloat(value) * geo.size.width)/100, height: 10)
                    .foregroundColor(.accentColor)
            }.frame( height: 10)
        }
    }
}
